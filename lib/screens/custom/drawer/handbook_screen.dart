import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HandbookScreen extends StatelessWidget {
  const HandbookScreen({super.key});

  final List<Map<String, String>> handbookTopics = const [
    {
      "title": "User Manual",
      "url": "https://drive.google.com/file/d/13a5VFTE83L1mPy48VIXaUZNGI0pL29ML/view?usp=sharing"
    },
    {
      "title": "Motor Insurance Basics",
      "url": "https://drive.google.com/file/d/1NNiVpM9IGt63n8WT3MiB60xaLDIhqoBL/view?usp=sharing"
    },
    {
      "title": "Claim Procedure",
      "url": "https://drive.google.com/file/d/1LRB7ROLQ1YltGtEqQj4Vllt4MfIv4HSg/view?usp=sharing"
    },
    {
      "title": "Premium Calculation Guide",
      "url": "https://drive.google.com/file/d/1HKxjmNzYLogFpJn-07mO2YFjUsYmKUAM/view?usp=sharing"
    },
    {
      "title": "Legal Liabilities Explained",
      "url": "https://drive.google.com/file/d/1I_NzfMLZwq2NPtMTJP9fN9z4sIpAiAcr/view?usp=sharing"
    },
    {
      "title": "Tips for Vehicle Safety",
      "url": "https://drive.google.com/file/d/1u6n4iJD33cCd1erpMcOFFpOSUkENw8yo/view?usp=sharing"
    },
  ];

  void _openPDF(BuildContext context, String url) async {
    final Uri pdfUrl = Uri.parse(url);
    if (await canLaunchUrl(pdfUrl)) {
      await launchUrl(pdfUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open the document")),
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
                'Handbook',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: handbookTopics.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: ListTile(
              // leading: Icon(
              //   Icons.book,
              //   color: Colors.indigo.shade700,
              //   size: 32,
              // ),
              leading: Image.asset(
                "assets/drawer/book.png", // your custom icon path
                width: 32,
                height: 32,
                color: Colors.indigo.shade700,
              ),
              title: Text(
                handbookTopics[index]["title"]!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios,
                  size: 18, color: Colors.black54),
              onTap: () => _openPDF(context, handbookTopics[index]["url"]!),
            ),
          );
        },
      ),
    );
  }
}
