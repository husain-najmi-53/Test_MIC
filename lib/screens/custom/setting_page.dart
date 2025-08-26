import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool pushNotifications = true;
  bool notificationSound = true;
  bool notificationVibration = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      pushNotifications = prefs.getBool("pushNotifications") ?? true;
      notificationSound = prefs.getBool("notificationSound") ?? true;
      notificationVibration = prefs.getBool("notificationVibration") ?? false;
    });
  }

  Future<void> _updateSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);

    if (key == "pushNotifications") {
      if (value) {
        FirebaseMessaging.instance.subscribeToTopic("general");
      } else {
        FirebaseMessaging.instance.unsubscribeFromTopic("general");
      }
    }
  }  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        children: [
          _buildSectionTitle("Notifications"),
          _buildSwitchTile(
              "Push Notifications",
              pushNotifications,
              (v) => setState(() => pushNotifications = v),
              Icons.notifications),
          _buildSwitchTile("Notification Sound", notificationSound,
              (v) => setState(() => notificationSound = v), Icons.volume_up),
          _buildSwitchTile(
              "Notification Vibration",
              notificationVibration,
              (v) => setState(() => notificationVibration = v),
              Icons.vibration),
          const SizedBox(height: 20),
          _buildSectionTitle("Help & Support"),
          _buildListTile("FAQ / Help Center", Icons.help_outline, () {
            _openDummyPage(
                context,
                "FAQ / Help Center",
                [
                  {
                    "q": "How do I reset my password?",
                    "a":
                        "Go to Settings > Account > Reset Password. Enter your email and follow the link sent."
                  },
                  {
                    "q": "How do I contact support?",
                    "a":
                        "Use the Contact Support option in this menu or email support@myapp.com."
                  },
                  {
                    "q": "How do I update the app?",
                    "a": "Visit your app store and check for updates."
                  },
                  {
                    "q": "How to enable notifications?",
                    "a":
                        "Go to Settings > Notifications and toggle the options you prefer."
                  },
                  {
                    "q": "How to delete my account?",
                    "a":
                        "Contact support from this app to request account deletion."
                  },
                  {
                    "q": "Is my data secure?",
                    "a":
                        "Yes, we use industry-standard encryption to protect all user data."
                  },
                ],
                pageType: "faq");
          }),
          _buildListTile("Contact Support", Icons.support_agent, () {
            _openDummyPage(
                context,
                "Contact Support",
                [
                  {
                    "title": "Email",
                    "value": "support@myapp.com",
                    "icon": Icons.email
                  },
                  {
                    "title": "Phone",
                    "value": "+1 234 567 8900",
                    "icon": Icons.phone
                  },
                ],
                pageType: "support");
          }),
          const SizedBox(height: 20),
          _buildSectionTitle("About"),
          _buildListTile("App Version", Icons.info_outline, () {
            _openDummyPage(context, "App Version",
                "You are using MyApp version 1.0.0\n\nLatest Update: August 2025\n- Bug fixes and performance improvements\n- Added new notification options\n- Improved UI design",
                pageType: "appversion");
          }),
          const SizedBox(height: 20),
          _buildSectionTitle("Legal & About"),
          _buildListTile("Terms & Conditions", Icons.description, () {
            _openDummyPage(
                context,
                "Terms & Conditions",
                [
                  {
                    "icon": Icons.gavel,
                    "header": "Usage Policy",
                    "points": [
                      "Use the app only for **legal purposes**.",
                      "Do not misuse or exploit app services.",
                      "Violation may result in account suspension."
                    ]
                  },
                  {
                    "icon": Icons.security,
                    "header": "Security",
                    "points": [
                      "We take necessary measures to protect your data.",
                      "You are responsible for safeguarding your password."
                    ]
                  },
                ],
                pageType: "modernDoc");
          }),
          _buildListTile("Privacy Policy", Icons.lock_outline, () {
            _openDummyPage(
                context,
                "Privacy Policy",
                [
                  {
                    "icon": Icons.privacy_tip,
                    "header": "Data Protection",
                    "points": [
                      "We **never sell** personal data.",
                      "All user data is encrypted and secured.",
                      "Users can request data deletion anytime."
                    ]
                  },
                  {
                    "icon": Icons.shield,
                    "header": "User Rights",
                    "points": [
                      "You can opt-out of certain features anytime.",
                      "We comply with GDPR and CCPA regulations."
                    ]
                  },
                ],
                pageType: "modernDoc");
          }),
          _buildListTile("App Version Info", Icons.system_update, () {
            _openDummyPage(
                context,
                "App Version Info",
                {
                  "version": "1.0.0 (Build 12)",
                  "release": "August 15, 2025",
                  "platforms": "Android & iOS",
                  "requirements": "Android 7 / iOS 13"
                },
                pageType: "appversion");
          }),
          _buildListTile("Licenses", Icons.article, () {
            _openDummyPage(
                context,
                "Licenses",
                [
                  {
                    "icon": Icons.extension,
                    "header": "Open Source Packages",
                    "points": [
                      "http 1.2.0 - Networking",
                      "provider 6.0.5 - State management",
                      "shared_preferences 2.2.1 - Local storage",
                      "intl 0.18.1 - Formatting"
                    ]
                  },
                  {
                    "icon": Icons.balance,
                    "header": "Legal Notice",
                    "points": [
                      "All libraries follow their respective OSS licenses.",
                      "© 2025 MyApp Inc. All rights reserved."
                    ]
                  }
                ],
                pageType: "modernDoc");
          }),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: Colors.indigo.shade400,
            letterSpacing: 1.1,
          ),
        ));
  }

  Widget _buildSwitchTile(
      String title, bool value, Function(bool) onChanged, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigo.shade700),
      title: Text(title,
          style: TextStyle(
              fontWeight: FontWeight.w600, color: Colors.indigo.shade800)),
      trailing: Switch(
        value: value,
        onChanged: (v) async {
          if (title == "Push Notifications") {
            // Handle push notifications specially
            await _handlePushNotificationToggle(v);
          } else {
            // For other settings, update immediately
            setState(() => onChanged(v));
            String key = title == "Notification Sound"
                ? "notificationSound"
                : "notificationVibration";
            await _updateSetting(key, v);
          }
        },
        activeColor: Colors.indigo.shade700,
      ),
    );
  }

  Future<void> _handlePushNotificationToggle(bool value) async {
    if (value) {
      // Optimistically update UI first
      setState(() {
        pushNotifications = true;
      });
      
      // Trying to enable notifications
      PermissionStatus status = await Permission.notification.status;
      
      if (status.isGranted) {
        // Permission already granted, just enable
        await _updateSetting("pushNotifications", true);
      } else if (status.isDenied) {
        // Request permission
        PermissionStatus newStatus = await Permission.notification.request();
        
        if (newStatus.isGranted) {
          // Permission granted, enable notifications
          await _updateSetting("pushNotifications", true);
        } else {
          // Permission denied, revert toggle
          setState(() {
            pushNotifications = false;
          });
          
          if (newStatus.isPermanentlyDenied) {
            // Take user to settings
            openAppSettings();
          }
        }
      } else if (status.isPermanentlyDenied) {
        // Permission permanently denied, revert toggle and take to settings
        setState(() {
          pushNotifications = false;
        });
        openAppSettings();
      }
    } else {
      // Disable notifications - update UI immediately
      setState(() {
        pushNotifications = false;
      });
      await _updateSetting("pushNotifications", false);
    }
  }
}

Widget _buildListTile(String title, IconData icon, VoidCallback onTap) {
  return ListTile(
    leading: Icon(icon, color: Colors.indigo.shade700),
    title: Text(title,
        style: TextStyle(
            fontWeight: FontWeight.w600, color: Colors.indigo.shade800)),
    trailing: Icon(Icons.chevron_right, color: Colors.indigo.shade300),
    onTap: onTap,
  );
}

void _openDummyPage(BuildContext context, String title, dynamic content,
    {String pageType = "text"}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) =>
          DummyPage(title: title, content: content, pageType: pageType),
    ),
  );
}

class DummyPage extends StatefulWidget {
  final String title;
  final dynamic content;
  final String pageType;

  const DummyPage(
      {super.key,
      required this.title,
      required this.content,
      this.pageType = "text"});

  @override
  State<DummyPage> createState() => _DummyPageState();
}

class _DummyPageState extends State<DummyPage> {
  late List<Map<String, String>> _faqList;
  late List<Map<String, String>> _filteredFaqList;
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchBar = false;

  @override
  void initState() {
    super.initState();
    if (widget.pageType == "faq") {
      _faqList = List<Map<String, String>>.from(widget.content);
      _filteredFaqList = _faqList;
    }
  }

  void _filterFAQs(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredFaqList = _faqList;
      } else {
        _filteredFaqList = _faqList
            .where((faq) =>
                faq["q"]!.toLowerCase().contains(query.toLowerCase()) ||
                faq["a"]!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _toggleSearchBar() {
    setState(() {
      _showSearchBar = !_showSearchBar;
      if (!_showSearchBar) {
        _searchController.clear();
        _filterFAQs('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;

    if (widget.pageType == "faq") {
      bodyContent = Column(
        children: [
          if (_showSearchBar)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Search FAQs...",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _toggleSearchBar,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
                onChanged: _filterFAQs,
              ),
            ),
          Expanded(
            child: _filteredFaqList.isEmpty
                ? const Center(
                    child: Text("No matching FAQs found"),
                  )
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: _filteredFaqList.map((faq) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 6, right: 40),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade100,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(faq["q"]!,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.indigo.shade900)),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 14, left: 40),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(faq["a"]!,
                                style: const TextStyle(fontSize: 15)),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
          ),
        ],
      );
    } else if (widget.pageType == "support") {
      bodyContent = GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        children: (widget.content as List<Map<String, dynamic>>).map((item) {
          return Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.indigo.shade50, Colors.blue.shade100]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.indigo.shade200,
                  child: Icon(item["icon"],
                      color: Colors.indigo.shade700, size: 28),
                ),
                const SizedBox(height: 10),
                Text(item["title"]!,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.indigo.shade800)),
                const SizedBox(height: 6),
                Text(item["value"]!,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: Colors.grey.shade700, fontSize: 13)),
              ],
            ),
          );
        }).toList(),
      );
    } else if (widget.pageType == "modernDoc") {
      bodyContent = ListView(
        padding: const EdgeInsets.all(20),
        children: (widget.content as List<Map<String, dynamic>>).map((section) {
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.indigo.shade100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigo.shade200),
              boxShadow: [
                BoxShadow(
                    color: Colors.indigo.shade200.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(section["icon"], color: Colors.indigo.shade700),
                  const SizedBox(width: 8),
                  Text(section["header"],
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade800)),
                ]),
                const SizedBox(height: 10),
                ...((section["points"] as List<String>).map((point) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Expanded(
                              child: Text(point,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade800,
                                      height: 1.5))),
                        ],
                      ),
                    ))),
              ],
            ),
          );
        }).toList(),
      );
    } else if (widget.pageType == "appversion") {
      bodyContent = Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.indigo.shade400, Colors.indigo.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                  color: Colors.indigo.shade200,
                  blurRadius: 12,
                  offset: const Offset(0, 6))
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.system_update, size: 60, color: Colors.white),
              const SizedBox(height: 16),
              Text(
                  widget.content is String
                      ? widget.content
                      : widget.content["version"],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 1.5)),
              if (widget.content is Map) ...[
                const SizedBox(height: 10),
                Text("Release Date: ${widget.content["release"]}",
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 14)),
                Text("Platforms: ${widget.content["platforms"]}",
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 14)),
                Text("Requirements: ${widget.content["requirements"]}",
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 14)),
              ]
            ],
          ),
        ),
      );
    } else {
      bodyContent = Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.info_outline, size: 60, color: Colors.indigo.shade600),
              const SizedBox(height: 16),
              Text(widget.content as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16, height: 1.5, color: Colors.grey.shade800)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: widget.pageType == "faq"
            ? [
                IconButton(
                  icon: Icon(_showSearchBar ? Icons.close : Icons.search),
                  onPressed: _toggleSearchBar,
                ),
              ]
            : null,
      ),
      body: bodyContent,
    );
  }
}
