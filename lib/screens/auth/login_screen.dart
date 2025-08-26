import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motor_insurance_app/screens/auth/forgot_password.dart';
import 'package:motor_insurance_app/screens/auth/signup.dart';
import 'package:motor_insurance_app/screens/auth/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:motor_insurance_app/screens/auth/enter_mpin.dart';
import 'package:motor_insurance_app/screens/auth/set_mpin.dart';
import 'package:animate_do/animate_do.dart';
import 'package:motor_insurance_app/screens/auth/single_device_check.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController identifierController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();
  //final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void dispose() {
    identifierController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // 🔹 Normal email/phone + password login
  Future<void> login(BuildContext context) async {
    try {
      String identifier = identifierController.text.trim();
      String password = passwordController.text.trim();

      if (identifier.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Please enter Email/Mobile No. and Password")),
        );
        return;
      }

      // Attempt to sign in
      String? error = await _authService.signIn(
        identifier: identifier,
        password: password,
      );

      if (error == null) {
        final user = _authService.getCurrentUser();
        if (user != null) {
          try {
            SingleDeviceCheck().checkAndPromptDeviceId(context, user.uid);
            String route = await _authService.getRedirectRoute(user.uid);
            if (mounted) {
              Navigator.pushReplacementNamed(context, route);
            }
          } catch (routeError) {
            // Show specific subscription/trial error messages
            throw routeError.toString();
          }
        } else {
          throw "Failed to get user after login. Please try again.";
        }
      } else {
        throw error;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll("Exception: ", "")),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  /// Handle MPIN tap
  Future<void> _handleMpinTap(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // No Firebase user logged in → must login with email first
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login with Email/Password first")),
      );
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    final storage = const FlutterSecureStorage();
    String? savedMpin = await storage.read(key: "user_mpin_${user.uid}");

    if (savedMpin != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const EnterMPINScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SetMPINScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.indigo.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            // Use LayoutBuilder to get the screen height and set a minHeight for the Column
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 50),
                        FadeIn(
                          duration: const Duration(milliseconds: 1200),
                          child: SlideInDown(
                            duration: const Duration(milliseconds: 1000),
                            child: Image.asset(
                              'assets/insurance.png',
                              height: 80,
                              width: 80,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        FadeIn(
                          delay: const Duration(milliseconds: 500),
                          duration: const Duration(milliseconds: 1000),
                          child: Text(
                            'Welcome Back!',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.indigo.shade900,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        FadeIn(
                          delay: const Duration(milliseconds: 700),
                          duration: const Duration(milliseconds: 1000),
                          child: Text(
                            'Sign in to access your dashboard.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 40),
                        FadeIn(
                          delay: const Duration(milliseconds: 900),
                          duration: const Duration(milliseconds: 1200),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildTextField(
                                  controller: identifierController,
                                  label: 'Email or Mobile Number',
                                  icon: Icons.person_outline,
                                ),
                                const SizedBox(height: 24),
                                _buildTextField(
                                  controller: passwordController,
                                  label: 'Password',
                                  icon: Icons.lock_outline,
                                  obscureText: true,
                                ),
                                const SizedBox(height: 40),
                                _AnimatedButton(
                                  onPressed: () async => await login(context),
                                  color: Colors.indigo.shade700,
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _AnimatedButton(
                                  onPressed: () async =>
                                      await _handleMpinTap(context),
                                  color: Colors.indigo.shade600,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Login with MPIN',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        FadeInUp(
                          delay: const Duration(milliseconds: 1500),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordScreen()),
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.indigo.shade700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          delay: const Duration(milliseconds: 1700),
                          child: TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()),
                            ),
                            child: Text.rich(
                              TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey.shade700,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Sign Up',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          delay: const Duration(milliseconds: 1900),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.code,
                                color: Colors.grey.shade400,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Developed by: NBK SOFTWARE SOLUTIONS',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return TextFormField(
          controller: controller,
          obscureText: obscureText &&
              !(!obscureText || controller != passwordController),
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Icon(
              icon,
              color: Colors.indigo.shade700,
            ),
            suffixIcon: controller == passwordController
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey.shade600,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                  )
                : null,
            filled: false,
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.indigo.shade700, width: 2.0),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1.0),
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2.0),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
        );
      },
    );
  }
}

class _AnimatedButton extends StatefulWidget {
  final Future<void> Function() onPressed;
  final Widget child;
  final Color color;

  const _AnimatedButton({
    required this.onPressed,
    required this.child,
    required this.color,
  });

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!_isLoading) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) async {
    if (!_isLoading) {
      _controller.reverse();
      setState(() => _isLoading = true);
      try {
        await widget.onPressed();
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : widget.child,
              ),
            ),
          );
        },
      ),
    );
  }
}
