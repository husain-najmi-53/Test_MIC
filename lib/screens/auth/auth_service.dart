import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:motor_insurance_app/notification_services/flutter_local_notification_service.dart';
import 'package:motor_insurance_app/screens/auth/single_device_check.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:uuid/uuid.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  //final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// 🔹 Signup user with Email, Phone & Password
  Future<String?> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String occupation,
    required String state,
    required String city,
  }) async {
    try {
      //  1. Check if phone already exists in Firestore
      var existing = await _db
          .collection('users')
          .where('phone', isEqualTo: phone)
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        return "Phone number already registered. Please use another.";
      }

      // 2. Create user with email & password in Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;
      String? token = await FirebaseMessaging.instance.getToken();
      String deviceId = await SingleDeviceCheck.getCurrentDeviceId();
      print("Device ID: $deviceId");
      print("FCM Token: $token");

      // 3. Save all extra user details in Firestore
      if (user != null) {
        await _db.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'phone': phone,
          'occupation': occupation,
          'state': state,
          'city': city,
          'deviceId': deviceId,
          'token': token,
          'createdAt': Timestamp.now(),
        });
        // Send verification email
        await result.user?.sendEmailVerification();
        return null; // ✅ Success
      }

      return "Unknown error occurred. Please try again.";
    } on FirebaseAuthException catch (e) {
      return _getFirebaseAuthError(e);
    } catch (e) {
      return "Something went wrong. Please try again.";
    }
  }

  /// 🔹 Sign in with Email/Phone & Password
  Future<String?> signIn({
    required String identifier,
    required String password,
  }) async {
    try {
      String emailToUse = identifier;

      // If identifier is NOT an email, assume it's a phone number
      if (!identifier.contains("@")) {
        // lookup Firestore to get email mapped with phone
        var query = await _db
            .collection("users")
            .where("phone", isEqualTo: identifier)
            .limit(1)
            .get();

        if (query.docs.isEmpty) {
          return "No account found with this phone number.";
        }

        emailToUse = query.docs.first["email"];
      }

      // Sign in with email & password
      final credential = await _auth.signInWithEmailAndPassword(
        email: emailToUse,
        password: password,
      );

      // 🔑 Check email verification
      if (!credential.user!.emailVerified) {
        await credential.user!.sendEmailVerification(); // resend verification
        await _auth.signOut(); // prevent unverified login
        return "Please verify your email before logging in. We've sent a new verification link.";
      }

      return null; // ✅ Success
    } on FirebaseAuthException catch (e) {
      return _getFirebaseAuthError(e);
    } catch (e) {
      return "Something went wrong. Please try again.";
    }
  }

  /// 🔹 Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// 🔹 Get Current User
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// 🔹 Get Subscription Details from Firestore
  Future<Map<String, dynamic>?> getSubscriptionStatus(String uid) async {
    try {
      // Force fresh data from server, not cache
      final doc = await _db
          .collection("subscriptions")
          .doc(uid)
          .get(const GetOptions(source: Source.server));

      if (!doc.exists) return null;

      final data = doc.data();
      if (data == null) return null;

      final now = DateTime.now().toUtc();

      // Check if subscription has expired based on expiryDate
      if (data.containsKey("expiryDate")) {
        final expiryDate = data["expiryDate"];
        DateTime expiry;

        if (expiryDate is Timestamp) {
          expiry = expiryDate.toDate().toUtc();
        } else if (expiryDate is String) {
          expiry = DateTime.tryParse(expiryDate)?.toUtc() ??
              now.subtract(const Duration(days: 1));
        } else {
          // Unknown format → treat as expired
          return null;
        }

        // If subscription has expired, update the status in Firestore
        if (expiry.isBefore(now)) {
          await _db.collection("subscriptions").doc(uid).update({
            "subscriptionStatus": "expired",
            "lastUpdated": FieldValue.serverTimestamp(),
          });

          // Return null to indicate expired subscription
          return null;
        }
      } else {
        // No expiryDate field → treat as not subscribed
        return null;
      }

      // ✅ Subscription is valid
      return data;
    } catch (e) {
      return null;
    }
  }

  Future<void> checkExpiryAndNotify(DateTime expiryDate) async {
    DateTime today = DateTime.now();
    Duration difference = expiryDate.difference(today);

    int daysLeft = difference.inDays;

    // await FlutterLocalNotificationService().showNotification(
    //     id: 0,
    //     title: 'Subscription Renewal Reminder',
    //     body:
    //         'Your Subscription Plan is about expire in $daysLeft ${daysLeft == 1 ? 'day' : 'days'}');

    if ([1, 3, 7].contains(daysLeft)) {
      await FlutterLocalNotificationService().showNotification(
          id: 0,
          title: 'Subscription Renewal Reminder',
          body:
              'Your Subscription Plan is about to expire in $daysLeft ${daysLeft == 1 ? 'day' : 'days'}');
    }
  }

  Future<String> getRedirectRoute(String uid) async {
    try {
      // Force fresh subscription data check
      final subData = await getSubscriptionStatus(uid);
      final now = DateTime.now().toUtc();

      // If no subscription data, redirect to subscribe
      if (subData == null) {
        return "/subscribe";
      }

      final status =
          subData["subscriptionStatus"]?.toString().trim().toLowerCase();
      if (status == null) {
        return "/subscribe";
      }

      // 🔹 Active subscription
      if (status == "active") {
        final expiryDate = subData["expiryDate"];
        if (expiryDate == null) {
          return "/subscribe";
        }

        DateTime expiry;
        if (expiryDate is Timestamp) {
          expiry = expiryDate.toDate().toUtc();
        } else if (expiryDate is String) {
          expiry = DateTime.tryParse(expiryDate)?.toUtc() ??
              now.subtract(const Duration(days: 1));
        } else {
          return "/subscribe";
        }

        if (expiry.isAfter(now)) {
          checkExpiryAndNotify(expiry);
          return "/home"; // Valid active subscription
        }
        return "/subscribe"; // Expired subscription
      }

      // 🔹 Trial subscription
      if (status == "trial") {
        final trialEnd = subData["trialEnd"];
        if (trialEnd == null) {
          return "/subscribe";
        }

        DateTime endDate;
        if (trialEnd is Timestamp) {
          endDate = trialEnd.toDate().toUtc();
        } else if (trialEnd is String) {
          endDate = DateTime.tryParse(trialEnd)?.toUtc() ??
              now.subtract(const Duration(days: 1));
        } else {
          return "/subscribe";
        }

        if (endDate.isAfter(now)) {
          return "/home"; // Valid trial
        }
        return "/subscribe"; // Trial expired
      }

      // 🔹 Expired subscription
      if (status == "expired") {
        return "/subscribe"; // Redirect to subscribe screen for expired subscriptions
      }

      // 🔹 Unknown status
      return "/subscribe";
    } catch (e) {
      return "/subscribe"; // Default to subscribe on any error
    }
  }

  /// 🔹 Map FirebaseAuth errors to clean messages
  String _getFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return "This email is already registered. Try logging in instead.";
      case 'invalid-email':
        return "The email address is not valid.";
      case 'weak-password':
        return "Password should be at least 6 characters.";
      case 'user-not-found':
        return "No account found with this email or phone.";
      case 'wrong-password':
        return "Incorrect password. Please try again.";
      case 'user-disabled':
        return "This account has been disabled. Contact support.";
      case 'too-many-requests':
        return "Too many attempts. Please try again later.";
      default:
        return e.message ?? "An unknown error occurred. Please try again.";
    }
  }
}
