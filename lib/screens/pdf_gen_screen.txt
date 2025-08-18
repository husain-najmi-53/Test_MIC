import 'dart:typed_data';
import 'dart:io';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:motor_insurance_app/models/quotation_data.dart';
import 'package:motor_insurance_app/models/vehicle_data.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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
    "Zuno General Insurance"
  ];

  void toggleCompany(String company, bool? isSelected) {
    setState(() {
      if (selectedMode == "Company-wise") {
        // Only allow one company selection
        selectedCompanies.clear();
        if (isSelected ?? false) {
          selectedCompanies.add(company);
        }
      } else {
        if (isSelected ?? false) {
          selectedCompanies.add(company);
        } else {
          selectedCompanies.remove(company);
        }
      }
    });
  }

  void generateSelectedPDFs() async {
    if (selectedCompanies.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one company")),
      );
      return;
    }

    switch (selectedMode) {
      case "Basic":
        await _generatePDF(
          companies: selectedCompanies.toList(),
          includeAgentDetails: false,
        );
        break;

      case "Advance":
        await _generatePDF(
          companies: selectedCompanies.toList(),
          includeAgentDetails: true,
        );
        break;

      case "Company-wise":
        if (selectedCompanies.length > 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Only one company can be selected")),
          );
          return;
        }
        await _generatePDF(
          companies: selectedCompanies.toList(),
          includeAgentDetails: true,
        );
        break;
    }
  }

  Future<void> _generatePDF({
    required List<String> companies,
    required bool includeAgentDetails,
  }) async {
    final quotation = widget.finalData;
    final vehicleType = quotation.insuranceResult.vehicleType;
    final List<XFile> generatedFiles = [];
    final sections = vehicleCategorySections[vehicleType] ?? {};

    for (final company in companies) {
      try {
        // Create a new document for each company
        final pdf = pw.Document();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final filename =
            '${vehicleType}_${company.replaceAll(' ', '_')}_$timestamp.pdf';

        // Add page with company-specific content
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(18),
            build: (context) {
              List<pw.Widget> content = [];

              // Add company header
              // Company Header with padding
              content.add(
                pw.Container(
                  padding: const pw.EdgeInsets.only(bottom: 5),
                  child: pw.Text(
                    company,
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold),
                  ),
                ),
              );

              // Producer and Policy Details with better spacing
              content.add(
                pw.Container(
                  padding: const pw.EdgeInsets.fromLTRB(20, 0, 20, 2),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius:
                        const pw.BorderRadius.all(pw.Radius.circular(8)),
                  ),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if (includeAgentDetails) ...[
                        // Producer Details Section
                        pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                            padding:
                                const pw.EdgeInsets.only(top: 2, right: 20),
                            decoration: const pw.BoxDecoration(
                              border: pw.Border(
                                right: pw.BorderSide(color: PdfColors.grey300),
                              ),
                            ),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  "Producer Details",
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.SizedBox(height: 8),
                                pw.Text("Producer Name: ${quotation.agentName}",
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                    )),
                                pw.SizedBox(height: 4),
                                pw.Text(
                                    "Producer Email: ${quotation.agentEmail}",
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                    )),
                                pw.SizedBox(height: 4),
                                pw.Text(
                                    "Producer Contact: ${quotation.agentContact}",
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                      // Policy Details Section
                      pw.Expanded(
                        flex: includeAgentDetails ? 1 : 2,
                        child: pw.Container(
                          padding: pw.EdgeInsets.only(
                            top: 2,
                            left: includeAgentDetails ? 20 : 0,
                          ),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                "Policy Details",
                                style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.SizedBox(height: 8),
                              pw.Text(
                                  "Policy Plan: ${quotation.insuranceResult.vehicleType}",
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                    )),
                              pw.SizedBox(height: 4),
                              pw.Text(
                                  "Policy Start Date: ${quotation.policyStartDate.day}/${quotation.policyStartDate.month}/${quotation.policyStartDate.year}",
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                    )),
                              pw.SizedBox(height: 4),
                              pw.Text(
                                  "Policy End Date: ${quotation.policyEndDate.day}/${quotation.policyEndDate.month}/${quotation.policyEndDate.year}",
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                    )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );

              content.add(pw.SizedBox(height: 12));

              // Add sections
              sections.forEach((sectionTitle, fields) {
                content.add(
                  buildPdfSection(
                    sectionTitle: sectionTitle,
                    fields: fields,
                    quotation: quotation,
                  ),
                );
              });
              // Add total premium section
              content.add(pw.Divider());
              content.add(
                pw.Text(
                  "Total Premium: ${quotation.insuranceResult.totalPremium.toStringAsFixed(2)}",
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold),
                ),
              );

              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: content,
              );
            },
          ),
        );

        // Save the PDF for this company
        final pdfBytes = await pdf.save();

        if (kIsWeb) {
          // Create blob and trigger download
          final bytes = Uint8List.fromList(pdfBytes);
          final blob = html.Blob([bytes]);
          final url = html.Url.createObjectUrlFromBlob(blob);

          // Create download link
          final anchor = html.AnchorElement()
            ..href = url
            ..style.display = 'none'
            ..download = filename;

          // Add to document, click, and cleanup
          html.document.body?.append(anchor);
          anchor.click();
          anchor.remove();
          html.Url.revokeObjectUrl(url);
        } else {
          // Get the temporary directory
          final directory = await getTemporaryDirectory();
          final filePath = '${directory.path}/$filename';

          // Write the PDF file
          final file = File(filePath);
          await file.writeAsBytes(pdfBytes);

          // Add to the list of files to share
          generatedFiles.add(XFile(filePath));

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Generated PDF for $company"),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text("Failed to generate PDF for $company: ${e.toString()}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }

    // Share all generated PDFs
    if (!kIsWeb && generatedFiles.isNotEmpty) {
      try {
        await Share.shareXFiles(
          generatedFiles,
          text: 'Insurance Quotation PDFs',
        );
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error sharing PDFs: ${e.toString()}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }

    // Show completion message
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Generated PDFs for ${companies.length} companies"),
          backgroundColor: Colors.green,
        ),
      );
    }
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
            // Mode Selection
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
                          onChanged: (value) {
                            setState(() {
                              selectedMode = value!;
                              selectedCompanies.clear();
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text("Advance"),
                          value: "Advance",
                          groupValue: selectedMode,
                          activeColor: Colors.indigo[700],
                          onChanged: (value) {
                            setState(() {
                              selectedMode = value!;
                              selectedCompanies.clear();
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text("Company-wise"),
                          value: "Company-wise",
                          groupValue: selectedMode,
                          activeColor: Colors.indigo[700],
                          onChanged: (value) {
                            setState(() {
                              selectedMode = value!;
                              selectedCompanies.clear();
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Company Selection
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

pw.Widget buildPdfSection({
  required String sectionTitle,
  required List<String> fields,
  required QuotationData quotation,
}) {
  final insuranceResult = quotation.insuranceResult;
  final rows = <pw.Widget>[];

  for (var key in fields) {
    String? value;

    // Fetch from QuotationData for vehicle details
    switch (key) {
      case "ownerName":
        value = quotation.ownerName;
        break;
      case "make":
        value = quotation.make;
        break;
      case "model":
        value = quotation.model;
        break;
      case "registrationNumber":
        value = quotation.registrationNumber;
        break;
      case "seatingCapacity":
        value = quotation.seatingCapacity;
        break;
      case "otherCoverage":
        value = quotation.otherCoverage ?? '-';
        break;
      case "policyStartDate":
        value = "${quotation.policyStartDate.toLocal()}".split(' ')[0];
        break;
      case "policyEndDate":
        value = "${quotation.policyEndDate.toLocal()}".split(' ')[0];
        break;

      default:
        // Otherwise, get from insuranceResult.fieldData
        value = insuranceResult.fieldData[key] ?? '-';
    }

    if (key == "totalPremium") {
      value = insuranceResult.totalPremium.toStringAsFixed(2);
    }

    rows.add(
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(key,
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
          pw.Text(value, style: pw.TextStyle(fontSize: 8)),
        ],
      ),
    );
    rows.add(pw.SizedBox(height: 3));
  }

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        sectionTitle,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
          decoration: pw.TextDecoration.underline,
        ),
      ),
      pw.SizedBox(height: 6),
      pw.Column(children: rows),
      pw.SizedBox(height: 14),
    ],
  );
}
