import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SetMPINScreen extends StatefulWidget {
  const SetMPINScreen({Key? key}) : super(key: key);

  @override
  _SetMPINScreenState createState() => _SetMPINScreenState();
}

class _SetMPINScreenState extends State<SetMPINScreen> {
  final List<String> _enteredPin = [];
  final List<String> _confirmedPin = [];
  final _storage = const FlutterSecureStorage();
  bool _isConfirming = false;

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

    await _storage.write(key: "user_mpin", value: _enteredPin.join());
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("MPIN set successfully!"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.indigo.shade700,
      ),
    );
    Navigator.pushReplacementNamed(context, "/subscribe");
  }

  void _onKeyPressed(String value) {
    setState(() {
      if (!_isConfirming) {
        if (_enteredPin.length < 4) {
          _enteredPin.add(value);
          if (_enteredPin.length == 4) _isConfirming = true;
        }
      } else {
        if (_confirmedPin.length < 4) {
          _confirmedPin.add(value);
          if (_confirmedPin.length == 4) _saveMPIN();
        }
      }
    });
  }

  void _onBackspace() {
    setState(() {
      if (!_isConfirming) {
        if (_enteredPin.isNotEmpty) _enteredPin.removeLast();
      } else {
        if (_confirmedPin.isNotEmpty) {
          _confirmedPin.removeLast();
        } else {
          _isConfirming = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Set MPIN"),
        backgroundColor: Colors.indigo.shade700,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Header
            const Icon(Icons.lock_outline, size: 60, color: Colors.indigo),
            const SizedBox(height: 16),
            Text(
              _isConfirming ? "Confirm Your MPIN" : "Create New MPIN",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade700,
                  ),
            ),
            const SizedBox(height: 24),

            // PIN Dots (shows current state)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final activeList = _isConfirming ? _confirmedPin : _enteredPin;
                return Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index < activeList.length
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
          ],
        ),
      ),
    );
  }
}

// Reuse these same widget classes from EnterMPINScreen
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