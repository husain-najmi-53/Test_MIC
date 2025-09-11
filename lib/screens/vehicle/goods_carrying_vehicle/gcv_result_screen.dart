import 'package:flutter/material.dart';
import '../../../models/result_data.dart';
import '../../vehicle_agent_info_screen.dart';

class GcvInsuranceResultScreen extends StatelessWidget {
  final InsuranceResultData resultData;

  const GcvInsuranceResultScreen({super.key, required this.resultData});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> fields = resultData.fieldData;

    final categoryFieldMapping = {
      "Goods Carrying Vehicle": {
        "Basic Details": [
          "IDV",
          "Year of Manufacture",
          "Zone",
          "Gross Vehicle Weight"
        ],
        "[A] Own Damage Premium Package": [
          "Vehicle Basic Rate",
          "Basic for Vehicle",
          "Electrical Accessories",
          "CNG/LPG Kits",
          "Basic OD Premium",
          "Geographical Extn",
          "IMT 23",
          "Anti-Theft",
          "Basic OD before Discount",
          "Discount on OD",
          "Basic OD before NCB",
          "No Claim Bonus",
          //"Net Own Damage Premium (A)",
          "Total A"
        ],
        "[B] Addon Coverage": ["Zero Depreciation", "RSA", "Total B"],
        "[C] Liability Premium": [
          "Basic Liability Premium",
          "Restricted TPPD",
          "CNG/LPG Kit (TP)",
          "Geographical Extn (TP)",
          "PA to Owner Driver",
          "LL to Paid Driver",
          "LL to Other Employee",
          "Total C"
        ],
        "[D] Total Premium": [
          "Total Package Premium (A+B+C)",
          "GST @ (18%)",
          "GST @ (12%) on Basic TP",
          "Other CESS",
          //"Final Premium"
        ],
      },
      "Electric Goods Carrying": {
        "Basic Details": [
          "IDV",
          "Year of Manufacture",
          "Zone",
          "Gross Vehicle Weight"
        ],
        "[A] Own Damage Premium Package": [
          "Vehicle Basic Rate",
          "Basic for Vehicle",
          "Electrical Accessories",
          "CNG/LPG Kits",
          "Basic OD Premium",
          "Geographical Extn",
          "IMT 23",
          "Anti-Theft",
          "Basic OD before Discount",
          "Discount on OD",
          "Basic OD before NCB",
          "No Claim Bonus",
          //"Net Own Damage Premium (A)",
          "Total A"
        ],
        "[B]Add-on Coverage": ["RSA", "Zero Depreciation", "Total B"],
        "[C] Liability Premium": [
          "Basic Liability Premium",
          "Restricted TPPD",
          "CNG/LPG Kit (TP)",
          "Geographical Extn (TP)",
          "PA to Owner Driver",
          "LL to Paid Driver",
          "LL to Other Employee",
          "Total C"
        ],
        "[D] Total Premium": [
          "Total Package Premium (A+B+C)",
          "GST @ (18%)",
          "GST @ (12%) on Basic TP",
          "Other CESS",
         // "Final Premium"
        ]
      },
      "Three-Wheeler Goods Carrying": {
        "Basic Details": [
          "IDV",
          "Year of Manufacture",
          "Zone",
        ],
        "[A] Own Damage Premium Package": [
          "Vehicle Basic Rate",
          "Basic for Vehicle",
          "CNG/LPG kits",
          "Basic OD Premium",
          "IMT 23",
          "Basic OD before Discount",
          "Discount on OD",
          "Basic OD before NCB",
          "No Claim Bonus",
          //"Net Own Damage Premium",
          "Total A"
        ],
        "[B] Liability Premium": [
          "Basic Liability Premium",
          "Restricted TPPD",
          "CNG/LPG Kit (TP)",
          "PA to Owner Driver",
          "LL to Paid Driver",
          "Total B"
        ],
        "[C] Total Premium": [
          "Total Package Premium (A+B)",
          "GST @ (18%)",
          "GST @ (12%) on Basic TP",
          "Other CESS",
          //"Final Premium"
        ]
      },
      "E-Three Wheeler Goods Carrying": {
        "Basic Details": [
          "IDV",
          "Year of Manufacture",
          "Zone",
        ],
        "[A] Own Damage Premium Package": [
          "Vehicle Basic rate",
          "Basic for Vehicle",
          "Electrical Accessories",
          "IMT 23",
          "Basic OD before Discount",
          "Discount on OD",
          "Loading Discount Premium",
          "Basic OD before NCB",
          "No Claim Bonus",
         // "Net Own Damage Premium",
          "Total A"
        ],
        "[B] Addon Coverage": [
          "Value Added Service",
          "Total B",
        ],
        "[C] Liability Premium": [
          "Basic Liability Premium",
          "Restricted TPPD",
          "PA to Owner Driver",
          "LL to Paid Driver",
          "Total C"
        ],
        "[D] Total Premium": [
          "Total package Premium (A+B+C)",
          "GST @ (18%)",
          "Other CESS",
         // "Final Premium"
        ]
      },
    };

    final vehicleType = resultData.vehicleType;
    final sections = categoryFieldMapping[vehicleType] ??
        categoryFieldMapping["Goods carrying Vehicle"]!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 4,
        title: Text(
          '$vehicleType Premium',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            //fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...sections.entries.map((entry) {
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle(entry.key),
                      const Divider(height: 1, thickness: 1),
                      const SizedBox(height: 8),
                      _buildFieldsSection(fields, entry.value),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(
              height: 16,
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.indigo.shade200,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      "Final Premium",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.indigo.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "₹${resultData.totalPremium.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VehicleAgentFormScreen(
                  insuranceResult: resultData,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          child: const Text(
            "Next",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.indigo.shade800,
              fontSize: 16,
            ),
          ),
        ));
  }

  Widget _buildFieldsSection(Map<String, String> data, List<String> keys) {
    return Column(
      children: keys.map((key) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  key,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade800,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  data[key.trim()] ?? "0.00",
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
