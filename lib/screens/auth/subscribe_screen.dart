import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:motor_insurance_app/screens/auth/auth_service.dart';

class SubscribeScreen extends StatelessWidget {
  const SubscribeScreen({super.key});

  Future<void> _handleSignOut(BuildContext context) async {
    try {
      final authService = AuthService();
      await authService.signOut();
      
      if (context.mounted) {
        // Clear navigation stack and go to login
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error signing out. Please try again.")),
        );
      }
    }
  }

  Future<void> _activatePlan(
      BuildContext context, String plan, int days) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final now = DateTime.now().toUtc();
    final expiry = now.add(Duration(days: days));

    await FirebaseFirestore.instance.collection('subscriptions').doc(uid).set({
      'subscriptionStatus': 'active',
      'plan': plan,
      'trialStart': null,
      'trialEnd': null,
      'paymentId': 'MOCK_PAYMENT_${DateTime.now().millisecondsSinceEpoch}',
      'expiryDate': expiry.toIso8601String(),
    }, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$plan Plan Activated ✅")),
    );

    Navigator.pushReplacementNamed(context, '/home');
  }

  Future<bool> _hasUsedTrial(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('subscriptions')
        .doc(uid)
        .get();
    if (!doc.exists) return false;
    final data = doc.data();
    return data?['trialStart'] != null; // means already used trial
  }

  Future<void> _activateTrial(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    if (await _hasUsedTrial(uid)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Trial already used ❌")),
      );
      return;
    }

    final now = DateTime.now().toUtc();
    final trialEnd = now.add(const Duration(days: 7));

    await FirebaseFirestore.instance.collection('subscriptions').doc(uid).set({
      'subscriptionStatus': 'trial',
      'plan': 'trial',
      'trialStart': Timestamp.fromDate(now),
      'trialEnd': Timestamp.fromDate(trialEnd),
      'paymentId': null,
      'expiryDate': Timestamp.fromDate(trialEnd),
    }, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Trial Activated ✅")),
    );

    Navigator.pushReplacementNamed(context, '/home');
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(subtitle),
        trailing: Text(price,
            style: const TextStyle(fontSize: 16, color: Colors.green)),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose a Plan"),
        automaticallyImplyLeading: false, // Disable back button
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            tooltip: 'Sign Out', // Shows on long press
            onPressed: () => _handleSignOut(context),
          ),
          const SizedBox(width: 8), // Add some padding on the right
        ],
      ),
      body: ListView(
        children: [
          _buildPlanCard(
            title: "7 Days Free Trial",
            price: "₹0",
            subtitle: "Enjoy full access for 7 days (one-time only)",
            onTap: () async => await _activateTrial(context),
          ),
          _buildPlanCard(
            title: "Monthly Plan",
            price: "₹149",
            subtitle: "",
            onTap: () async => await _activatePlan(context, "monthly", 30),
          ),
          _buildPlanCard(
            title: "6-Month Plan",
            price: "₹699",
            subtitle: "Equivalent to ₹116/month (save ~22%)",
            onTap: () async => await _activatePlan(context, "6_months", 180),
          ),
          _buildPlanCard(
            title: "Yearly Plan",
            price: "₹999",
            subtitle: "Equivalent to ₹83/month (save ~44%)",
            onTap: () async => await _activatePlan(context, "yearly", 365),
          ),
        ],
      ),
    );
  }
}
