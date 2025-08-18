import 'dart:typed_data';
import 'dart:io';
//import 'package:printing/printing.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:motor_insurance_app/models/quotation_data.dart';
import 'package:motor_insurance_app/models/vehicle_data.dart';

// Helper function to safely parse a string value to a double
double _safeParseDouble(dynamic value) {
  if (value is num) {
    return value.toDouble();
  } else if (value is String) {
    return double.tryParse(value) ?? 0.0;
  }
  return 0.0;
}

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
    "Bajaj Allianz General Insurance Company Limited",
    "Cholamandalam MS General Insurance Company Ltd",
    "Future Generali India Insurance Company Ltd",
    "Go Digit General Insurance Limited",
    "HDFC ERGO General Insurance Company Limited",
    "ICICI Lombard General Insurance Company Limited",
    "Iffco Tokio General Insurance Company Ltd",
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

  final Map<String, Map<String, String>> insurerContactInfo = {
    "Acko General Insurance Limited": {
      "phone": "1860-266-2256",
      "email": "hello@acko.com",
      "claims": "Visit www.acko.com for claims information.",
    },
    "Bajaj Allianz General Insurance Company Limited": {
      "phone": "1800-209-5858",
      "email": "customercare@bajajallianz.co.in",
      "claims": "Visit www.bajajallianz.com for claims information.",
    },
    "Cholamandalam MS General Insurance Company Ltd": {
      "phone": "1800-200-5544",
      "email": "customercare@cholams.murugappa.com",
      "claims": "Visit www.cholainsurance.com for claims information.",
    },
    "Future Generali India Insurance Company Ltd": {
      "phone": "1800-220-233",
      "email": "fgcare@futuregenerali.in",
      "claims": "Visit www.general.futuregenerali.in for claims information.",
    },
    "Go Digit General Insurance Limited": {
      "phone": "1800-258-5956",
      "email": "hello@godigit.com",
      "claims": "Visit www.godigit.com for claims information.",
    },
    "HDFC ERGO General Insurance Company Limited": {
      "phone": "1800-2700-700",
      "email": "care@hdfcergo.com",
      "claims": "Visit www.hdfcergo.com for claims information.",
    },
    "ICICI Lombard General Insurance Company Limited": {
      "phone": "1800-2666",
      "email": "customersupport@icicilombard.com",
      "claims": "Visit www.icicilombard.com for claims information.",
    },
    "Iffco Tokio General Insurance Company Ltd": {
      "phone": "1800-103-5499",
      "email": "websupport@iffcotokio.co.in",
      "claims": "Visit www.iffcotokio.co.in for claims information.",
    },
    "Kotak Mahindra General Insurance Co. Ltd.": {
      "phone": "1800-266-4545",
      "email": "care@kotak.com",
      "claims": "Visit www.kotakgeneral.com for claims information.",
    },
    "Liberty General Insurance Ltd.": {
      "phone": "1800-266-5844",
      "email": "care@libertyinsurance.in",
      "claims": "Visit www.libertyinsurance.in for claims information.",
    },
    "Magma HDI General Insurance Co. Ltd.": {
      "phone": "1800-266-3202",
      "email": "info@magma-hdi.co.in",
      "claims": "Visit www.magmahdi.com for claims information.",
    },
    "National Insurance Co. Ltd.": {
      "phone": "1800-345-0330",
      "email": "customer.support@nic.co.in",
      "claims": "Visit www.nationalinsurance.nic.co.in for claims information.",
    },
    "Navi General Insurance Ltd.": {
      "phone": "1860-266-7711",
      "email": "service@navi.com",
      "claims": "Visit www.navi.com for claims information.",
    },
    "The New India Assurance Co. Ltd.": {
      "phone": "1800-209-1415",
      "email": "newindia@newindia.co.in",
      "claims": "Visit www.newindia.co.in for claims information.",
    },
    "The Oriental Insurance Company Ltd.": {
      "phone": "1800-118-485",
      "email": "customer.support@orientalinsurance.co.in",
      "claims": "Visit www.orientalinsurance.org.in for claims information.",
    },
    "Raheja QBE General Insurance Co. Ltd.": {
      "phone": "1800-102-7406",
      "email": "customer.service@rahejaqbe.com",
      "claims": "Visit www.rahejaqbe.com for claims information.",
    },
    "Reliance General Insurance Co. Ltd.": {
      "phone": "1800-3009",
      "email": "rgicl.services@relianceada.com",
      "claims": "Visit www.reliancegeneral.co.in for claims information.",
    },
    "Royal Sundaram General Insurance Co. Ltd.": {
      "phone": "1860-425-0000",
      "email": "customer.services@royalsundaram.in",
      "claims": "Visit www.royalsundaram.in for claims information.",
    },
    "SBI General Insurance Co. Ltd.": {
      "phone": "1800-102-1111",
      "email": "customer.care@sbigeneral.in",
      "claims": "Visit www.sbigeneral.in for claims information.",
    },
    "Shriram General Insurance Co. Ltd.": {
      "phone": "1800-300-30000",
      "email": "customercare@shriramgi.com",
      "claims": "Visit www.shriramgi.com for claims information.",
    },
    "Tata AIG General Insurance Co. Ltd.": {
      "phone": "1800-266-7780",
      "email": "customersupport@tataaig.com",
      "claims": "Visit www.tataaig.com for claims information.",
    },
    "United India Insurance Company Limited": {
      "phone": "1800-425-3333",
      "email": "customercare@uiic.co.in",
      "claims": "Visit www.uiic.co.in for claims information.",
    },
    "Universal Sompo General Insurance Co. Ltd.": {
      "phone": "1800-22-4030",
      "email": "contactus@universalsompo.com",
      "claims": "Visit www.universalsompo.com for claims information.",
    },
    "Zuno General Insurance": {
      "phone": "1800-123-0004",
      "email": "customercare@zunoi.com",
      "claims": "Visit www.zunoi.com for claims information.",
    },
  };

  void toggleCompany(String company, bool? isSelected) {
    setState(() {
      if (selectedMode == "Company-wise") {
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

    for (final company in companies) {
      try {
        final pdf = pw.Document();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final filename =
            '${vehicleType}_${company.replaceAll(' ', '_')}_$timestamp.pdf';

        final page = pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          build: (context) {
            final currentCompanyContact = insurerContactInfo[company] ?? {
              'phone': 'N/A',
              'email': 'N/A',
              'claims': 'Contact customer service for details.',
            };

            return pw.Stack(
              children: [
                _buildWatermark(),
                
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColors.black,
                      width: 1.0,
                    ),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildQuotationHeader(),
                      pw.SizedBox(height: 8),

                      _buildCompanyHeader(company),
                      pw.SizedBox(height: 12),

                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Expanded(
                            flex: 2,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                _buildDetailsSection(quotation, includeAgentDetails),
                                pw.SizedBox(height: 8),
                                _buildVehicleDetailsSection(quotation),
                                if (quotation.otherCoverage != null &&
                                    quotation.otherCoverage!.isNotEmpty)
                                  _buildOtherCoverageSection(quotation)!,
                              ],
                            ),
                          ),

                          pw.SizedBox(width: 12),

                          pw.Expanded(
                            flex: 3,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                _buildPremiumSummarySection(quotation),
                                pw.SizedBox(height: 8),
                                _buildTotalPremiumSection(quotation),
                              ],
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 12),
                      
                      pw.SizedBox(height: 20),
                      _buildInsurerContactSection(
                          company,
                          currentCompanyContact['phone']!,
                          currentCompanyContact['email']!,
                          currentCompanyContact['claims']!),
                      
                      pw.SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            );
          },
        );

        pdf.addPage(page);

        final pdfBytes = await pdf.save();

        if (kIsWeb) {
          final bytes = Uint8List.fromList(pdfBytes);
          final blob = html.Blob([bytes]);
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor = html.AnchorElement()
            ..href = url
            ..style.display = 'none'
            ..download = filename;
          html.document.body?.append(anchor);
          anchor.click();
          anchor.remove();
          html.Url.revokeObjectUrl(url);
        } else {
          final directory = await getTemporaryDirectory();
          final filePath = '${directory.path}/$filename';
          final file = File(filePath);
          await file.writeAsBytes(pdfBytes);
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

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Generated PDFs for ${companies.length} companies"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // New method for building the repeating watermark pattern
  pw.Widget _buildWatermark() {
    return pw.GridView(
      crossAxisCount: 3,
      childAspectRatio: 1,
      children: List.generate(
        9,
        (index) => pw.Transform.rotate(
          angle: -30 * (3.1415926535 / 180),
          child: pw.Center(
            child: pw.Text(
              "Bhartiya Bima Fintech",
              style: pw.TextStyle(
                color: PdfColors.grey200,
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  pw.Widget _buildPremiumSummarySection(QuotationData quotation) {
    final sections =
        vehicleCategorySections[quotation.insuranceResult.vehicleType] ?? {};
    final insuranceResult = quotation.insuranceResult;
    final brand = PdfColor.fromInt(0xFF303F9F);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: sections.entries.map((section) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            _buildSectionHeader(section.key,
                color: brand, textColor: PdfColors.white),
            pw.SizedBox(height: 2),
            ...section.value.map((field) {
              final value = insuranceResult.fieldData[field] ?? '-';
              String displayValue = value == '-'
                  ? '-'
                  : (double.tryParse(value.toString())?.toStringAsFixed(2) ??
                      value.toString());

              return pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 1),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(field, style: const pw.TextStyle(fontSize: 8)),
                    pw.Text(displayValue,
                        style: pw.TextStyle(
                            fontSize: 8, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              );
            }).toList(),
            pw.Divider(color: PdfColors.grey300, thickness: 1),
            pw.SizedBox(height: 4),
          ],
        );
      }).toList(),
    );
  }

  pw.Widget _buildTotalPremiumSection(QuotationData quotation) {
    final brand = PdfColor.fromInt(0xFF303F9F);
    
    final double totalPackagePremium = _safeParseDouble(quotation.insuranceResult.fieldData['Total Package Premium']);
    final double gst = _safeParseDouble(quotation.insuranceResult.fieldData['GST @ 18%']);

    double totalPolicyPremium = totalPackagePremium + gst;

    if (totalPolicyPremium == 0.0) {
      totalPolicyPremium = _safeParseDouble(quotation.insuranceResult.totalPremium);
    }

    return pw.Container(
      decoration: pw.BoxDecoration(
        color: brand,
        borderRadius: pw.BorderRadius.circular(6),
      ),
      padding: const pw.EdgeInsets.all(15),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'TOTAL POLICY PREMIUM',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
          pw.Text(
            totalPolicyPremium.toStringAsFixed(2),
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSectionHeader(String title,
      {PdfColor? color, PdfColor? textColor}) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: pw.BoxDecoration(
        color: color ?? PdfColors.grey200,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Text(
        title.toUpperCase(),
        style: pw.TextStyle(
          fontSize: 8,
          fontWeight: pw.FontWeight.bold,
          color: textColor ?? PdfColors.black,
        ),
      ),
    );
  }

  pw.Widget _buildCompanyHeader(String company, {bool isContinuation = false}) {
    final brand = PdfColor.fromInt(0xFF303F9F);
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: pw.BoxDecoration(
        color: brand,
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Text(
        isContinuation ? '$company (continued)' : company,
        style: pw.TextStyle(
          fontSize: 14,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
        ),
      ),
    );
  }
 
  pw.Widget _buildQuotationHeader() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          'Quotation Number: QT/25/${DateTime.now().millisecondsSinceEpoch}',
          style: pw.TextStyle(fontSize: 7, color: PdfColors.grey700),
        ),
        pw.Text(
          'Date: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
          style: pw.TextStyle(fontSize: 7, color: PdfColors.grey700),
        ),
      ],
    );
  }

  // Modified method to always show policy details
  pw.Widget _buildDetailsSection(
      QuotationData quotation, bool includeAgentDetails) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(width: 0.5, color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      padding: const pw.EdgeInsets.all(5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          if (includeAgentDetails) ...[
            pw.Text('PRODUCER DETAILS',
                style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
            pw.Divider(color: PdfColors.grey300, height: 2),
            _buildDetailRow('Name:', quotation.agentName),
            _buildDetailRow('Contact:', quotation.agentContact),
            _buildDetailRow('Email:', quotation.agentEmail),
            pw.SizedBox(height: 4),
          ],
          pw.Text('POLICY DETAILS',
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
          pw.Divider(color: PdfColors.grey300, height: 2),
          _buildDetailRow('Policy:', quotation.insuranceResult.vehicleType),
          _buildDetailRow(
              'Start Date:', DateFormat('dd/MM/yyyy').format(quotation.policyStartDate)),
          _buildDetailRow(
              'End Date:', DateFormat('dd/MM/yyyy').format(quotation.policyEndDate)),
        ],
      ),
    );
  }

  pw.Widget _buildDetailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1),
      child: pw.Row(
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(width: 3),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(fontSize: 7),
              textAlign: pw.TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildVehicleDetailsSection(QuotationData quotation) {
    final insuranceResult = quotation.insuranceResult;
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(width: 0.5, color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      padding: const pw.EdgeInsets.all(5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('VEHICLE DETAILS',
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
          pw.Divider(color: PdfColors.grey300, height: 2),
          _buildDetailRow('Registration No:', quotation.registrationNumber),
          _buildDetailRow('Make:', quotation.make),
          _buildDetailRow('Model:', quotation.model),
          _buildDetailRow(
              'MFG Year:', insuranceResult.fieldData['Year of Manufacture'] ?? '-'),
          _buildDetailRow('Seating Capacity:', quotation.seatingCapacity),
          _buildDetailRow(
              'CC/KW:',
              insuranceResult.fieldData['Cubic Capacity'] ??
                  insuranceResult.fieldData['Kilowatt'] ??
                  '-'),
        ],
      ),
    );
  }

  pw.Widget _buildInsurerContactSection(
      String companyName, String contactNumber, String email, String claimsInfo) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(width: 0.5, color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      padding: const pw.EdgeInsets.all(5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('INSURER CONTACT INFORMATION',
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
          pw.Divider(color: PdfColors.grey300, height: 2),
          _buildDetailRow('Company:', companyName),
          _buildDetailRow('Contact No.:', contactNumber),
          _buildDetailRow('Email:', email),
          _buildDetailRow('Claims:', claimsInfo),
        ],
      ),
    );
  }

  // UPDATED: Now uses proper formatting for each coverage
  pw.Widget? _buildOtherCoverageSection(QuotationData quotation) {
    if (quotation.otherCoverage == null || quotation.otherCoverage!.isEmpty) {
      return null;
    }
    
    // Split the comma-separated string into a list of coverages
    List<String> coverages = quotation.otherCoverage!.split(',');

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(width: 0.5, color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      padding: const pw.EdgeInsets.all(5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('OTHER COVERAGES',
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
          pw.Divider(color: PdfColors.grey300, height: 2),
          ...coverages.map((coverage) {
            final parts = coverage.trim().split(' ');
            if (parts.length > 1) {
              // Assume a format like "Coverage Value"
              return _buildDetailRow(parts.sublist(0, parts.length - 1).join(' '), parts.last);
            }
            // If just a single word, display it with no value
            return _buildDetailRow(coverage.trim(), '');
          }).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select PDF Options", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo[700],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
          border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
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