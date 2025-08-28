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
    CompanyDetails(
        name: 'Acko General Insurance Limited',
        tollno: '1860-266-2256',
        email: 'hello@acko.com',
        website: 'www.acko.com'),
    CompanyDetails(
        name: 'Bajaj Allianz General Insurance Company Limited',
        tollno: '1800-209-5858',
        email: 'customercare@ bajajallianz.co.in',
        website: 'www.bajajallianz.com'),
    // CompanyDetails(
    //     name: 'Bharti Axa General Insurance Company Limited',
    //     tollno: '1800-103-2292',
    //     email: 'service@bhartiaxa.com',
    //     website: 'www.bhartiaxa.com'),
    CompanyDetails(
        name: 'Cholamandalam MS General Insurance Company Ltd',
        tollno: '1800-200-5544',
        email: 'customercare@cholams.murugappa.com',
        website: 'www.cholainsurance.com'),
    // CompanyDetails(
    //     name: 'DHFL General Insurance Limited',
    //     tollno: '1800-123-0004',
    //     email: 'mycare@dhflinsurance.com',
    //     website: 'www.dhflinsurance.com'),
    CompanyDetails(
        name: 'Generali Central Insurance Company Ltd',
        tollno: '1800-220-233',
        email: 'fgcare@futuregenerali.in',
        website: 'www.general.futuregenerali.in'),
    CompanyDetails(
        name: 'Go Digit General Insurance Limited',
        tollno: '1800-258-5956',
        email: 'hello@godigit.com',
        website: 'www.godigit.com'),
    CompanyDetails(
        name: 'HDFC ERGO General Insurance Company Limited',
        tollno: '1800-2700-700',
        email: 'care@hdfcergo.com',
        website: 'www.hdfcergo.com'),
    CompanyDetails(
        name: 'ICICI Lombard General Insurance Company Limited',
        tollno: '1800-2666',
        email: 'customersupport@icicilombard.com',
        website: 'www.icicilombard.com'),
    CompanyDetails(
        name: 'Iffco Tokio General Insurance Company Ltd',
        tollno: '1800-103-5499',
        email: 'websupport@iffcotokio.co.in',
        website: 'www.iffcotokio.co.in'),
    CompanyDetails(
        name: 'Kotak Mahindra General Insurance Co. Ltd.',
        tollno: '1800-266-4545',
        email: 'care@kotak.com',
        website: 'www.kotakgeneral.com'),
    CompanyDetails(
        name: 'Liberty General Insurance Ltd.',
        tollno: '1800-266-5844',
        email: 'care@libertyinsurance.in',
        website: 'www.libertyinsurance.in'),
    CompanyDetails(
        name: 'Magma HDI General Insurance Co. Ltd.',
        tollno: '1800-266-3202',
        email: 'info@magma-hdi.co.in',
        website: 'www.magmahdi.com'),
    CompanyDetails(
        name: 'National Insurance Co. Ltd.',
        tollno: '1800-345-0330',
        email: 'customer.support@nic.co.in',
        website: 'www.nationalinsurance.nic.co.in'),
    CompanyDetails(
        name: 'Navi General Insurance Ltd.',
        tollno: '1860-266-7711',
        email: 'service@navi.com',
        website: 'www.navi.com'),
    CompanyDetails(
        name: 'The New India Assurance Co. Ltd.',
        tollno: '1800-209-1415',
        email: 'newindia@newindia.co.in',
        website: 'www.newindia.co.in'),
    CompanyDetails(
        name: 'The Oriental Insurance Company Ltd.',
        tollno: '1800-118-485',
        email: 'customer.support@orientalinsurance.co.in',
        website: 'www.orientalinsurance.org.in'),
    CompanyDetails(
        name: 'Raheja QBE General Insurance Co. Ltd.',
        tollno: '1800-102-7406',
        email: 'customer.service@rahejaqbe.com',
        website: 'www.rahejaqbe.com'),
    CompanyDetails(
        name: 'Reliance General Insurance Co. Ltd.',
        tollno: '1800-3009',
        email: 'rgicl.services@relianceada.com',
        website: 'www.reliancegeneral.co.in'),
    CompanyDetails(
        name: 'Royal Sundaram General Insurance Co. Ltd.',
        tollno: '1860-425-0000',
        email: 'customer.services@royalsundaram.in',
        website: 'www.royalsundaram.in'),
    CompanyDetails(
        name: 'SBI General Insurance Co. Ltd.',
        tollno: '1800-102-1111',
        email: 'customer.care@sbigeneral.in',
        website: 'www.sbigeneral.in'),
    CompanyDetails(
        name: 'Shriram General Insurance Co. Ltd.',
        tollno: '1800-300-30000',
        email: 'customercare@shriramgi.com',
        website: 'www.shriramgi.com'),
    CompanyDetails(
        name: 'Tata AIG General Insurance Co. Ltd.',
        tollno: '1800-266-7780',
        email: 'customersupport@tataaig.com',
        website: 'www.tataaig.com'),
    CompanyDetails(
        name: 'United India Insurance Company Limited',
        tollno: '1800-425-3333',
        email: 'customercare@uiic.co.in',
        website: 'www.uiic.co.in'),
    CompanyDetails(
        name: 'Universal Sompo General Insurance Co. Ltd.',
        tollno: '1800-22-4030',
        email: 'contactus@universalsompo.com',
        website: 'www.universalsompo.com'),
    CompanyDetails(
        name: 'Zuno General Insurance',
        tollno: '1800-123-0004',
        email: 'customercare@zunoi.com',
        website: 'www.zunoi.com'),
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
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
          "Companies Details",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView.builder(
          itemCount: companyDetailsList.length,
          itemBuilder: (context, index) => _buildCard(
            height: height,
            width: width,
            name: companyDetailsList[index].name,
            toll: companyDetailsList[index].tollno,
            email: companyDetailsList[index].email,
            website: companyDetailsList[index].website,
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required double height,
    required double width,
    required String name,
    required String toll,
    required String email,
    required String website,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Name Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.indigo.shade500,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                name,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12),
            
            // Company Details
            _cardRow(fieldName: 'Toll Free Number', fieldValue: toll),
            const SizedBox(height: 8),
            _cardRow(fieldName: 'Email', fieldValue: email),
            const SizedBox(height: 8),
            _cardRow(fieldName: 'Website', fieldValue: website),
            const SizedBox(height: 12),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 12),
            
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: CupertinoIcons.arrow_up_right_square_fill,
                  label: "Website",
                  onTap: () => _launchWebsite("https://${website}"),
                ),
                _buildActionButton(
                  icon: Icons.call,
                  label: "Call",
                  onTap: () => _launchCall(toll),
                ),
                _buildActionButton(
                  icon: Icons.email_rounded,
                  label: "Email",
                  onTap: () => _launchEmail(email),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardRow({required String fieldName, required String fieldValue}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            fieldName,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            fieldValue,
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.indigo.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.indigo.shade700),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.indigo.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchEmail(String email) async {
    final uri = Uri.parse('mailto:${email}?subject=&body=');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw Exception('Could not launch $uri');
    }
  }

  Future<void> _launchWebsite(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication);
    } else {
      throw Exception('Could not launch $uri');
    }
  }

  Future<void> _launchCall(String PhoneNo) async {
    // Remove any non-digit characters from phone number
    String cleanedPhone = PhoneNo.replaceAll(RegExp(r'[^0-9]'), '');
    Uri uri = Uri.parse("tel:$cleanedPhone");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw Exception('Could not launch $uri');
    }
  }
}

class CompanyDetails {
  String name;
  String tollno;
  String email;
  String website;

  CompanyDetails({
    required this.name,
    required this.tollno,
    required this.email,
    required this.website,
  });
}