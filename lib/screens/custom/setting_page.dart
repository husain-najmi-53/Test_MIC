import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with WidgetsBindingObserver {
  bool pushNotifications = true;
  bool notificationSound = true;
  bool notificationVibration = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadSettings();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _syncPermissionState();
    }
  }

  Future<void> _syncPermissionState() async {
    final prefs = await SharedPreferences.getInstance();

    // Check current system permission status
    PermissionStatus currentStatus = await Permission.notification.status;

    // Determine if notifications should be enabled based on permission
    bool shouldEnableNotifications = currentStatus.isGranted;

    // Update the toggle state to match system permission
    if (shouldEnableNotifications != pushNotifications) {
      setState(() {
        pushNotifications = shouldEnableNotifications;
      });

      // Save the updated preference
      await prefs.setBool("pushNotifications", shouldEnableNotifications);

      // Handle Firebase subscription
      if (shouldEnableNotifications) {
        FirebaseMessaging.instance.subscribeToTopic("general");
      } else {
        FirebaseMessaging.instance.unsubscribeFromTopic("general");
      }
    } else {}
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Load other settings
    bool savedNotificationSound = prefs.getBool("notificationSound") ?? true;
    bool savedNotificationVibration =
        prefs.getBool("notificationVibration") ?? false;

    // Check actual system permission for push notifications
    PermissionStatus permissionStatus = await Permission.notification.status;
    bool actualPushNotifications = permissionStatus.isGranted;

    setState(() {
      pushNotifications = actualPushNotifications;
      notificationSound = savedNotificationSound;
      notificationVibration = savedNotificationVibration;
    });

    // Save the actual push notification state
    await prefs.setBool("pushNotifications", actualPushNotifications);

    // Handle Firebase subscription based on actual permission
    if (actualPushNotifications) {
      FirebaseMessaging.instance.subscribeToTopic("general");
    } else {
      FirebaseMessaging.instance.unsubscribeFromTopic("general");
    }
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
  }

  Future<void> _handlePushNotificationToggle(bool requestedValue) async {
    // Simply open app notification settings - let user handle it there
    await AppSettings.openAppSettings(type: AppSettingsType.notification);
    _syncPermissionState(); // Try
    // After returning to app, permission state will be synced in didChangeAppLifecycleState
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Support Request&body=Hello, I need help with...',
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        // Fallback to generic email app
        final Uri fallbackUri = Uri.parse('mailto:$email');
        if (await canLaunchUrl(fallbackUri)) {
          await launchUrl(fallbackUri);
        } else {
          _showErrorDialog('Email app not found',
              'Please install an email app to send emails.');
        }
      }
    } catch (e) {
      _showErrorDialog('Error', 'Could not open email app. Please try again.');
    }
  }

  Future<void> _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        _showErrorDialog('Phone app not found',
            'Could not open phone app. Please dial $phoneNumber manually.');
      }
    } catch (e) {
      _showErrorDialog('Error', 'Could not open phone app. Please try again.');
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
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
              (value) async => await _handlePushNotificationToggle(value),
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
                    "q": "What is AutoInsure?",
                    "a":
                        "AutoInsure is a simple and smart motor insurance app that helps you compare, calculate, and buy motor insurance policies easily."
                  },
                  {
                    "q": "How does AutoInsure help me?",
                    "a":
                        "It saves your time by generating instant quotations from multiple insurance companies so you can choose the best plan."
                  },
                  {
                    "q": "How do I get an insurance quotation?",
                    "a":
                        "Just enter your vehicle details and preferences. AutoInsure generates quotes instantly."
                  },
                  {
                    "q": "Can I compare quotations from multiple companies?",
                    "a":
                        "Yes. You can compare policies company-wise or view advanced comparisons to check coverage, premium, and benefits."
                  },
                  {
                    "q": "Is the premium calculator accurate?",
                    "a":
                        "Yes, the calculator uses the official premium and coverage details provided by insurance companies."
                  },
                  {
                    "q": "Do I need an account to use AutoInsure?",
                    "a":
                        "Yes, creating an account helps us personalize your experience, save your quotes, and notify you about renewals."
                  },
                  {
                    "q": "Is my data safe?",
                    "a":
                        "Absolutely. AutoInsure follows secure authentication and data protection measures to keep your personal and vehicle details safe."
                  },
                  {
                    "q": "Is AutoInsure free to use?",
                    "a":
                        "No, it requires a subscription for full access."
                  },
                  {
                    "q": "What are the benefits of subscription?",
                    "a":
                        "Subscribers get access to advanced comparison tools, premium insights, personalized notifications, and exclusive offers."
                  },
                  {
                    "q": "How do I pay for the subscription?",
                    "a":
                        "You can pay through secure online methods like UPI, cards, or net banking."
                  },
                  {
                    "q": "Will I get reminders for policy renewal?",
                    "a":
                        "Yes, AutoInsure sends timely notifications so you never miss your policy renewal."
                  },
                  {
                    "q": "Can I control notifications?",
                    "a":
                        "Yes, you can customize notification preferences in the app settings."
                  },
                  {
                    "q": "How do I contact support?",
                    "a":
                        "You can reach us through the in-app support section or via email."
                  },
                  {
                    "q": "Can AutoInsure help me buy the policy directly?",
                    "a":
                        "Yes, once you choose a quotation, you can proceed to purchase with generated quotes and agent support ."
                  }
                ],
                pageType: "faq");
          }),
          _buildListTile("Contact Support", Icons.support_agent, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ContactSupportPage(
                  onEmailTap: _launchEmail,
                  onPhoneTap: _launchPhone,
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          _buildSectionTitle("About"),
          _buildListTile("App Version", Icons.info_outline, () {
            _openDummyPage(context, "App Version",
                "You are using AutoInsure version 1.0.0\n\nLatest Update: September 2025\n- Bug fixes and performance improvements\n- Added new notification options\n- Improved UI design",
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
                  "release": "2nd September 2025",
                  "platforms": "Android",
                  "requirements": "Android 7"
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
                      "© 2025 AutoInsure Inc. All rights reserved."
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
          // Check if this is the push notifications toggle
          if (title == "Push Notifications") {
            await onChanged(v); // This will call _handlePushNotificationToggle
          } else {
            // For other toggles, update the state and preferences directly
            setState(() {
              if (title == "Notification Sound") {
                notificationSound = v;
              } else if (title == "Notification Vibration") {
                notificationVibration = v;
              }
            });
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

class ContactSupportPage extends StatelessWidget {
  final Function(String) onEmailTap;
  final Function(String) onPhoneTap;

  const ContactSupportPage({
    super.key,
    required this.onEmailTap,
    required this.onPhoneTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Support"),
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Get in touch with our support team',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // Email Support Card
            _buildSupportCard(
              icon: Icons.email,
              title: 'Email Support',
              subtitle: 'support@autoinsure.co.in',
              description: 'Send us an email for detailed support',
              onTap: () => onEmailTap('support@autoinsure.co.in'),
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            // Phone Support Card
            _buildSupportCard(
              icon: Icons.phone,
              title: 'Phone Support',
              subtitle: '+91 93252 47903',
              description: 'Call us directly for immediate assistance',
              onTap: () => onPhoneTap('+91 93252 47903'),
              color: Colors.green,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
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
