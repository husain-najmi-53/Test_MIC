import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? userData;
  Map<String, dynamic>? subscriptionData;

  String _formatDate(dynamic value) {
    if (value == null) return "-";
    if (value is Timestamp) {
      return DateFormat("dd MMM yyyy").format(value.toDate());
    }
    if (value is DateTime) {
      return DateFormat("dd MMM yyyy").format(value);
    }
    return value.toString();
  }

  bool isProfileOpen = false;
  bool isSubscriptionOpen = true; // open by default
  bool isEditing = false;
  Color get primaryColor => Colors.indigo.shade700;

  // Animation controller for blinking effect
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;

  // Controllers for editable fields
  late TextEditingController nameController;
  late TextEditingController occupationController;
  late TextEditingController cityController;

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<DocumentSnapshot<Map<String, dynamic>>> _getUserDoc() async {
    final uid = _auth.currentUser!.uid;
    return await _db.collection("users").doc(uid).get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _getSubscriptionDoc() async {
    final uid = _auth.currentUser!.uid;
    return await _db.collection("subscriptions").doc(uid).get();
  }

  Future<void> _loadData() async {
    final userDoc = await _getUserDoc();
    final subDoc = await _getSubscriptionDoc();

    setState(() {
      userData = userDoc.data();
      subscriptionData = subDoc.data();
    });

    // Initialize controllers once we have real data
    nameController = TextEditingController(text: userData?['name'] ?? '');
    occupationController =
        TextEditingController(text: userData?['occupation'] ?? '');
    cityController = TextEditingController(text: userData?['city'] ?? '');
    selectedState = userData?['state'] ?? '';
  }

  // List of states for dropdown
  final List<String> states = [
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chhattisgarh",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttar Pradesh",
    "Uttarakhand",
    "West Bengal",
    "Andaman and Nicobar Islands",
    "Chandigarh",
    "Delhi",
    "Jammu and Kashmir",
    "Lakshadweep",
    "Puducherry",
    "Ladakh"
  ];

  String? selectedState;

  @override
  void initState() {
    super.initState();

    // Initialize blink animation
    _blinkController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..repeat(reverse: true);

    _blinkAnimation =
        Tween<double>(begin: 0.3, end: 1.0).animate(_blinkController);

    nameController = TextEditingController();
    occupationController = TextEditingController();
    cityController = TextEditingController();
    selectedState = '';

    _loadData(); // Load user and subscription data
  }

  @override
  void dispose() {
    // Clean up controllers
    _blinkController.dispose();
    nameController.dispose();
    occupationController.dispose();
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null || subscriptionData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final profileMap = {
      "Full Name": userData?['name'] ?? '',
      "Email": userData?['email'] ?? '',
      "Phone Number": userData?['phone'] ?? '',
      "Occupation": userData?['occupation'] ?? '',
      "State": userData?['state'] ?? '',
      "City": userData?['city'] ?? '',
    };

    final subscriptionMap = {
      "Plan": subscriptionData?['plan'] ?? '',
      "Status": subscriptionData?['subscriptionStatus'] ?? '',
      "Start Date": _formatDate(subscriptionData?['startDate']),
      "Expiry Date": _formatDate(subscriptionData?['expiryDate']),
    };

    final String status = (subscriptionData?['subscriptionStatus'] ?? '')
        .toString()
        .toLowerCase();

    final bool isActive = status == 'active';
    final bool isTrial = status == 'trial';
    //final bool isExpired = status == 'expired';

    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: const Text(
          "My Profile",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // 🔹 Static Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, primaryColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 60, color: primaryColor),
                ),
                const SizedBox(height: 12),
                Text(
                  userData?['name'] ?? '',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  userData?['occupation'] ?? '',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 12),
                isEditing
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _saveProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            icon: const Icon(Icons.save),
                            label: const Text("Save"),
                          ),
                          const SizedBox(width: 10),
                          OutlinedButton.icon(
                            onPressed: _cancelEditing,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            icon: const Icon(Icons.cancel),
                            label: const Text("Cancel"),
                          ),
                        ],
                      )
                    : ElevatedButton.icon(
                        onPressed: _startEditing,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        icon: const Icon(Icons.edit),
                        label: const Text("Edit Profile"),
                      ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 Scrollable Body
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 🔽 Profile Details
                  _buildExpansionSection(
                    sectionKey: ValueKey(isProfileOpen),
                    title: "Profile Details",
                    data: profileMap,
                    isEditing: isEditing,
                    initiallyExpanded: isProfileOpen,
                    onExpansionChanged: (expanded) {
                      setState(() {
                        isProfileOpen = expanded;
                        if (expanded) isSubscriptionOpen = false;
                      });
                    },
                  ),

                  // 🔽 Subscription Details
                  _buildExpansionSection(
                    sectionKey: ValueKey(isSubscriptionOpen),
                    title: "Subscription Details",
                    data: subscriptionMap,
                    isEditing: false, // Subscription is never editable
                    initiallyExpanded: isSubscriptionOpen,
                    onExpansionChanged: (expanded) {
                      setState(() {
                        isSubscriptionOpen = expanded;
                        if (expanded) isProfileOpen = false;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // 🔹 Fixed Bottom Section (status only)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          children: [
            Icon(
              isActive
                  ? Icons.verified_user
                  : isTrial
                      ? Icons.access_time
                      : Icons.error_outline,
              color: isActive
                  ? Colors.green
                  : isTrial
                      ? Colors.blue
                      : Colors.orange,
              size: 28,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isActive
                    ? "Your subscription is active and valid until ${_formatDate(subscriptionData?['expiryDate'])}."
                    : isTrial
                        ? "Your trial is active until ${_formatDate(subscriptionData?['expiryDate'])}."
                        : "Your subscription has expired. Please subscribe to continue.",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(width: 8),
            if (isActive) // 🔹 Show cancel only if active
              OutlinedButton.icon(
                onPressed: _confirmCancelSubscription,
                icon: const Icon(Icons.cancel_outlined),
                label: const Text("Cancel"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade700,
                  side: BorderSide(color: Colors.red.shade300),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // 🔹 Start editing profile
  void _startEditing() {
    setState(() {
      isEditing = true;
      isProfileOpen = true; // Open profile section when editing
      _blinkController.repeat(reverse: true); // Start blinking animation
    });
  }

  // 🔹 Save profile changes
  void _saveProfile() async {
    final uid = _auth.currentUser!.uid;

    await _db.collection("users").doc(uid).update({
      "name": nameController.text,
      "occupation": occupationController.text,
      "state": selectedState,
      "city": cityController.text,
    });

    setState(() {
      userData?['name'] = nameController.text;
      userData?['occupation'] = occupationController.text;
      userData?['state'] = selectedState!;
      userData?['city'] = cityController.text;
      isEditing = false;
      _blinkController.stop();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully")),
    );
  }

  // 🔹 Cancel editing
  void _cancelEditing() {
    // Reset controllers to original values
    nameController.text = userData?['name'] ?? '';
    occupationController.text = userData?['occupation'] ?? '';
    selectedState = userData?['state'] ?? '';
    cityController.text = userData?['city'] ?? '';

    setState(() {
      isEditing = false;
      _blinkController.stop(); // Stop blinking animation
    });
  }

  // 🔹 Helper to create expandable sections
  Widget _buildExpansionSection({
    Key? sectionKey,
    required String title,
    required Map<String, dynamic>? data,
    required bool isEditing,
    required bool initiallyExpanded,
    required Function(bool) onExpansionChanged,
    List<Widget> extraChildren = const [],
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 3,
        child: Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            key: sectionKey,
            initiallyExpanded: initiallyExpanded,
            onExpansionChanged: onExpansionChanged,
            collapsedIconColor: primaryColor,
            iconColor: primaryColor,
            title: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: primaryColor),
            ),
            children: [
              ...data!.entries.map((entry) {
                return ListTile(
                  leading: Icon(
                    _getIconForField(entry.key),
                    color: primaryColor,
                  ),
                  title: Text(entry.key,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: primaryColor)),
                  subtitle: isEditing && title == "Profile Details"
                      ? _buildEditableField(entry.key, entry.value)
                      : Text(entry.value, style: const TextStyle(fontSize: 15)),
                  // Add blinking effect to the tile when editing
                  tileColor: isEditing && title == "Profile Details"
                      ? Colors.blue.withOpacity(_blinkAnimation.value * 0.1)
                      : Colors.transparent,
                );
              }).toList(),
              ...extraChildren,
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Build editable field based on key
  Widget _buildEditableField(String key, String value) {
    switch (key) {
      case 'Full Name':
        return Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextFormField(
            controller: nameController,
            style: const TextStyle(fontSize: 15),
            decoration: const InputDecoration.collapsed(
              hintText: "Enter your full name",
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        );
      case 'Email':
      case 'Phone Number':
        // These fields are not editable
        return Text(value, style: const TextStyle(fontSize: 15));
      case 'Occupation':
        return Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextFormField(
            controller: occupationController,
            style: const TextStyle(fontSize: 15),
            decoration: const InputDecoration.collapsed(
              hintText: "Enter your occupation",
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        );
      case 'State':
        return Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedState,
              isExpanded: true,
              items: states.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: isEditing
                  ? (newValue) {
                      setState(() {
                        selectedState = newValue;
                      });
                    }
                  : null,
            ),
          ),
        );
      case 'City':
        return Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextFormField(
            controller: cityController,
            style: const TextStyle(fontSize: 15),
            decoration: const InputDecoration.collapsed(
              hintText: "Enter your city",
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        );
      default:
        return Text(value, style: const TextStyle(fontSize: 15));
    }
  }

  // 🔹 Buy subscription flow
  void _buySubscription() async {
    // Show snackbar or loader
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Redirecting to purchase...")),
    );

    // Navigate to your payment/subscribe screen
    Navigator.pushNamed(context, "/subscribe");
  }

  // 🔹 Confirm cancel flow
  void _confirmCancelSubscription() async {
    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Cancel subscription?"),
        content: const Text(
            "This will cancel your current plan. You can buy again anytime."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Yes, cancel"),
          ),
        ],
      ),
    );

    if (shouldCancel == true) {
      final uid = _auth.currentUser!.uid;

      // 🔹 Update Firestore
      await _db.collection("subscriptions").doc(uid).update({
        "subscriptionStatus": "Expired",
      });

      // 🔹 Update local state
      setState(() {
        subscriptionData?['subscriptionStatus'] = "Expired";
      });

      // 🔹 Notify user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Subscription canceled")),
      );

      // 🔹 Redirect to subscribe page (but they can still re-enter app)
      Navigator.pushReplacementNamed(context, "/subscribe");
    }
  }

  // 🔹 Assign icons based on field
  IconData _getIconForField(String field) {
    switch (field) {
      case 'Full Name':
        return Icons.person;
      case 'Occupation':
        return Icons.work_outline;
      case 'Email':
        return Icons.email_outlined;
      case 'Phone Number':
        return Icons.phone_android;
      case 'State':
        return Icons.map_outlined;
      case 'City':
        return Icons.location_city;
      case 'Plan':
        return Icons.star;
      case 'Start Date':
        return Icons.calendar_today;
      case 'Expiry Date':
        return Icons.event_busy;
      case 'Status':
        return Icons.verified;
      default:
        return Icons.info_outline;
    }
  }
}
