import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:motor_insurance_app/screens/auth/auth_service.dart';

class SetMPINScreen extends StatefulWidget {
  const SetMPINScreen({Key? key}) : super(key: key);

  @override
  _SetMPINScreenState createState() => _SetMPINScreenState();
}

class _SetMPINScreenState extends State<SetMPINScreen> {
  final List<String> _enteredPin = [];
  final List<String> _confirmedPin = [];
  bool _isConfirming = false;
  final _storage = const FlutterSecureStorage();

  void _onKeyPressed(String value) {
    setState(() {
      if (!_isConfirming) {
        if (_enteredPin.length < 4) {
          _enteredPin.add(value);
          if (_enteredPin.length == 4) {
            _isConfirming = true;
          }
        }
      } else {
        if (_confirmedPin.length < 4) {
          _confirmedPin.add(value);
          if (_confirmedPin.length == 4) {
            _saveMPIN();
          }
        }
      }
    });
  }

  void _onBackspace() {
    setState(() {
      if (!_isConfirming && _enteredPin.isNotEmpty) {
        _enteredPin.removeLast();
      } else if (_isConfirming && _confirmedPin.isNotEmpty) {
        _confirmedPin.removeLast();
      }
    });
  }

  Future<void> _saveMPIN() async {
    if (_enteredPin.length != 4 || _confirmedPin.length != 4) return;

    if (_enteredPin.join() != _confirmedPin.join()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("MPINs do not match"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade400,
        ),
      );
      setState(() {
        _enteredPin.clear();
        _confirmedPin.clear();
        _isConfirming = false;
      });
      return;
    }

    // ✅ Ensure user is logged in before saving MPIN
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please login first"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    // ✅ Save MPIN tied to UID
    await _storage.write(
      key: "user_mpin_${user.uid}",
      value: _enteredPin.join(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("MPIN set successfully!"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.indigo.shade700,
      ),
    );

    // ✅ Check subscription before redirect
    final subData = await AuthService().getSubscriptionStatus(user.uid);

    if (subData == null) {
      // No active subscription → go to subscription flow
      Navigator.pushReplacementNamed(context, "/subscribe");
    } else {
      // Already subscribed → go to home/dashboard
      Navigator.pushReplacementNamed(context, "/home");
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLength =
        _isConfirming ? _confirmedPin.length : _enteredPin.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Set MPIN", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo.shade700,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isConfirming
                  ? "Confirm your 4-digit MPIN"
                  : "Enter a 4-digit MPIN",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade700,
                  ),
            ),
            const SizedBox(height: 24),

            // PIN dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index < currentLength
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
                for (var row in [
                  ["1", "2", "3"],
                  ["4", "5", "6"],
                  ["7", "8", "9"],
                ])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: row.map((num) {
                        return _NumberButton(
                          number: num,
                          onPressed: () => _onKeyPressed(num),
                        );
                      }).toList(),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 64, height: 64),
                    _NumberButton(
                      number: "0",
                      onPressed: () => _onKeyPressed("0"),
                    ),
                    _BackspaceButton(onPressed: _onBackspace),
                  ],
                ),
              ],
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

  const _NumberButton({required this.number, required this.onPressed});

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

  const _BackspaceButton({required this.onPressed});

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
