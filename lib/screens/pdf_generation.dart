import 'package:flutter/material.dart';
import 'package:motor_insurance_app/models/quotation_data.dart';

class PdfSelectionScreen extends StatefulWidget {
  final QuotationData finalData;

  const PdfSelectionScreen({
    Key? key,
    required this.finalData,
  }) : super(key: key);

  @override
  State<PdfSelectionScreen> createState() => _PdfSelectionScreenState();
}

class _PdfSelectionScreenState extends State<PdfSelectionScreen> {
  String selectedMode = "Basic";
  final Set<String> selectedCompanies = {};

  final List<String> allCompanies = [
    "Acko General Insurance Limited",
    "Bajaj Allianz General Insurance Co. Ltd.",
    "Cholamandalam MS General Insurance Co. Ltd.",
    "Future Generali India Insurance Co. Ltd.",
    "Go Digit General Insurance Limited",
    "HDFC ERGO General Insurance Co. Ltd.",
    "ICICI Lombard General Insurance Co. Ltd.",
    "IFFCO-Tokio General Insurance Co. Ltd.",
    "Kotak Mahindra General Insurance Co. Ltd.",
    "Liberty General Insurance Ltd.",
    "Magma HDI General Insurance Co. Ltd.",
    "National Insurance Co. Ltd.",
    "Navi General Insurance Ltd.",
    "The New India Assurance Co. Ltd.",
    "The Oriental Insurance Company Ltd.",
    "Raheja QBE General Insurance Co. Ltd.",
    "Reliance General Insurance Co. Ltd.",
    "Royal Sundaram General Insurance Co. Ltd.",
    "SBI General Insurance Co. Ltd.",
    "Shriram General Insurance Co. Ltd.",
    "Tata AIG General Insurance Co. Ltd.",
    "United India Insurance Company Limited",
    "Universal Sompo General Insurance Co. Ltd.",
    "Zuno General Insurance",
  ];

  void toggleCompany(String company, bool? isSelected) {
    setState(() {
      isSelected ?? false
          ? selectedCompanies.add(company)
          : selectedCompanies.remove(company);
    });
  }

  void generateSelectedPDFs() async {
    if (selectedCompanies.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one company")),
      );
      return;
    }

    // Your PDF generation logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select PDF Options",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo[700],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mode Selection Card
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Mode:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text("Basic"),
                          value: "Basic",
                          groupValue: selectedMode,
                          activeColor: Colors.indigo[700],
                          onChanged: (value) =>
                              setState(() => selectedMode = value!),
                        ),
                        RadioListTile<String>(
                          title: const Text("Advance"),
                          value: "Advance",
                          groupValue: selectedMode,
                          activeColor: Colors.indigo[700],
                          onChanged: (value) =>
                              setState(() => selectedMode = value!),
                        ),
                        RadioListTile<String>(
                          title: const Text("Company-wise"),
                          value: "Company-wise",
                          groupValue: selectedMode,
                          activeColor: Colors.indigo[700],
                          onChanged: (value) =>
                              setState(() => selectedMode = value!),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Company Selection Card
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Companies:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(height: 1, thickness: 1),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: ListView.builder(
                        itemCount: allCompanies.length,
                        itemBuilder: (context, index) {
                          final company = allCompanies[index];
                          return CheckboxListTile(
                            title: Text(company),
                            value: selectedCompanies.contains(company),
                            onChanged: (val) => toggleCompany(company, val),
                            activeColor: Colors.indigo[700],
                            contentPadding: EdgeInsets.zero,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border:
              Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
        ),
        child: ElevatedButton.icon(
          onPressed: generateSelectedPDFs,
          icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
          label: const Text(
            "Generate PDFs",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo[700],
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            minimumSize: const Size.fromHeight(50),
          ),
        ),
      ),
    );
  }
}
