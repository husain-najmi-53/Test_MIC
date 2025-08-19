import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClaimcalulatorType extends StatefulWidget {
  const ClaimcalulatorType({Key? key}) : super(key: key);

  @override
  State<ClaimcalulatorType> createState() => _ClaimcalulatorTypeState();
}

class _ClaimcalulatorTypeState extends State<ClaimcalulatorType> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        title: const Text('Select Claim Type',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo.shade700,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(begin:Alignment.topLeft,end:Alignment.bottomRight,
              colors: [Colors.white,Colors.indigo.shade100,])
        ),
        child: Padding(
            padding:const EdgeInsets.all(16),
            child: Center(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox( height: height * 0.23,),
                  GestureDetector(
                      onTap: (){Navigator.pushNamed(context, '/TpclaimScreen');},
                      child: _buildTypeCard(height: height, icon: Icons.add_chart_rounded, type: 'TP Calculator')),
                  SizedBox( height: height * 0.02,),
                  GestureDetector(
                      onTap: (){Navigator.pushNamed(context, '/OdclaimScreen'); },
                      child: _buildTypeCard(height: height, icon: Icons.calendar_view_week, type: 'Own Damage Calculator')),
                  Spacer(),
                  buildCText(text: "We have developed a Claim Calculator as per "),
                  buildCText(text: "Our Knowledge and IRDA Guidelines "),
                  buildCText(text: "Actual Amount may Vary from Calculated "),
        
                  SizedBox( height: height * 0.02,),
                  buildCText(text: "Let us Know if you have any Suggestions."),
                ],
              ),
            ),
        ),
      ),
    );
  }

  Text buildCText({required String text}) {
    return Text(text,style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade900,
              ),);
  }

  Container _buildTypeCard({required double height,required IconData icon,required String type}) {
    return Container(
                height: height*0.11,
                padding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.indigo.shade700.withOpacity(0.3)),
                  // gradient: LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight,colors: [Colors.white,Colors.indigo.shade300,]),
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
                    Icon(icon, size: 30, color: Colors.blue),
                    const SizedBox(width: 16),
                    Text(
                      type,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        // color: Colors.blue.shade900,
                        color: Colors.indigo.shade700,
                      ),
                    ),
                  ],
                ),
              );
  }
}
