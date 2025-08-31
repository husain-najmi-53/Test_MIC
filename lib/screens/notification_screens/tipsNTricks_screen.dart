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
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Center(
          child: Container(
            height: height * 0.65,
            width: width * 0.9,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header Section
                Container(
                  height: height * 0.12,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade700,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.indigo.shade700,
                        Colors.indigo.shade500,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Tips & Tricks",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                
                // Content Section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Stack(
                      children: [
                        // Tip Content
                        Center(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                messageText,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  height: 1.5,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        // Close Button (top right)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.indigo,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                        
                        // Close Text (bottom right)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.indigo.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "Close",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.indigo.shade800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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