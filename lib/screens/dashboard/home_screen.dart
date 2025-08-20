import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motor_insurance_app/screens/custom/custom_drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade700,
        elevation: 3,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Text(
          'Motor Insurance Dashboard',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the hamburger icon color here
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(), // Using the custom drawer

      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection("users")
                    .doc(user?.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Text("No user data found");
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  final name = data["name"] ?? "No Name";

                  return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue.shade100,
                          child: const Icon(Icons.person,
                              size: 30, color: Colors.blue),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?.email ?? "No Email",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),
              Text(
                'Welcome to Motor Insurance!',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),

              const SizedBox(height: 8),
              Text(
                'Select a section to get started.',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 24),

              /// --- Section 1: Calculators ---
              DashboardSection(
                title: '🔢 Calculators',
                items: [
                  SectionItem(
                      title: 'Calculator',
                      icon: Icons.calculate,
                      onTap: () {
                        Navigator.pushNamed(context, '/vehicleType');
                      }),
                  // SectionItem(
                  //     title: 'Advanced Calculator',
                  //     icon: Icons.calculate_outlined,
                  //     onTap: () {}),
                  // SectionItem(
                  //     title: 'Company-wise Calculator',
                  //     icon: Icons.business,
                  //     onTap: () {}),
                  SectionItem(
                      title: 'RTO Zone Finder',
                      icon: Icons.location_on,
                      onTap: () {
                        Navigator.pushNamed(context, '/RtoZoneFinder');
                      }),
                  SectionItem(
                      title: 'IDV Master',
                      icon: Icons.assignment,
                      onTap: () {
                        Navigator.pushNamed(context, '/IdvMaster');
                      }),
                      SectionItem(
                      title: 'Claim Calculator',
                      icon: Icons.description,
                      onTap: () {
                        Navigator.pushNamed(context, '/ClaimcalulatorType');
                      }),
                ],
              ),

              const SizedBox(height: 28),

              /// --- Section 2: Company Info ---
              DashboardSection(
                title: '🏢 Company Info',
                items: [
                  SectionItem(
                      title: 'Company Details',
                      icon: Icons.info,
                      onTap: () {
                        Navigator.pushNamed(context, '/CompanyDetails');
                      }),
                  SectionItem(
                      title: 'Cashless Garage List',
                      icon: Icons.local_car_wash,
                      onTap: () {
                        Navigator.pushNamed(context, '/CashlessGarage');
                      }),
                  // SectionItem(
                  //     title: 'Claim Forms',
                  //     icon: Icons.document_scanner,
                  //     onTap: () {}),
                  // SectionItem(
                  //     title: 'RTO Forms', icon: Icons.article, onTap: () {}),
                  // SectionItem(
                  //     title: 'IRDA', icon: Icons.security, onTap: () {}),
                ],
              ),

              const SizedBox(height: 28),

              /// --- Section 3: Vehicle Info ---
              DashboardSection(
                title: '🚘 Vehicle Info',
                items: [
                  SectionItem(
                      title: 'RC Check',
                      icon: Icons.card_travel,
                      onTap: () async {
                        await _launchWebsite(
                            "https://vahan.parivahan.gov.in/nrservices/faces/user/citizen/citizenlogin.xhtml");
                        // await _launchWebsite("https://www.google.com");
                      }),
                  SectionItem(
                      title: 'DL Status',
                      icon: Icons.account_circle,
                      onTap: () async {
                        await _launchWebsite(
                            "https://parivahan.gov.in/rcdlstatus/?pur_cd=101");
                      }),
                  SectionItem(
                      title: 'E-Challan',
                      icon: Icons.money,
                      onTap: () async {
                        await _launchWebsite(
                            "https://echallan.parivahan.gov.in/index/accused-challan");
                      }),
                ],
              ),
            ],
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
}

class DashboardSection extends StatelessWidget {
  final String title;
  final List<SectionItem> items;

  const DashboardSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 700 ? 3 : 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.indigo.shade700,
          ),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) => items[index],
        ),
      ],
    );
  }
}

class SectionItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const SectionItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      shadowColor: Colors.indigo.shade100,
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.indigo.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.indigo.shade100,
                radius: 28,
                child: Icon(icon, size: 28, color: Colors.indigo.shade800),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
