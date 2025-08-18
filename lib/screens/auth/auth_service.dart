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
  Future<String?> signIn(
      {required String identifier, required String password}) async {
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

      // Use email to login
      await _auth.signInWithEmailAndPassword(
        email: emailToUse,
        password: password,
      );

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
