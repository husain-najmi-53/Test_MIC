import 'package:flutter/material.dart';
import 'package:motor_insurance_app/screens/auth/forgot_password.dart';
import 'package:motor_insurance_app/screens/auth/signup.dart';
import 'package:motor_insurance_app/screens/auth/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:motor_insurance_app/screens/auth/enter_mpin.dart';
import 'package:motor_insurance_app/screens/auth/set_mpin.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController identifierController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // 🔹 Normal email/phone + password login
  void login(BuildContext context) async {
    try {
      // Start loading
      setState(() {
        isLoading = true;
      });

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
    } finally {
      // Stop loading if still mounted
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // 🔐 MPIN button handler: decide Enter vs Set based on local storage
  Future<void> _handleMpinTap(BuildContext context) async {
    final mpin = await _storage.read(key: 'user_mpin');
    if (mpin != null && mpin.isNotEmpty) {
      // MPIN exists -> go to Enter MPIN
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const EnterMPINScreen()),
      );
    } else {
      // MPIN doesn't exist -> go to Set MPIN
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SetMPINScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Easy Insurance Calculator (Motor)',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.indigo.shade700,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 100),
            Center(
              child: Image.asset(
                'assets/insurance.png',
                height: 120,
                width: 120,
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Sign In',
                style: TextStyle(
                    fontSize: 26,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // Email/Phone input
            _buildTextField(
              controller: identifierController,
              label: 'Email / Mobile',
              isNumeric: false,
            ),
            const SizedBox(height: 16),

            // Password input
            _buildTextField(
              controller: passwordController,
              label: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 30),

            // Normal Login Button
            ElevatedButton(
              onPressed: isLoading ? null : () => login(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo.shade700,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                disabledBackgroundColor: Colors.indigo.shade300,
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Login', style: TextStyle(color: Colors.white)),
            ),

            const SizedBox(height: 16),

            // ✅ Always show MPIN Login button; route based on existence
            // ElevatedButton.icon(
            //   onPressed: () => _handleMpinTap(context),
            //   icon: const Icon(Icons.lock, color: Colors.white),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.indigo.shade600,
            //     padding: const EdgeInsets.symmetric(vertical: 14),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //   ),
            //   label: const Text(
            //     'Login with MPIN',
            //     style: TextStyle(color: Colors.white, fontSize: 16),
            //   ),
            // ),

            // const SizedBox(height: 20),

            // Bottom Links
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen()),
                    );
                  },
                  child: const Text('Forgot Password?',
                      style: TextStyle(fontSize: 14, color: Colors.indigo)),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Sign Up
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()));
                },
                child: const Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(fontSize: 14, color: Colors.indigo),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isNumeric = false,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.indigo, width: 2.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
