import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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
    final doc = await _db.collection("subscriptions").doc(uid).get();

    if (!doc.exists) return null;

    final data = doc.data();
    if (data == null) return null;

    final now = DateTime.now().toUtc();

    if (data.containsKey("endDate")) {
      final expiryDate = data["endDate"];
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

      if (expiry.isBefore(now)) {
        // Subscription expired
        return null;
      }
    } else {
      // No endDate field → treat as not subscribed
      return null;
    }

    // ✅ Subscription is valid
    return data;
  }

//   Future<void> createTrial(String uid) async {
//   final doc = await _db.collection("subscriptions").doc(uid).get();
//   if (doc.exists && doc.data()?["trialStart"] != null) {
//     throw Exception("Trial already used");
//   }

//   final now = DateTime.now().toUtc();
//   final trialEnd = now.add(const Duration(days: 7));

//   await _db.collection("subscriptions").doc(uid).set({
//     "subscriptionStatus": "trial",
//     "plan": "trial",
//     "trialStart": now.toIso8601String(),
//     "trialEnd": trialEnd.toIso8601String(),
//     "paymentId": null,
//     "expiryDate": trialEnd.toIso8601String(),
//   });
// }

  Future<String> getRedirectRoute(String uid) async {
    try {
      final subData = await getSubscriptionStatus(uid);
      final now = DateTime.now().toUtc();

      // If no subscription data, redirect to subscribe
      if (subData == null) {
        return "/subscribe";
      }

      final status = subData["subscriptionStatus"];
      if (status == null) {
        throw "Subscription status not found. Please contact support.";
      }

      // 🔹 Active subscription
      if (status == "active") {
        final expiryDate = subData["expiryDate"];
        if (expiryDate == null) {
          throw "Invalid subscription: Missing expiry date. Please contact support.";
        }

        DateTime expiry;
        if (expiryDate is Timestamp) {
          expiry = expiryDate.toDate();
        } else if (expiryDate is String) {
          expiry = DateTime.tryParse(expiryDate) ??
              now.subtract(const Duration(days: 1));
        } else {
          throw "Invalid expiry date format. Please contact support.";
        }

        if (expiry.isAfter(now)) {
          return "/home"; // Valid active subscription
        }
        return "/subscribe"; // Expired subscription
      }

      // 🔹 Trial subscription
      if (status == "trial") {
        final trialEnd = subData["trialEnd"];
        if (trialEnd == null) {
          throw "Invalid trial: Missing end date. Please contact support.";
        }

        DateTime endDate;
        if (trialEnd is Timestamp) {
          endDate = trialEnd.toDate();
        } else if (trialEnd is String) {
          endDate = DateTime.tryParse(trialEnd) ??
              now.subtract(const Duration(days: 1));
        } else {
          throw "Invalid trial end date format. Please contact support.";
        }

        if (endDate.isAfter(now)) {
          return "/home"; // Valid trial
        }
        return "/subscribe"; // Trial expired
      }

      // 🔹 Unknown status
      throw "Invalid subscription status: $status. Please contact support.";
    } catch (e) {
      //print("Error in getRedirectRoute: $e");

      // Rethrow the error with proper message
      if (e is String) {
        throw e;
      }
      throw "An unexpected error occurred. Please try again or contact support.";
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
