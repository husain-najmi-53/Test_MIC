import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EnterMPINScreen extends StatefulWidget {
  const EnterMPINScreen({Key? key}) : super(key: key);

  @override
  _EnterMPINScreenState createState() => _EnterMPINScreenState();
}

class _EnterMPINScreenState extends State<EnterMPINScreen> {
  final List<String> _enteredPin = [];
  //final _storage = const FlutterSecureStorage();

 Future<void> _verifyMPIN() async {
  if (_enteredPin.length != 4) return;

  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please login first")),
    );
    Navigator.pushReplacementNamed(context, '/login');
    return;
  }

  final _storage = const FlutterSecureStorage();
  String? savedMpin = await _storage.read(key: "user_mpin_${user.uid}");
  //await Future.delayed(const Duration(milliseconds: 500)); // Simulate processing

  if (savedMpin == _enteredPin.join()) {
    // ✅ Correct MPIN → check subscription
    final uid = user.uid;

    try {
      final subDoc = await FirebaseFirestore.instance
          .collection("subscriptions")
          .doc(uid)
          .get();

      final now = DateTime.now().toUtc();

      if (!subDoc.exists) {
        Navigator.pushReplacementNamed(context, '/subscribe');
        return;
      }

      final data = subDoc.data()!;

      // 🔑 Safe expiryDate parsing
      DateTime expiry;
      final expiryDate = data["expiryDate"];
      if (expiryDate is Timestamp) {
        expiry = expiryDate.toDate();
      } else if (expiryDate is String) {
        expiry = DateTime.tryParse(expiryDate) ??
            now.subtract(const Duration(days: 1));
      } else {
        throw "Invalid expiry date format";
      }

      // 🔑 Safe trialEnd parsing
      DateTime? trialEnd;
      if (data["trialEnd"] != null) {
        final trialEndRaw = data["trialEnd"];
        if (trialEndRaw is Timestamp) {
          trialEnd = trialEndRaw.toDate();
        } else if (trialEndRaw is String) {
          trialEnd = DateTime.tryParse(trialEndRaw);
        }
      }

      if (data["subscriptionStatus"] == "active" && expiry.isAfter(now)) {
        Navigator.pushReplacementNamed(context, '/home');
      } else if (data["subscriptionStatus"] == "trial" &&
          trialEnd != null &&
          trialEnd.isAfter(now)) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/subscribe');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error checking subscription: $e"),
          backgroundColor: Colors.red.shade400,
        ),
      );
    }
  } else {
    // ❌ Wrong MPIN
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Incorrect MPIN"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ),
    );
    setState(() => _enteredPin.clear());
  }
}

  void _onKeyPressed(String value) {
    if (_enteredPin.length < 4) {
      setState(() => _enteredPin.add(value));
      if (_enteredPin.length == 4) _verifyMPIN();
    }
  }

  void _onBackspace() {
    if (_enteredPin.isNotEmpty) {
      setState(() => _enteredPin.removeLast());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter MPIN", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo.shade700,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Header
            Text(
              "Enter 4-digit verification code",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade700,
                  ),
            ),
            const SizedBox(height: 24),

            // PIN Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index < _enteredPin.length
                        ? Colors.indigo.shade700
                        : Colors.grey.shade300,
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),

            // Keypad
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [1, 2, 3].map((num) {
                    return _NumberButton(
                      number: num.toString(),
                      onPressed: () => _onKeyPressed(num.toString()),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [4, 5, 6].map((num) {
                    return _NumberButton(
                      number: num.toString(),
                      onPressed: () => _onKeyPressed(num.toString()),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [7, 8, 9].map((num) {
                    return _NumberButton(
                      number: num.toString(),
                      onPressed: () => _onKeyPressed(num.toString()),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 64, height: 64), // Empty space
                    _NumberButton(
                      number: "0",
                      onPressed: () => _onKeyPressed("0"),
                    ),
                    _BackspaceButton(onPressed: _onBackspace),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Forgot MPIN link
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text(
                "Forgot MPIN? Login with Email",
                style: TextStyle(
                  color: Colors.indigo.shade700,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NumberButton extends StatelessWidget {
  final String number;
  final VoidCallback onPressed;

  const _NumberButton({
    required this.number,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: Colors.grey.shade100,
        ),
        onPressed: onPressed,
        child: Text(
          number,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _BackspaceButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _BackspaceButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: IconButton(
        icon: const Icon(Icons.backspace, size: 24),
        style: IconButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: Colors.grey.shade100,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
