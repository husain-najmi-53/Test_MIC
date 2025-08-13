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
      // backgroundColor: const Color(0xFFF0F4FF),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.1,
                ),
                TextFormField(
                  controller: _findController,
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  validator: (val) {
                    final regex = RegExp(r'^[A-Za-z]{2}\d{2}$');
                    if (val == null || val.isEmpty) {
                      return "Please enter the value ";
                    } else if (!regex.hasMatch(val)) {
                      return "Please enter correct format Ex: mh12 or MH12  ";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      hintText: "Enter First 4 digit EX. MH12",
                      hintStyle: GoogleFonts.poppins(
                          color: Colors.black45, fontWeight: FontWeight.w400),
                      filled: true,
                      // fillColor:Colors.indigo.shade50,
                      // fillColor:Colors.blue.shade50,
                      fillColor: const Color(0xFFF0F4FF),
                      border: const UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      )),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Container(
                  width: width * 0.5,
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
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Data did not Match")));
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo.shade700,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: Text(
                        "Find",
                        style: GoogleFonts.poppins(color: Colors.white),
                      )),
                ),
                SizedBox(
                  height: height * 0.15,
                ),
                /*  Card(
                 color: const Color(0xFFF0F4FF),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                        children: [
                    Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                      child: _details(
                        width: width,
                        height: height,
                        fieldName: 'Location',
                        fielValue: Location != null ? Location! : '-',
                         )),
                       ]
                    ),
                  )
                ),*/
                Container(
                  constraints: BoxConstraints(
                    minHeight: height * 0.29, // Minimum height
                    maxWidth: width * 0.9, // Max width stays same
                  ),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFF0F4FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.indigo.shade700),
                  ),
                  child: IntrinsicHeight(
                    // Makes all rows equal height
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min, // Allows container to grow
                      children: [
                        _buildExpandableRow('Location', Location),
                        Divider(color: Colors.black54),
                        _buildExpandableRow('Zone', Zone),
                        Divider(color: Colors.black54),
                        _buildExpandableRow('District', District),
                        Divider(color: Colors.black54),
                        _buildExpandableRow('State', State),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _details extends StatelessWidget {
  const _details(
      {required this.width,
      required this.height,
      required this.fieldName,
      required this.fielValue});

  final double width;
  final double height;
  final String fieldName;
  final String fielValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: width * 0.4,
            height: height * 0.03,
            // color:Colors.red,
            child: Text(
              fieldName,
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
              overflow: TextOverflow.visible,
            )),
        SizedBox(
          width: width * 0.05,
        ),
        Container(
            width: width * 0.3,
            height: height * 0.03,
            // color:Colors.red,
            child: Text(
              fielValue,
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w300),
            )),
      ],
    );
  }
}
// New helper widget (place outside build method)
Widget _buildExpandableRow(String label, String? value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        // Column 1: Labels (left-aligned)
        Container(
          width: 130,  // Fixed width for labels
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              color: Colors.indigo.shade800,
            ),
          ),
        ),
        // Column 2: Values (left-aligned but starts after labels)
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 16),  // Space between columns
            child: Text(
              value ?? '-',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.left,  // Left-align within the column
              softWrap: true,
            ),
          ),
        ),
      ],
    ),
  );
}
