import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late Future<Map<String, dynamic>> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _loadUserData();
  }

  Future<Map<String, dynamic>> _loadUserData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return {};

      // Load user data and subscription data in parallel
      final userFuture =
          FirebaseFirestore.instance.collection("users").doc(uid).get();

      final subFuture =
          FirebaseFirestore.instance.collection("subscriptions").doc(uid).get();

      final results = await Future.wait([userFuture, subFuture]);
      final userData = results[0].data() ?? {};
      final subData = results[1].data() ?? {};

      return {
        "name": userData["name"] ?? "N/A",
        "email": userData["email"] ?? "N/A",
        "phone": userData["phone"] ?? "N/A",
        "validUpto": subData["expiryDate"] != null
            ? DateFormat('dd MMM yyyy').format(subData["expiryDate"].toDate())
            : "Not Subscribed",
      };
    } catch (e) {
      print("Error loading user data: $e");
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final Color primaryColor = Colors.indigo.shade700;
    final Color iconColor = isDark ? Colors.white : Colors.indigo;
    final Color textColor = isDark ? Colors.white70 : Colors.black87;

    final double screenWidth = MediaQuery.of(context).size.width;
    final double drawerWidth = screenWidth < 600 ? screenWidth * 0.85 : 300;

    return Drawer(
      width: drawerWidth,
      child: Container(
        color: bgColor,
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: FutureBuilder<Map<String, dynamic>>(
                future: _userFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildShimmerLoading();
                  }

                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data!.isEmpty) {
                    return _buildErrorState();
                  }

                  return _buildUserData(snapshot.data!);
                },
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  _buildDrawerItem(context,
                      icon: Icons.home_outlined,
                      label: 'Home',
                      route: '/home',
                      iconColor: iconColor,
                      textColor: textColor),
                  _buildDrawerItem(context,
                      icon: Icons.account_circle_outlined,
                      label: 'Profile',
                      route: '/profile',
                      iconColor: iconColor,
                      textColor: textColor),
                  _buildDrawerItem(context,
                      icon: Icons.book_outlined,
                      label: 'Handbook of Insurance',
                      route: '/handbook',
                      iconColor: iconColor,
                      textColor: textColor),
                  _buildDrawerItem(context,
                      icon: Icons.chat_bubble_outline,
                      label: 'WhatsApp Us',
                      route: '/whatsappUs',
                      iconColor: iconColor,
                      textColor: textColor),
                  _buildDrawerItem(context,
                      icon: Icons.share_outlined,
                      label: 'Share Your Application',
                      route: '/shareApp',
                      iconColor: iconColor,
                      textColor: textColor),
                  _buildDrawerItem(context,
                      icon: Icons.rate_review_outlined,
                      label: 'Rate Your Application',
                      route: '/rateApp',
                      iconColor: iconColor,
                      textColor: textColor),
                  _buildDrawerItem(context,
                      icon: Icons.featured_play_list_outlined,
                      label: 'Application Features',
                      route: '/appFeatures',
                      iconColor: iconColor,
                      textColor: textColor),
                  _buildDrawerItem(context,
                      icon: Icons.system_update_outlined,
                      label: 'Update Your Application',
                      route: '/updateApp',
                      iconColor: iconColor,
                      textColor: textColor),
                  _buildDrawerItem(context,
                      icon: Icons.settings_outlined,
                      label: 'Settings',
                      route: '/settings',
                      iconColor: iconColor,
                      textColor: textColor),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(height: 32),
                  ),
                  _buildDrawerItem(context,
                      icon: Icons.logout,
                      label: 'Logout',
                      route: '/login',
                      iconColor: iconColor,
                      textColor: textColor,
                      replaceRoute: true),
                ],
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white30 : Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Developed by : NBK Software Solutions',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white30 : Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar shimmer
            ShimmerLoader(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(width: 20),

            // Details shimmer
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Name shimmer
                  ShimmerLoader(
                    child: Container(
                      width: 130,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Email shimmer
                  ShimmerLoader(
                    child: Container(
                      width: 160,
                      height: 15,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Phone shimmer
                  ShimmerLoader(
                    child: Container(
                      width: 110,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Valid until shimmer
                  ShimmerLoader(
                    child: Container(
                      width: 140,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Column(
      children: [
        CircleAvatar(
          radius: 42,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.error_outline,
            size: 42,
            color: Colors.red.shade700,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Unable to load profile",
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          "Tap to retry",
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildUserData(Map<String, dynamic> data) {
    return Center(
      child: Container(
        constraints:
            const BoxConstraints(maxWidth: 300), // Optional: limit max width
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar on the left
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child:
                  Icon(Icons.person, size: 40, color: Colors.indigo.shade700),
            ),
            const SizedBox(width: 20),

            // User details on the right
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data["name"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    data["email"],
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Mobile: ${data["phone"]}",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "Valid upto: ${data["validUpto"]}",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
    required Color iconColor,
    required Color textColor,
    bool replaceRoute = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            if (replaceRoute) {
              Navigator.pushReplacementNamed(context, route);
            } else {
              Navigator.pushNamed(context, route);
            }
          },
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.indigo.withOpacity(0.1),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: iconColor),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Shimmer Loader Widget
class ShimmerLoader extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const ShimmerLoader({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
  }) : super(key: key);

  @override
  _ShimmerLoaderState createState() => _ShimmerLoaderState();
}

class _ShimmerLoaderState extends State<ShimmerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity:
              0.5 + (_controller.value * 0.5), // Oscillates between 0.5 and 1.0
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
