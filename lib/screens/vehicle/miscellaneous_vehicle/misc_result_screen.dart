import 'package:flutter/material.dart';
import '../../../models/result_data.dart';
import '../../vehicle_agent_info_screen.dart';

class MiscInsuranceResultScreen extends StatelessWidget {
  final InsuranceResultData resultData;

  const MiscInsuranceResultScreen({super.key, required this.resultData});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> fields = resultData.fieldData;

    final categoryFieldMapping = {
      "Ambulance": {
        "Basic Details": [
          "IDV",
          "Year of Manufacture",
          "Zone",
        ],
        "[A] Own Damage Premium Package": [
          "Vehicle Basic Rate",
          "Basic for Vehicle",
          "CNG/LPG kit (Externally Fitted)",
          "Basic OD Premium",
          "IMT 23",
          "Basic OD Premium Before discount",
          "Discount on OD Premium",
          "Loading on OD Premium",
          "Basic OD Before NCB",
          "No Claim Bonus",
          "Net Own Damage Premium [Total A]"
        ],
        "[B] Liability Premium": [
          "Basic Liability Premium (TP)",
          "Restricted TPPD",
          "CNG/LPG Kit",
          "PA to Owner Driver",
          "LL to Paid Driver",
          "LL to Employee Other than Paid Driver",
          "LL to Passenger",
          "Total B"
        ],
        "[C] Total Premium": [
          "Total Package Premium[A+B]",
          "GST @ 18%",
          "Other CESS"
        ],
      },
      "Trailer": {
        "Basic Details": [
          "IDV",
          "No. of Trailers (Attached)",
          "Trailer Towed By",
          "Year of Manufacture",
          "Zone",
        ],
        "[A] Own Damage Premium Package": [
          "Basic for Vehicle",
          "IMT 23",
          "CNG/LPG kit (Externally Fitted)",
          "Basic OD Premium Before discount",
          "Discount on OD Premium",
          "Loading on OD Premium",
          "Basic OD Before NCB",
          "No Claim Bonus",
          "Net Own Damage Premium",
          "Total A"
        ],
        "[B] Liability Premium": [
          "Trailer Liability Premium (TP)",
          "Restricted TPPD",
          "CNG/LPG Kit",
          "PA to Owner Driver",
          "LL to Paid Driver",
          "LL to Employee Other than Paid Driver",
          // "LL to Passenger",
          "Total B"
        ],
        "[C] Total Premium": [
          "Total Package Premium[A+B]",
          "GST @ 18%",
          "Other CESS"
        ],
      },
      "Hearse": {
        "Basic Details": [
          "IDV",
          "Year of Manufacture",
          "Zone",
        ],
        "[A] Own Damage Premium Package": [
          "Vehicle Basic Rate",
          "Basic for Vehicle",
          "CNG/LPG kit (Externally Fitted)",
          "Basic OD Premium",
          "IMT23",
          "Basic OD Before Discount",
          "Discount on OD Premium",
          "Loading on OD Premium",
          "Basic OD Before NCB",
          "No Claim Bonus",
          "Net Own Damage Premium [A]"
        ],
        "[B] Liability Premium": [
          "Basic Liability Premium (TP)",
          "Restricted TPPD",
          "CNG/LPG Kit",
          "PA to Owner Driver",
          "LL to Paid Driver",
          "LL to Employee Other than Paid Driver",
          "LL to Passenger",
          "Total B"
        ],
        "[C] Total Premium": [
          "Total Package Premium[A+B]",
          "GST @ 18%",
          "Other CESS"
        ],
      },
      "Pedestrian Controlled Agricultural Tractors": {
        "Basic Details": ["IDV", "Year of Manufacture", "Zone"],
        "[A] Own Damage Premium Package": [
          "Vehicle Basic Rate",
          "Basic for Vehicle",
          "CNG/LPG kit (Externally Fitted)",
          "Basic OD Premium",
          "IMT 23",
          "Basic OD Before Discount",
          "Discount on OD Premium",
          "Loading on OD Premium",
          "Basic OD Before NCB",
          "No Claim Bonus",
          "Net Own Damage Premium",
          // "Total A"
        ],
        "[B] Liability Premium": [
          "Basic Liability Premium (TP)",
          "Restricted TPPD",
          "CNG/LPG Kit",
          "PA to Owner Driver",
          "LL to Paid Driver",
          "LL to Employee/Other",
          "LL to Passenger",
          "Total B"
        ],
        "[C] Total Premium": [
          "Total Package Premium[A+B]",
          "GST @ 18%",
          "Other CESS"
        ]
      },
      "Other MISC Vehicle": {
        "Basic Details": ["IDV", "Year of Manufacture", "Zone", "Vehicle Type"],
        "[A] Own Damage Premium Package": [
          "Vehicle Basic Rate",
          "Basic for Vehicle",
          "Discount on OD Premium",
          "Basic OD Premium After discount",
          "Geographical Ext",
          "Overturning For Cranes",
          "IMT 23",
          "No Claim Bonus",
          "Net Own Damage Premium",
        ],
        "[B] Liability Premium": [
          "Liability Premium (TP)",
          "Geographical Ext",
          "PA to Owner Driver",
          "LL to Paid Driver",
          "LL to Employee Other than Paid Driver",
          "Total B"
        ],
        "[C] Total Premium": [
          "Total Package Premium[A+B]",
          "GST @ 18%",
          "Other CESS"
        ]
      },
      "Trailer And Other Miscellaneous": {
        "Basic Details": [
          "IDV",
          "Trailer IDV (Attached trailer)",
          "No of Trailers (Attached)",
          "Trailer Towed By",
          "Year of Manufacture",
          "Zone",
        ],
        "[A] Own Damage Premium Package": [
          "Vehicle Basic Rate",
          "Basic for Vehicle",
          "Trailer OD",
          "Basic OD Premium",
          "Overturning for Cranes",
          "IMT 23",
          "CNG/LPG kit (Externally Fitted)",
          "Basic OD Premium before discount",
          "Discount on OD Premium",
          "Loading on OD Premium",
          "Basic OD Before NCB",
          "No Claim Bonus",
          "Net Own Damage Premium",
          "Total A"
        ],
        "[B] Liability Premium": [
          "Basic Liability Premium (TP)",
          "Trailer Liability Premium (TP)",
          "Restricted TPPD",
          "CNG/LPG Kit",
          "PA to Owner Driver",
          "LL to Paid Driver",
          "LL to Employee Other than Paid Driver",
          "Total Liability Premium (B)"
        ]
      }
    };

    final vehicleType = resultData.vehicleType;
    final sections =
        categoryFieldMapping[vehicleType] ?? categoryFieldMapping["Ambulance"]!;

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
