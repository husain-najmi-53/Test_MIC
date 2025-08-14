import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class CashlessgarageList extends StatefulWidget {
  const CashlessgarageList({super.key});

  @override
  State<CashlessgarageList> createState() => _CashlessgarageListState();
}

class _CashlessgarageListState extends State<CashlessgarageList> {
  List<CashlessGarage> cashlessGarageList = [
    CashlessGarage(
        logo: 'assets/logos/acko.jpg',
        name: 'Acko General Insurance Limited',
        url: 'https://www.acko.com/garages/'),
    CashlessGarage(
        logo: 'assets/logos/bajaj.png',
        name: 'Bajaj Allianz General Insurance Co. Ltd.',
        url: 'https://www.bajajallianz.com/branch-locator.html'),
    CashlessGarage(
        logo: 'assets/logos/chola.png',
        name: 'Cholamandalam MS General Insurance Company Ltd',
        url: 'https://www.cholainsurance.com/cashless-garages/auto-centre'),
    CashlessGarage(
        logo: 'assets/logos/future_generali.png',
        name: 'Future Generali India Insurance Company Ltd',
        url: 'https://general.futuregenerali.in/garage-locator'),
    CashlessGarage(
        logo: 'assets/logos/digit.png',
        name: 'Go Digit General Insurance Limited',
        url: 'https://www.godigit.com/garages-map-page'),
    CashlessGarage(
        logo: 'assets/logos/hdfc.png',
        name: 'HDFC ERGO General Insurance Company Limited',
        url: 'https://www.hdfcergo.com/locators/cashless-garages-networks'),
    CashlessGarage(
        logo: 'assets/logos/icici.png',
        name: 'ICICI Lombard General Insurance Company Limited',
        url:
            'https://www.icicilombard.com/cashless-garages'),
    CashlessGarage(
        logo: 'assets/logos/iffco.png',
        name: 'Iffco Tokio General Insurance Company Ltd',
        url: 'https://www.iffcotokio.co.in/contact-us?tab=garage'),
    CashlessGarage(
        logo: 'assets/logos/zurich.jpg',
        name: 'Kotak Mahindra General Insurance Co. Ltd.',
        url: 'https://www.zurichkotak.com/network-locator/cashless-garages'),
    CashlessGarage(
        logo: 'assets/logos/Liberty_General_Insurance.jpg',
        name: 'Liberty General Insurance Ltd.',
        url:
            'https://www.libertyinsurance.in/products/CPMigration/PrefferedPartnerNetworks'),
    CashlessGarage(
        logo: 'assets/logos/magma.jpg',
        name: 'Magma HDI General Insurance Co. Ltd.',
        url: 'https://www.magmainsurance.com/web/magmainsurance/branches'),
    CashlessGarage(
        logo: 'assets/logos/national.jpg',
        name: 'National Insurance Co. Ltd.',
        url:
            'https://uat-nationalinsurance.nic.co.in/key-links/our-networks/cashless-garages'),
    CashlessGarage(
        logo: 'assets/logos/Navi.png',
        name: 'Navi General Insurance Ltd.',
        url: 'https://navi.com'), // Navi Doesnt have Cashless Garage Locator
    CashlessGarage(
        logo: 'assets/logos/newindia.png',
        name: 'The New India Assurance Co. Ltd.',
        url: 'https://www.newindia.co.in/garage-list'),
    CashlessGarage(
        logo: 'assets/logos/oriental.png',
        name: 'The Oriental Insurance Company Ltd.',
        url: 'https://orientalinsurance.org.in/network-garage'),
    CashlessGarage(
        logo: 'assets/logos/raheja.png',
        name: 'Raheja QBE General Insurance Co. Ltd.',
        url: 'https://www.rahejaqbe.com/garage-locator'),
    CashlessGarage(
        logo: 'assets/logos/reliance.png',
        name: 'Reliance General Insurance Co. Ltd.',
        url:
            'https://www.reliancegeneral.co.in/insurance/self-help/cashless-garages-and-hospitals.aspx'),
    CashlessGarage(
        logo: 'assets/logos/royal_sundaram.jpg',
        name: 'Royal Sundaram General Insurance Co. Ltd.',
        url: 'https://www.royalsundaram.in/cashless-garage'),
    CashlessGarage(
        logo: 'assets/logos/sbi.png',
        name: 'SBI General Insurance Co. Ltd.',
        url:
            'https://www.sbigeneral.in/claim/garage-network'),
    CashlessGarage(
        logo: 'assets/logos/shriram.jpg',
        name: 'Shriram General Insurance Co. Ltd.',
        url: 'https://www.shriramgi.com/cashless-garages'),
    CashlessGarage(
        logo: 'assets/logos/tataaig.png',
        name: 'Tata AIG General Insurance Co. Ltd.',
        url:
            'https://www.tataaig.com/locator/cashless-car-network-garages'),
    CashlessGarage(
        logo: 'assets/logos/uiic.png',
        name: 'United India Insurance Company Limited',
        url: 'https://uiic.co.in'),// UIIC Doesnt have Cashless Garage Locator
    CashlessGarage(
        logo: 'assets/logos/universalsompo.png',
        name: 'Universal Sompo General Insurance Co. Ltd.',
        url: 'https://www.universalsompo.com/cashless-hospitals/garages/'),
    CashlessGarage(
        logo: 'assets/logos/zuno.png',
        name: 'Zuno General Insurance',
        url: 'https://www.hizuno.com/cashless-garage-network'),
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      // backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade700,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        )),
        title: Text(
          "Cashless Garage List",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.04,
              ),
              ListView.separated(
                shrinkWrap: true,
                primary: false,
                itemCount: cashlessGarageList.length,
                separatorBuilder: (context, index) => SizedBox(
                  height: height * 0.02,
                ),
                itemBuilder: (context, index) => _buildCashlessGarageCard(
                    logo: cashlessGarageList[index].logo,
                    name: cashlessGarageList[index].name,
                    url: cashlessGarageList[index].url),
              )
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

  Widget _buildCashlessGarageCard(
      {required String logo, required String name, required String url}) {
    return GestureDetector(
      onTap: () async {
        await _launchWebsite(url);
        //await _launchWebsite("https://www.google.com");
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.fromBorderSide(
              BorderSide(color: Colors.black.withOpacity(0.2))),
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
              backgroundColor: Colors.transparent,
              radius: 30,
              child: logo.isEmpty
                  ? Image.asset('assets/fillerLogo.jpeg')
                  : Image.asset(logo),
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

class CashlessGarage {
  String logo;
  String name;
  String url;

  CashlessGarage({required this.logo, required this.name, required this.url});
}
