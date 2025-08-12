import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanydetailList extends StatefulWidget {
  const CompanydetailList({Key? key}) : super(key: key);

  @override
  State<CompanydetailList> createState() => _CompanydetailListState();
}

class _CompanydetailListState extends State<CompanydetailList> {

  List<CompanyDetails> companyDetailsList = [
    CompanyDetails(name: 'Acko General Insurance Limited', tollno: '1860-266-2256', email: 'hello@acko.com', website: 'www.acko.com'),
    CompanyDetails(name: 'Bajaj Allianz General Insurance Company Limited', tollno: '1800-209-5858', email: 'customercare@ bajajallianz.co.in', website: 'www.bajajallianz.com'),
    CompanyDetails(name: 'Bharti Axa General Insurance Company Limited', tollno: '1800-103-2292', email: 'claims@bharti-axagi.co.in', website: 'www.bharti-axagi.co.in'),
    CompanyDetails(name: 'Cholamandalam MS General Insurance Company Ltd', tollno: '1800-200-5544', email: 'customercare@chola.murugappa.com', website: 'www.cholainsurance.com'),
    CompanyDetails(name: 'DHFL General Insurance Limited', tollno: '1800-123-0004', email: 'mycare@dhflinsurance.com', website: 'www.dhflinsurance.com'),
    CompanyDetails(name: 'Future Generali India Insurance Company Ltd', tollno: '1800-220-233', email: 'fgcare@futuregenerali.in', website: 'www.general.futuregenerali.in'),
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        backgroundColor:Colors.indigo.shade700,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12),bottomRight: Radius.circular(12),)
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Companies Details", style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListView.separated(
                primary: false,
                shrinkWrap: true,
                  itemCount: companyDetailsList.length,
                separatorBuilder:(context,index)=>SizedBox(height: height*0.0,) ,
                itemBuilder: (context,index)=>
                _buildCard(height: height, width: width, name: companyDetailsList[index].name,
                    toll: companyDetailsList[index].tollno, email: companyDetailsList[index].email,
                    website: companyDetailsList[index].website)
              )
            ],
          ),
        ),
      ),
    );
  }

  Container _buildCard({
    required double height,
    required double width,
    required String name,
    required String toll,
    required String email,
    required String website,
  }) {
    return Container(
            height: height*0.24,
            width: double.infinity,
            child: Stack(
              children: [
                Container(
                  height: height*0.09,
                  decoration: BoxDecoration(
                      // color: Colors.blue.shade200,
                      // color: Colors.indigoAccent.shade100,
                      color: const Color(0xFFF0F4FF),
                      borderRadius:const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      )
                  ),
                ),
                Positioned(
                    top: 10,
                    left: 20,
                    child: Container(
                      height: height*0.21,
                      width: width*0.9,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          // color: Colors.indigo.shade200,
                          // color: Colors.blue.shade200,
                          borderRadius: BorderRadius.circular(12),
                          // border: Border.fromBorderSide(BorderSide(color: Colors.indigo.shade700)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // Shadow color
                            spreadRadius: 2,                     // Spread radius
                            blurRadius: 7,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: height*0.065,
                            width: width*0.9,
                            decoration: BoxDecoration(
                                color: Colors.indigo.shade500,
                                // color: Colors.blue.shade200,
                                borderRadius: const BorderRadius.only(topRight: Radius.circular(12),topLeft: Radius.circular(12))
                            ),
                            child: Center(child:
                            Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                                child: Text(name, style: GoogleFonts.poppins(color:Colors.white,fontSize: 15,fontWeight: FontWeight.bold),))),
                          ),
                          Padding(padding:const EdgeInsets.symmetric(vertical: 2),child: _cardRaw(width: width, fieldName: 'Toll Free Number', fieldValue: toll)),
                          _cardRaw(width: width, fieldName: 'Email', fieldValue: email),
                          Padding(padding:const EdgeInsets.only(bottom: 1,top: 2),child: _cardRaw(width: width, fieldName: 'Website', fieldValue: website)),
                          const Divider(color: Colors.black,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap:()async{
                                  await _launchWebsite("https://${website}");
                                },
                                child: Card(
                                  color: Colors.transparent,
                                  elevation: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Padding(padding:const EdgeInsets.symmetric(horizontal: 3),child: Icon(CupertinoIcons.arrow_up_right_square_fill)),
                                      Text("Website",style: GoogleFonts.poppins(fontWeight: FontWeight.w500),)
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap:()async{
                                  await _launchCall(toll);
                                },
                                child: Card(
                                  color: Colors.transparent,
                                  elevation: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                     const Padding(padding:const EdgeInsets.symmetric(horizontal: 3),child: Icon(Icons.call)),
                                      Text("Call",style: GoogleFonts.poppins(fontWeight: FontWeight.w500),)
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: ()async{
                                  await _launchEmail(email);
                                },
                                child: Padding(
                                  padding:const EdgeInsets.symmetric(horizontal: 15),
                                  child: Card(
                                    color: Colors.transparent,
                                    elevation: 0,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Padding(padding:const EdgeInsets.symmetric(horizontal: 3),child: Icon(Icons.email_rounded)),
                                        Text("Email",style: GoogleFonts.poppins(fontWeight: FontWeight.w500),)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                )
                )
              ],
            ),
          );
  }

  Row _cardRaw({required double width,required String fieldName,required fieldValue}) {
    return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 10),
                                width: width*0.35,
                                child: Text(fieldName,
                                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                                ),
                              ),
                              Container(
                                width: width*0.5,
                                child: Text(fieldValue,overflow: TextOverflow.ellipsis,),
                              )
                            ],
                          );
  }

  Future<void> _launchEmail(String email) async {
    final uri =Uri.parse('mailto:${email}?subject=&body=');
    if(await canLaunchUrl(uri)){
      await launchUrl(uri);
    }else{
      throw Exception('Could not launch $uri');
    }
  }

  Future<void> _launchWebsite(String url) async {
    final Uri uri = Uri.parse(url);
    if(await canLaunchUrl(uri)){
      await launchUrl(uri,mode: LaunchMode.externalNonBrowserApplication );
    }else{
      throw Exception('Could not launch $uri');
    }
  }

  Future<void> _launchCall(String PhoneNo) async {
    String phone ="+91"+PhoneNo;
    Uri uri =Uri.parse("tel:${phone}") ;
    if(await canLaunchUrl(uri)){
      await launchUrl(uri);
    }else{
      throw Exception('Could not launch $uri');
    }
  }
}

class CompanyDetails{
  String name;
  String tollno;
  String email;
  String website;

  CompanyDetails({required this.name,required this.tollno,required this.email,required this.website});
}
