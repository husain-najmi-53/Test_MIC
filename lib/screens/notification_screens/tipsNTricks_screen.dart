import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';

class TipsNTricksScreen extends StatefulWidget {
  const TipsNTricksScreen({Key? key}) : super(key: key);

  @override
  State<TipsNTricksScreen> createState() => _TipsNTricksScreenState();
}

class _TipsNTricksScreenState extends State<TipsNTricksScreen> {
  String messageText = "No Tips available";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is RemoteMessage) {
      // If coming from Firebase push
      setState(() {
        messageText = args.data['data'] ?? "No Data Found";
      });
    } else if (args is NotificationResponse) {
      // If coming from local notifications plugin
      final payload = args.payload != null ? jsonDecode(args.payload!) : {};
      setState(() {
        messageText = payload['data'] ?? "No Data Found";
      });
    } else {
      // If opened directly (no args)
      setState(() {
        messageText = "Default Tip: Stay tuned for updates!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(height: height * 0.5, color: Colors.deepOrange.shade50),
            Container(height: height * 0.5, color: Colors.indigo.shade50),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: height * 0.5,
                width: width * 0.85,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Container(
                      height: height * 0.15,
                      decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                        child: Text(
                          "Tips And Tricks",
                          style: GoogleFonts.abyssinicaSil(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Divider(color: Colors.black)),
                    Expanded(
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(Icons.close,
                                  color: Colors.deepOrange, size: 30),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                messageText,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(fontSize: 20),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                "Close",
                                style: GoogleFonts.poppins(
                                    fontSize: 18, color: Colors.red),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/*class TipsNTricksScreen extends StatelessWidget {
  final RemoteMessage? message;

  const TipsNTricksScreen({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = message?.notification?.title ?? "No Title";
    final body = message?.notification?.body ?? "No Body";
    final extraData = message?.data['data'] ?? "No Extra Data";

    return Scaffold(
      appBar: AppBar(title: const Text("Tips & Tricks")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🔔 Notification Title: $title"),
            Text("📄 Body: $body"),
            Text("📦 Extra Data: $extraData"),
          ],
        ),
      ),
    );
  }
}*/

