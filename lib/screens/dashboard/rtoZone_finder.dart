import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motor_insurance_app/models/rto_data.dart';

class RtoZoneFinder extends StatefulWidget {
  const RtoZoneFinder({Key? key}) : super(key: key);

  @override
  State<RtoZoneFinder> createState() => _RtoZoneFinderState();
}

class _RtoZoneFinderState extends State<RtoZoneFinder> {
  TextEditingController _findController = TextEditingController();
  String? Location;
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
                  if (val == null || val.isEmpty) {
                    return "Please enter the value ";
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
                      String upCase = _findController.text.trim().toUpperCase();
                      setState(() {
                        Location = rtoData.rtoCodes[upCase];
                      });
                      print(Location);
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
              Card(
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
              ),
              /*Container(
                height: height * 0.35,
                width: width * 0.9,
                decoration: BoxDecoration(
                  // color: Colors.indigo.shade200,
                  color: const Color(0xFFF0F4FF),
                  borderRadius: BorderRadius.circular(12),
                  // border: Border.fromBorderSide(BorderSide(color: Colors.indigo.withOpacity(0.3))),
                  border: Border.fromBorderSide(
                      BorderSide(color: Colors.indigo.shade700)),
                  *//*boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 2,                     // Spread radius
                      blurRadius: 7,
                      offset: const Offset(0, 4),
                    ),
                  ],*//*

                ),
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
                            fielValue: Location != null ? Location! : 'Pune',
                          )),
                      const Divider(color: Colors.black),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: _details(
                            width: width,
                            height: height,
                            fieldName: 'Private Car',
                            fielValue: 'A',
                          )),
                      const Divider(color: Colors.black),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: _details(
                            width: width,
                            height: height,
                            fieldName: 'Two Wheeler',
                            fielValue: 'A',
                          )),
                      const Divider(color: Colors.black),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: _details(
                            width: width,
                            height: height,
                            fieldName: 'Taxi',
                            fielValue: 'A',
                          )),
                      const Divider(color: Colors.black),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: _details(
                            width: width,
                            height: height,
                            fieldName: 'Commercial vehicle',
                            fielValue: 'C',
                          )),
                    ],
                  ),
                ),
              )*/
            ],
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
