import 'package:flutter/material.dart';

class AppFeaturesScreen extends StatelessWidget {
  const AppFeaturesScreen({super.key});

  final List<Map<String, dynamic>> features = const [
    {
      "title": "Premium Calculator",
      "desc": "Calculate insurance premium for any vehicle type.",
      "icon": Icons.calculate,
    },
    {
      "title": "Policy Renewal",
      "desc": "Easily renew your existing insurance policy.",
      "icon": Icons.refresh,
    },
    {
      "title": "Claim Assistance",
      "desc": "File and track insurance claims seamlessly.",
      "icon": Icons.assignment_turned_in,
    },
    // {
    //   "title": "Vehicle Database",
    //   "desc": "Access all vehicle types and their insurance details.",
    //   "icon": Icons.directions_car,
    // },
    {
      "title": "Discount & Offers",
      "desc": "Check available discounts, NCB, and special offers.",
      "icon": Icons.local_offer,
    },
    {
      "title": "Legal Coverage Info",
      "desc": "Know about legal liabilities and coverage options.",
      "icon": Icons.gavel,
    },
  ];

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
                'App Features',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: features.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: ListTile(
              leading: Icon(
                features[index]["icon"],
                color: Colors.indigo.shade700,
                size: 32,
              ),
              title: Text(
                features[index]["title"],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              subtitle: Text(
                features[index]["desc"],
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),
          );
        },
      ),
    );
  }
}
