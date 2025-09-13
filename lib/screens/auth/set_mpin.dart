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
  bool _isLoading = false;
  final _storage = const FlutterSecureStorage();

  void _onKeyPressed(String value) {
    if (_isLoading) return; // Prevent input during loading
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
    if (_isLoading) return; // Prevent input during loading
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

    setState(() {
      _isLoading = true;
    });

    if (_enteredPin.join() != _confirmedPin.join()) {
      setState(() {
        _isLoading = false;
      });
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
      setState(() {
        _isLoading = false;
      });
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

    try {
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
        Navigator.pushReplacementNamed(context, "/login");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error setting MPIN: $e"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade400,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLength =
        _isConfirming ? _confirmedPin.length : _enteredPin.length;
    
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
        title: const Text("Set MPIN", style: TextStyle(color: Colors.white)),
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
              Text(
                _isConfirming
                    ? "Confirm your 4-digit MPIN"
                    : "Enter a 4-digit MPIN",
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
                          color: index < currentLength
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
                            "Setting MPIN...",
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
                      for (var row in [
                        ["1", "2", "3"],
                        ["4", "5", "6"],
                        ["7", "8", "9"],
                      ])
                        Padding(
                          padding: EdgeInsets.only(bottom: verticalSpacing),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: row.map((num) {
                              return _NumberButton(
                                number: num,
                                onPressed: _isLoading ? null : () => _onKeyPressed(num),
                                size: buttonSize,
                                fontSize: fontSize,
                              );
                            }).toList(),
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(width: buttonSize, height: buttonSize),
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
              
              // Reset button for confirmation phase
              if (_isConfirming && !_isLoading) ...[
                SizedBox(height: isSmallScreen ? 16 : 24),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _enteredPin.clear();
                      _confirmedPin.clear();
                      _isConfirming = false;
                    });
                  },
                  child: Text(
                    "Start over",
                    style: TextStyle(
                      color: Colors.indigo.shade700,
                      decoration: TextDecoration.underline,
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
                  ),
                ),
              ],
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
