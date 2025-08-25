import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:motor_insurance_app/screens/auth/auth_service.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:animate_do/animate_do.dart';

class SubscribeScreen extends StatefulWidget {
  const SubscribeScreen({super.key});

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  late Razorpay _razorpay;
  String? _selectedPlan;
  int? _selectedAmount;
  int? _selectedDays;

  bool _loading = true;
  bool _showPlans = false;
  bool _trialUsed = false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    _checkSubscription();

    // Check if trial is already used
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      _hasUsedTrial(uid).then((used) {
        if (mounted) {
          setState(() {
            _trialUsed = used;
            _loading = false;
          });
        }
      });
    } else {
      _loading = false;
    }
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

    final doc = await FirebaseFirestore.instance
        .collection('subscriptions')
        .doc(uid)
        .get();

    if (!doc.exists) {
      setState(() {
        _loading = false;
        _showPlans = true;
        _selectedPlan = 'yearly';
        _selectedAmount = 999;
        _selectedDays = 365;
      });
      return;
    }

    final data = doc.data()!;
    final status = (data['subscriptionStatus'] ?? '').toString().toLowerCase();
    final expiry = data['expiryDate'];
    final DateTime? expiryDate =
        expiry is Timestamp ? expiry.toDate() : DateTime.tryParse(expiry ?? '');

    final bool isExpired =
        expiryDate == null || DateTime.now().isAfter(expiryDate);

    if ((status == 'active' || status == 'trial') && !isExpired) {
      // ✅ Active or Trial & valid → go home
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } else {
      // ❌ Expired or anything else
      if (status != 'expired') {
        await FirebaseFirestore.instance
            .collection('subscriptions')
            .doc(uid)
            .update({'subscriptionStatus': 'Expired'});
      }

      setState(() {
        _loading = false;
        _showPlans = true;
        _selectedPlan = 'yearly';
        _selectedAmount = 999;
        _selectedDays = 365;
      });
    }
  }

  /// Handle user sign out
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
    final doc = await FirebaseFirestore.instance
        .collection('subscriptions')
        .doc(uid)
        .get();

    if (!doc.exists) return false;

    final data = doc.data();
    return data?['trialUsed'] == true; // 🔹 Reliable check
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
      'subscriptionStatus': 'Trial',
      'plan': 'Trial',
      'trialStart': Timestamp.fromDate(now),
      'trialEnd': Timestamp.fromDate(trialEnd),
      'paymentId': null,
      'startDate': Timestamp.fromDate(now),
      'expiryDate': Timestamp.fromDate(trialEnd),
      'trialUsed': true, // 🔹 Permanent flag
    }, SetOptions(merge: true));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Trial Activated ✅")),
      );
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  /// 🔹 Razorpay checkout
  Future<void> _openCheckout() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    String contact = '';
    String email = '';

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists) {
      final data = userDoc.data();
      contact = data?['phone'] ?? '';
      email = data?['email'] ?? '';
    }

    var options = {
      'key': 'rzp_test_R7wSPViMlDXu00', // Replace with your Razorpay Key
      'amount': _selectedAmount! * 100,
      'name': 'Motor Insurance App',
      'description': '$_selectedPlan Subscription',
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
      'subscriptionStatus': 'Active',
      'plan': _selectedPlan,
      // trialFlag, trialStart and trialEnd should NOT be nulled out here
      'paymentId': response.paymentId,
      'startDate': Timestamp.fromDate(now),
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
      SnackBar(
          content: Text("External Wallet Selected: ${response.walletName}")),
    );
  }

  /// 🔹 UI
  Widget _buildPlanCard({
    required String title,
    required String price,
    required String subtitle,
    required String description,
    required String planId,
    bool isHighlighted = false,
  }) {
    final isSelected = _selectedPlan == planId;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPlan = planId;
          if (planId == 'monthly') {
            _selectedAmount = 149;
            _selectedDays = 30;
          } else if (planId == '6_months') {
            _selectedAmount = 699;
            _selectedDays = 180;
          } else if (planId == 'yearly') {
            _selectedAmount = 999;
            _selectedDays = 365;
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected ? Colors.indigo.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.indigo.shade700 : Colors.grey.shade300,
            width: isSelected ? 2.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Colors.indigo.shade200.withOpacity(0.5)
                  : Colors.grey.shade200,
              blurRadius: isSelected ? 15 : 10,
              spreadRadius: isSelected ? 2 : 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? Colors.indigo.shade900
                        : Colors.indigo.shade900,
                  ),
                ),
                if (isHighlighted)
                  const Chip(
                    label: Text(
                      'BEST VALUE',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                    backgroundColor: Colors.amber,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: isSelected
                    ? Colors.indigo.shade700
                    : Colors.indigo.shade900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? Colors.grey.shade700 : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            // Enhanced Description Section
            Row(
              children: [
                Icon(Icons.check_circle_outline,
                    size: 18, color: Colors.green.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.indigo.shade800
                          : Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: Colors.indigo.shade700),
        ),
      );
    }

    if (!_showPlans) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text("Checking subscription...")),
      );
    }

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
          child: FadeIn(
            duration: const Duration(milliseconds: 1200),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 24.0),
                            child: IconButton(
                              onPressed: () => _handleSignOut(context),
                              icon: Icon(Icons.logout,
                                  color: Colors.indigo.shade700, size: 24),
                            ),
                          ),
                        ),
                        SlideInDown(
                          duration: const Duration(milliseconds: 1000),
                          child: Text(
                            'Unlock Premium',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.indigo.shade900,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        FadeIn(
                          delay: const Duration(milliseconds: 200),
                          duration: const Duration(milliseconds: 1000),
                          child: Text(
                            "Choose a plan that's right for you",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildPlanCard(
                          title: 'Yearly Plan',
                          price: '₹999',
                          subtitle:
                              'Save up to 44% with our ultimate value plan.',
                          description: 'Equivalent to ₹83/month (save ~44%)',
                          planId: 'yearly',
                          isHighlighted: true,
                        ),
                        _buildPlanCard(
                          title: '6-Month Plan',
                          price: '₹699',
                          subtitle:
                              'Perfect for a semi-annual commitment. Save big!',
                          description: 'Equivalent to ₹116/month (save ~22%)',
                          planId: '6_months',
                        ),
                        _buildPlanCard(
                          title: 'Monthly Plan',
                          price: '₹149',
                          subtitle: 'Flexible access, cancel anytime.',
                          description: 'Monthly access to all premium features',
                          planId: 'monthly',
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 20.0),
                      child: Column(
                        children: [
                          _AnimatedButton(
                            onPressed: () async => await _openCheckout(),
                            color: Colors.indigo.shade700,
                            child: Text(
                              'SUBSCRIBE FOR ₹$_selectedAmount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (!_trialUsed && !_loading)
                            TextButton(
                              onPressed: () => _activateTrial(context),
                              child: Text(
                                'Start 7-Day Free Trial',
                                style: TextStyle(
                                  color: Colors.indigo.shade700,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
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
}

// Re-using the animated button widget from your login screen for consistency
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
