import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:motor_insurance_app/screens/auth/auth_service.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class SubscribeScreen extends StatefulWidget {
  const SubscribeScreen({super.key});

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  late Razorpay _razorpay;
  String? _selectedPlan;
  int? _selectedDays;

  bool _loading = true;
  bool _showPlans = false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    _checkSubscription();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  /// 🔹 Check subscription status
  Future<void> _checkSubscription() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('subscriptions').doc(uid).get();

    if (!doc.exists) {
      // No subscription record → show plans
      setState(() {
        _loading = false;
        _showPlans = true;
      });
      return;
    }

    final data = doc.data()!;
    final expiry = data['expiryDate'];
    final DateTime? expiryDate =
        expiry is Timestamp ? expiry.toDate() : DateTime.tryParse(expiry ?? '');

    if (expiryDate != null && expiryDate.isAfter(DateTime.now())) {
      // Still valid subscription → skip to home
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Expired → show plans
      setState(() {
        _loading = false;
        _showPlans = true;
      });
    }
  }

  Future<void> _handleSignOut(BuildContext context) async {
    try {
      final authService = AuthService();
      await authService.signOut();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error signing out. Please try again.")),
        );
      }
    }
  }

  /// 🔹 Trial flow
  Future<bool> _hasUsedTrial(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('subscriptions').doc(uid).get();
    if (!doc.exists) return false;
    final data = doc.data();
    return data?['trialStart'] != null;
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

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Trial Activated ✅")),
      );
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  /// 🔹 Razorpay checkout
  Future<void> _openCheckout(String plan, int amount, int days) async {
    _selectedPlan = plan;
    _selectedDays = days;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    String contact = '';
    String email = '';
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data();
        contact = data?['phone'] ?? '';
        email = data?['email'] ?? '';
      }
    }

    var options = {
      'key': 'rzp_test_R7wSPViMlDXu00', // Replace with your Razorpay Key
      'amount': amount * 100,
      'name': 'Motor Insurance App',
      'description': '$plan Subscription',
      'prefill': {
        'contact': contact.isNotEmpty ? contact : '9999999999',
        'email': email.isNotEmpty ? email : 'test@example.com',
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// 🔹 Payment Handlers
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    if (_selectedPlan == null || _selectedDays == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Plan details missing ❌")),
      );
      return;
    }

    final now = DateTime.now().toUtc();
    final expiry = now.add(Duration(days: _selectedDays!));

    await FirebaseFirestore.instance.collection('subscriptions').doc(uid).set({
      'subscriptionStatus': 'active',
      'plan': _selectedPlan,
      'trialStart': null,
      'trialEnd': null,
      'paymentId': response.paymentId,
      'expiryDate': Timestamp.fromDate(expiry),
    }, SetOptions(merge: true));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${_selectedPlan!.toUpperCase()} Activated ✅")),
      );
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment Failed ❌")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External Wallet Selected: ${response.walletName}")),
    );
  }

  /// 🔹 UI
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
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_showPlans) {
      return const Scaffold(
        body: Center(child: Text("Checking subscription...")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose a Plan"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            tooltip: 'Sign Out',
            onPressed: () => _handleSignOut(context),
          ),
          const SizedBox(width: 8),
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
            onTap: () => _openCheckout("monthly", 149, 30),
          ),
          _buildPlanCard(
            title: "6-Month Plan",
            price: "₹699",
            subtitle: "Equivalent to ₹116/month (save ~22%)",
            onTap: () => _openCheckout("6_months", 699, 180),
          ),
          _buildPlanCard(
            title: "Yearly Plan",
            price: "₹999",
            subtitle: "Equivalent to ₹83/month (save ~44%)",
            onTap: () => _openCheckout("yearly", 999, 365),
          ),
        ],
      ),
    );
  }
}
