import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionUpdateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Colors.white,
              Colors.indigo.shade100,
            ])),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: _buildTypeCard(
              height: height,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchWebsite(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication);
    } else {
      throw Exception('Could not launch $uri');
    }
  }

  Container _buildTypeCard({required double height}) {
    return Container(
      height: height * 0.42,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.indigo.shade700,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.indigo.shade700.withOpacity(0.3)),
        // gradient: LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight,colors: [Colors.white,Colors.indigo.shade300,]),
          boxShadow: [
            BoxShadow(
              color: Colors.indigo.withOpacity(0.3), // Shadow color
              spreadRadius: 2, // Spread radius
              blurRadius: 7,
              offset: const Offset(0, 4),
            ),
          ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            child: Center(
              child: Text(
                'G',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            ' New Version',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00BFFF), // Teal color
            ),
          ),

          Text(
            ' Avaiable',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.greenAccent, // Pink color
            ),
          ),

          SizedBox(height: 20),

          // Update Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () async {
              // await _launchWebsite(url);
              await _launchWebsite("https://www.google.com");
            },
            child: Text(
              'Update Now',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
