import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppUsScreen extends StatelessWidget {
  const WhatsAppUsScreen({super.key});

  // Replace with your support WhatsApp number including country code
  final String whatsappNumber = "+911234567890";

  void _openWhatsApp(BuildContext context) async {
    final Uri whatsappUrl = Uri.parse(
        "https://wa.me/$whatsappNumber?text=Hello, I need support with my insurance app.");

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open WhatsApp")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade700,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white), // white back arrow
        centerTitle: true,
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 8),
              Text(
                'WhatsApp Us',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(
            //   Icons.wechat,
            //   color: Colors.green,
            //   size: 100,
            // ),
            Image.asset(
              'assets/drawer/whatsapp.png',
              height: 100, // same as size
              width: 100,
            ),
            const SizedBox(height: 24),
            const Text(
              "Need help or support?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "You can reach out to us on WhatsApp for any queries or assistance related to your motor insurance.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openWhatsApp(context),
                icon: Image.asset(
                  "assets/drawer/whatsapp.png", // your custom icon path
                  width: 24,
                  height: 24,
                  color: Colors.white,
                ),
                label: const Text("Chat on WhatsApp"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
