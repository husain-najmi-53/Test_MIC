import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  void login(BuildContext context) {
    // Later: Call backend API here
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Motar Insurance Calculator',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.indigo.shade700, // Matching AppBar color
        elevation: 0,
        automaticallyImplyLeading: false, // Hide the back button

        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back,
        //       color: Colors.white), // Set the back icon color to white
        //   onPressed: () {
        //     Navigator.pop(context); // Handle back navigation
        //   },
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 100),
            // Logo Image
            Center(
              child: Image.asset(
                'assets/insurance.png', // Add your logo image here
                height: 120, // Adjust the size as per your preference
                width: 120,
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Motar Insurance Calculator',
                style: TextStyle(
                    fontSize: 26,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            // Sticky note like container for branding

            // Email Input Field
            _buildTextField(
              controller: emailController,
              label: 'Email / Mobile',
              isNumeric: false,
            ),
            const SizedBox(height: 16),

            // Password Input Field
            _buildTextField(
              controller: passwordController,
              label: 'Password',
              isNumeric: false,
              obscureText: true,
            ),
            const SizedBox(height: 30),

            // Login Button
            ElevatedButton(
              onPressed: () => login(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo.shade700,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.indigo.shade100,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock, color: Color.fromARGB(255, 167, 13, 13)),
                  SizedBox(width: 8),
                  Text(
                    'Secure Login with MPIN',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 167, 13, 13),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            // Forgot MPIN and Create Account Links
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    // Navigate to Forgot MPIN screen
                  },
                  child: const Text(
                    'Forgot MPIN?',
                    style: TextStyle(fontSize: 14, color: Colors.indigo),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to Create Account screen
                  },
                  child: const Text(
                    'Change Mobile No',
                    style: TextStyle(fontSize: 14, color: Colors.indigo),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Sign Up Link (if needed)
            Center(
              child: TextButton(
                onPressed: () {
                  // Navigate to Sign Up page
                },
                child: const Text(
                  'Don\'t have an account? Sign Up',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.indigo,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // A reusable method to build text fields with a consistent design
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
