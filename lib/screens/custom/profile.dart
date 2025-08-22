import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Dummy profile data
  final Map<String, String> userData = {
    'Full Name': 'John Doe',
    'Email': 'john.doe@example.com',
    'Phone Number': '+91 9876543210',
    'Occupation': 'Agent',
    'State': 'Maharashtra',
    'City': 'Mumbai',
  };

  // Dummy subscription data
  final Map<String, String> subscriptionData = {
    'Plan': 'Premium',
    'Start Date': '01 Jan 2025',
    'Expiry Date': '31 Dec 2025',
    'Status': 'Active', // Change to 'Inactive' to see Buy button
  };

  bool isProfileOpen = false;
  bool isSubscriptionOpen = true; // open by default

  Color get primaryColor => Colors.indigo.shade700;

  @override
  Widget build(BuildContext context) {
    final bool isActive =
        (subscriptionData['Status'] ?? '').toLowerCase() == 'active';

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔹 Header Section
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
                    userData['Full Name']!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userData['Occupation']!,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Edit Profile tapped")),
                      );
                    },
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

            // 🔽 Profile Details
            _buildExpansionSection(
              key: ValueKey(isProfileOpen), // force rebuild when state changes
              title: "Profile Details",
              data: userData,
              initiallyExpanded: isProfileOpen,
              onExpansionChanged: (expanded) {
                setState(() {
                  isProfileOpen = expanded;
                  if (expanded)
                    isSubscriptionOpen = false; // close subscription
                });
              },
            ),

            // 🔽 Subscription Details + conditional action
            _buildExpansionSection(
              key: ValueKey(isSubscriptionOpen),
              title: "Subscription Details",
              data: subscriptionData,
              initiallyExpanded: isSubscriptionOpen,
              onExpansionChanged: (expanded) {
                setState(() {
                  isSubscriptionOpen = expanded;
                  if (expanded) isProfileOpen = false; // close profile
                });
              },
              extraChildren: [
                const SizedBox(height: 6),
                const Divider(height: 1),
                const SizedBox(height: 8),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        isActive
                            ? Icons.verified
                            : Icons.shopping_cart_outlined,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          isActive
                              ? "Your subscription is active."
                              : "Your subscription is inactive.",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (isActive)
                        OutlinedButton.icon(
                          onPressed: _confirmCancelSubscription,
                          icon: const Icon(Icons.cancel_outlined),
                          label: const Text("Cancel Subscription"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red.shade700,
                            side: BorderSide(color: Colors.red.shade300),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        )
                      else
                        ElevatedButton.icon(
                          onPressed: _buySubscription,
                          icon: const Icon(Icons.shopping_bag_outlined),
                          label: const Text("Buy Subscription"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Helper to create expandable sections
  Widget _buildExpansionSection({
    Key? key,
    required String title,
    required Map<String, String> data,
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
            key: key,
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
              ...data.entries.map((entry) {
                return ListTile(
                  leading: Icon(
                    _getIconForField(entry.key),
                    color: primaryColor,
                  ),
                  title: Text(entry.key,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: primaryColor)),
                  subtitle:
                      Text(entry.value, style: const TextStyle(fontSize: 15)),
                );
              }).toList(),
              ...extraChildren,
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Confirm cancel flow
  void _confirmCancelSubscription() async {
    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Cancel subscription?"),
        content: const Text(
            "This will cancel your current plan. You have to buy again."),
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
      setState(() {
        subscriptionData['Status'] = 'Inactive';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Subscription canceled")),
      );
    }
  }

  // 🔹 Buy flow (demo)
  void _buySubscription() async {
    // You can navigate to purchase screen here.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Redirecting to purchase...")),
    );
    // Example: After successful purchase, mark Active
    // await Future.delayed(const Duration(seconds: 1));
    // setState(() => subscriptionData['Status'] = 'Active');
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
