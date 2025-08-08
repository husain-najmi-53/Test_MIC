import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class RtoZoneFinder extends StatefulWidget {
  const RtoZoneFinder({super.key});

  @override
  State<RtoZoneFinder> createState() => _RtoZoneFinderState();
}

class _RtoZoneFinderState extends State<RtoZoneFinder> {
  final TextEditingController _findController = TextEditingController();

  String location = "-";
  String privateCar = "-";
  String twoWheeler = "-";
  String taxi = "-";
  String commercialVehicle = "-";

  Map<String, Map<String, String>> rtoData = {};

  @override
  void initState() {
    super.initState();
    loadRtoData();
  }

  Future<void> loadRtoData() async {
    final String jsonString = await rootBundle.loadString('assets/rto_data.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    setState(() {
      rtoData = jsonMap.map((key, value) => MapEntry(
            key,
            Map<String, String>.from(value),
          ));
    });
  }

  void findRtoZone() {
    String input = _findController.text.trim().toUpperCase();
    if (rtoData.containsKey(input)) {
      setState(() {
        location = rtoData[input]!["Location"]!;
        privateCar = rtoData[input]!["Private Car"]!;
        twoWheeler = rtoData[input]!["Two Wheeler"]!;
        taxi = rtoData[input]!["Taxi"]!;
        commercialVehicle = rtoData[input]!["Commercial vehicle"]!;
      });
    } else {
      setState(() {
        location = "-";
        privateCar = "-";
        twoWheeler = "-";
        taxi = "-";
        commercialVehicle = "-";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("RTO code not found")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12)),
        ),
        title: Text(
          "RTO Zone Finder",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.05),
              TextFormField(
                controller: _findController,
                decoration: InputDecoration(
                  hintText: "Enter First 4 digits (Ex. MH12)",
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.indigo.shade200, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.indigo.shade700, width: 2),
                  ),
                ),
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              SizedBox(height: height * 0.03),
              SizedBox(
                width: width * 0.5,
                height: 48,
                child: ElevatedButton(
                  onPressed: findRtoZone,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.shade700,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    "Find",
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: height * 0.06),
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                shadowColor: Colors.indigo.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.receipt_long,
                              color: Colors.indigo.shade200, size: 28),
                          const SizedBox(width: 10),
                          Text(
                            "RTO Zone Details",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.indigo.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Divider(color: Colors.grey.shade300, thickness: 1),
                      const SizedBox(height: 10),
                      _buildDetailTile("Location", location, Icons.location_on),
                      _buildDetailTile(
                          "Private Car", privateCar, Icons.directions_car),
                      _buildDetailTile(
                          "Two Wheeler", twoWheeler, Icons.pedal_bike),
                      _buildDetailTile("Taxi", taxi, Icons.local_taxi),
                      _buildDetailTile("Commercial vehicle", commercialVehicle,
                          Icons.local_shipping),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTile(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.indigo.shade200, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
