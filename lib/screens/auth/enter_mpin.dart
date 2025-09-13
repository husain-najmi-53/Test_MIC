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
  bool _isLoading = false;
  //final _storage = const FlutterSecureStorage();

  Future<void> _verifyMPIN() async {
    if (_enteredPin.length != 4) return;

    setState(() {
      _isLoading = true;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
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
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error checking subscription: $e"),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    } else {
      // ❌ Wrong MPIN
      setState(() {
        _isLoading = false;
      });
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
    if (_isLoading) return; // Prevent input during loading
    if (_enteredPin.length < 4) {
      setState(() => _enteredPin.add(value));
      if (_enteredPin.length == 4) _verifyMPIN();
    }
  }

  void _onBackspace() {
    if (_isLoading) return; // Prevent input during loading
    if (_enteredPin.isNotEmpty) {
      setState(() => _enteredPin.removeLast());
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    
    // Responsive sizing
    final isSmallScreen = screenHeight < 600;
    final buttonSize = isSmallScreen ? 48.0 : 64.0;
    final dotSize = isSmallScreen ? 20.0 : 24.0;
    final fontSize = isSmallScreen ? 20.0 : 24.0;
    final verticalSpacing = isSmallScreen ? 12.0 : 16.0;
    final horizontalSpacing = screenWidth < 350 ? 4.0 : 8.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter MPIN", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo.shade700,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: isSmallScreen ? 16.0 : 24.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header
              Text(
                "Enter 4-digit verification code",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade700,
                      fontSize: isSmallScreen ? 14 : 16,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isSmallScreen ? 16 : 24),

              // PIN Dots with loading overlay
              Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return Container(
                        width: dotSize,
                        height: dotSize,
                        margin: EdgeInsets.symmetric(horizontal: horizontalSpacing),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index < _enteredPin.length
                              ? Colors.indigo.shade700
                              : Colors.grey.shade300,
                        ),
                      );
                    }),
                  ),
                  if (_isLoading)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.indigo.shade700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Verifying...",
                            style: TextStyle(
                              color: Colors.indigo.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              SizedBox(height: isSmallScreen ? 24 : 40),

              // Keypad
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth * 0.8,
                    maxHeight: screenHeight * 0.5,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Row 1-2-3
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [1, 2, 3].map((num) {
                          return _NumberButton(
                            number: num.toString(),
                            onPressed: _isLoading ? null : () => _onKeyPressed(num.toString()),
                            size: buttonSize,
                            fontSize: fontSize,
                          );
                        }).toList(),
                      ),
                      SizedBox(height: verticalSpacing),
                      // Row 4-5-6
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [4, 5, 6].map((num) {
                          return _NumberButton(
                            number: num.toString(),
                            onPressed: _isLoading ? null : () => _onKeyPressed(num.toString()),
                            size: buttonSize,
                            fontSize: fontSize,
                          );
                        }).toList(),
                      ),
                      SizedBox(height: verticalSpacing),
                      // Row 7-8-9
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [7, 8, 9].map((num) {
                          return _NumberButton(
                            number: num.toString(),
                            onPressed: _isLoading ? null : () => _onKeyPressed(num.toString()),
                            size: buttonSize,
                            fontSize: fontSize,
                          );
                        }).toList(),
                      ),
                      SizedBox(height: verticalSpacing),
                      // Bottom row with empty space, 0, and backspace
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(width: buttonSize, height: buttonSize), // Empty space
                          _NumberButton(
                            number: "0",
                            onPressed: _isLoading ? null : () => _onKeyPressed("0"),
                            size: buttonSize,
                            fontSize: fontSize,
                          ),
                          _BackspaceButton(
                            onPressed: _isLoading ? null : _onBackspace,
                            size: buttonSize,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: isSmallScreen ? 16 : 24),

              // Forgot MPIN link
              TextButton(
                onPressed: _isLoading ? null : () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text(
                  "Forgot MPIN? Login with Email",
                  style: TextStyle(
                    color: _isLoading ? Colors.grey.shade400 : Colors.indigo.shade700,
                    decoration: TextDecoration.underline,
                    fontSize: isSmallScreen ? 12 : 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NumberButton extends StatelessWidget {
  final String number;
  final VoidCallback? onPressed;
  final double size;
  final double fontSize;

  const _NumberButton({
    required this.number,
    required this.onPressed,
    this.size = 64.0,
    this.fontSize = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: onPressed != null ? Colors.grey.shade100 : Colors.grey.shade200,
        ),
        onPressed: onPressed,
        child: Text(
          number,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: onPressed != null ? Colors.black87 : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}

class _BackspaceButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double size;

  const _BackspaceButton({
    required this.onPressed,
    this.size = 64.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: IconButton(
        icon: Icon(
          Icons.backspace, 
          size: size * 0.375, // Proportional icon size
          color: onPressed != null ? Colors.black87 : Colors.grey.shade400,
        ),
        style: IconButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: onPressed != null ? Colors.grey.shade100 : Colors.grey.shade200,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
