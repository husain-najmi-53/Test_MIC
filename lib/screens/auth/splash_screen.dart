import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      try {
        // 🔹 Reload to confirm if deleted in Firebase Auth
        await user.reload();
        user = auth.currentUser;
      } catch (_) {
        user = null;
      }

      if (user != null) {
        // 🔹 Check Firestore doc
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (!doc.exists) {
          // User doc missing → logout
          await auth.signOut();
        }
      }
    }

    // ✅ Always send to login after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Detect system brightness directly
    final brightness = MediaQuery.of(context).platformBrightness;
    final backgroundColor =
        brightness == Brightness.dark ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.asset(
            'assets/icon/splash_icon.jpg',
            width: 120,
            height: 120,
          ),
        ),
      ),
    );
  }
}
