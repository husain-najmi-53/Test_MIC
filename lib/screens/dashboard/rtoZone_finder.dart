import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motor_insurance_app/models/rto_data.dart';

class RtoZoneFinder extends StatefulWidget {
  const RtoZoneFinder({Key? key}) : super(key: key);

  @override
  State<RtoZoneFinder> createState() => _RtoZoneFinderState();
}

class _RtoZoneFinderState extends State<RtoZoneFinder> {
  final TextEditingController _findController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String? Location;
  String? Zone;
  String? District;
  String? State;
  RTOData rtoData = RTOData();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade700,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
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
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.1),

                /// 🔹 Label with * mark
                RichText(
                  text: TextSpan(
                    text: "Enter RTO Code (e.g. MH12)",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    children: [
                      TextSpan(
                        text: "*",
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 6),

                /// Input Box
                TextFormField(
                  controller: _findController,
                  textCapitalization: TextCapitalization.characters,
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  validator: (val) {
                    final regex = RegExp(r'^[A-Za-z]{2}\d{2}$');
                    if (val == null || val.isEmpty) {
                      return "This field is required";
                    } else if (!regex.hasMatch(val)) {
                      return "Enter correct format Ex: MH12";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Ex: MH12",
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w400,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.indigo.shade300, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.indigo.shade700, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.red.shade400, width: 1),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.red.shade600, width: 2),
                    ),
                  ),
                ),

                SizedBox(height: height * 0.03),

                /// 🔹 Find Button (ORIGINAL PLACE)
                Center(
                  child: SizedBox(
                    width: width * 0.55,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          String upCase =
                              _findController.text.trim().toUpperCase();
                          if (rtoData.rtoCodes[upCase] != null) {
                            setState(() {
                              Location = rtoData.rtoCodes[upCase]['Location'];
                              Zone = rtoData.rtoCodes[upCase]['Zone'];
                              District = rtoData.rtoCodes[upCase]['District'];
                              State = rtoData.rtoCodes[upCase]['State'];
                            });
                            //close keyboard
                            FocusScope.of(context).unfocus();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Data did not Match")),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Find",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: height * 0.08),

                /// 🔹 Info Box
                Container(
                  constraints: BoxConstraints(
                    minHeight: height * 0.30,
                    maxWidth: width * 0.95,
                  ),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildInfoTile(Icons.location_on, 'Location', Location),
                      Divider(),
                      _buildInfoTile(Icons.map, 'Zone', Zone),
                      Divider(),
                      _buildInfoTile(Icons.location_city, 'District', District),
                      Divider(),
                      _buildInfoTile(Icons.flag, 'State', State),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 Interactive Row Tile Widget
  Widget _buildInfoTile(IconData icon, String label, String? value) {
    return InkWell(
      // onTap: () {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('$label: ${value ?? "-"}')),
      //   );
      // },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.indigo.shade50,
              child: Icon(icon, color: Colors.indigo.shade700, size: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.indigo.shade800,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    value ?? '-',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
