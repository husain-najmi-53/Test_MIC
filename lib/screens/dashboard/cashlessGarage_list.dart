
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class CashlessgarageList extends StatefulWidget {
  const CashlessgarageList({Key? key}) : super(key: key);

  @override
  State<CashlessgarageList> createState() => _CashlessgarageListState();
}

class _CashlessgarageListState extends State<CashlessgarageList> {

  List<CashlessGarage> cashlessGarageList = [
    CashlessGarage(logo: '', name: 'Acko General Insurance Limited', url: ''),
    CashlessGarage(logo: '', name: 'Bharti Axa General Insurance Company Limited', url: ''),
    CashlessGarage(logo: '', name: 'Cholamandalam MS General Insurance Company Ltd', url: ''),
    CashlessGarage(logo: '', name: 'DHFL General Insurance Limited', url: ''),
    CashlessGarage(logo: '', name: 'Future Generali India Insurance Company Ltd', url: ''),
    CashlessGarage(logo: '', name: 'Go Digit General Insurance Limited', url: ''),
    CashlessGarage(logo: '', name: 'HDFC ERGO General Insurance Company Limited', url: ''),
    CashlessGarage(logo: '', name: 'ICICI Lombard General Insurance Company Limited', url: ''),
    CashlessGarage(logo: '', name: 'Iffco Tokio General Insurance Company Ltd', url: ''),
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      // backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor:Colors.indigo.shade700,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12),bottomRight: Radius.circular(12),)
        ),
        title: Text("Cashless Garage List", style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.only(left:15,right:15,top: 0,bottom: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height*0.04,),
              ListView.separated(
                shrinkWrap: true,
                  primary: false,
                  itemCount: cashlessGarageList.length,
                separatorBuilder: (context,index)=>SizedBox(height:height*0.02 ,),
                itemBuilder: (context,index)=>
                _buildCashlessGarageCard(logo: cashlessGarageList[index].logo, name:cashlessGarageList[index].name, url:cashlessGarageList[index].url)
                ,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchWebsite(String url) async {
    final Uri uri = Uri.parse(url);
    if(await canLaunchUrl(uri)){
      await launchUrl(uri,mode: LaunchMode.externalNonBrowserApplication );
    }else{
      throw Exception('Could not launch $uri');
    }
  }

  Widget _buildCashlessGarageCard({required String logo,required String name, required String url}) {
    return GestureDetector(
      onTap: ()async{
        // await _launchWebsite(url);
        await _launchWebsite("https://www.google.com");
      },
      child: Container(
              padding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.fromBorderSide(BorderSide(color: Colors.black.withOpacity(0.2))),
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
                    child:logo.isEmpty ?Image.asset('assets/fillerLogo.jpeg'):Image.network(logo),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue.shade900,
                      ),
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class CashlessGarage{
  String logo;
  String name;
  String url;

  CashlessGarage({required this.logo,required this.name,required this.url});
}