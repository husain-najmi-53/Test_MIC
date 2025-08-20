import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OdclaimScreen extends StatefulWidget {
  const OdclaimScreen({Key? key}) : super(key: key);

  @override
  State<OdclaimScreen> createState() => _OdclaimScreenState();
}

class _OdclaimScreenState extends State<OdclaimScreen> {
  TextEditingController idvController = TextEditingController();
  TextEditingController ccOrBussPassengerController = TextEditingController();
  TextEditingController repairEstimateController = TextEditingController();
  TextEditingController metalValueController = TextEditingController();
  TextEditingController otherPartsValueController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  String? selectedVehicleType;
  String? selectedVehicleAge;
  String? selectedClaimType;
  double odCompensation = 0;

  List<String> vehicleTypeOption = [
    "Two Wheeler",
    "Four Wheeler",
    "Good Carying Vehicle",
    "Miscellaneous"
  ];
  List<String> vehicleAgeOption = ["1", "2", "3", "4", "5", "Above 5"];
  List<String> claimTypeOption = [
    "Lost",
    "Damage",
  ];

  bool increaseHeight = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('OD Claim Calculator',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: height + 70,
                  child: Stack(
                    children: [
                      Container(
                        height: height * 0.12,
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade100,
                        ),
                      ),
                      Positioned(
                        top: 15,
                        left: 20,
                        child: Container(
                          width: width * 0.9,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 12),
                            child: buildForm(height, width),
                          ),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ FIXED: Expanded moved outside Form (valid placement)
  Widget buildForm(double height, double width) {
    return Form(
      key: _key,
      child: Column(
        children: [
            _textFields(
              height: height,
              fieldName: 'Insured Declared Value',
              hint: 'Enter Amount (in INR)',
              controller: idvController,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  increaseHeight = true;
                  //print(increaseHeight);
                  return "Please enter value";
                } else {
                  return null;
                }
              },
            ),
            _Fields(
              height: height,
              fieldName: "Vehicle Type",
              fieldList: vehicleTypeOption,
              onChanged: (val) {
                setState(() {
                  selectedVehicleType = val;
                });
              },
              fieldValue: selectedVehicleType,
            ),
            _textFields(
              height: height,
              fieldName: "Vehicle CC/GVW ",
              hint: 'Enter Value',
              controller: ccOrBussPassengerController,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  increaseHeight = true;
                  print(increaseHeight);
                  return "Please enter value";
                } else {
                  return null;
                }
              },
            ),
            _Fields(
              height: height,
              fieldName: "Age of the Vehicle",
              fieldList: vehicleAgeOption,
              onChanged: (val) {
                setState(() {
                  selectedVehicleAge = val;
                });
              },
              fieldValue: selectedVehicleAge,
            ),
            _Fields(
              height: height,
              fieldName: "Claim Type",
              fieldList: claimTypeOption,
              onChanged: (val) {
                setState(() {
                  selectedClaimType = val;
                });
              },
              fieldValue: selectedClaimType,
            ),
            _textFields(
              height: height,
              fieldName: "Repair Estimate",
              hint: 'Enter Value',
              controller: repairEstimateController,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "Please enter value";
                } else {
                  return null;
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _partsTextContainer(
                    height: height,
                    width: width,
                    fieldName: "Metal Parts",
                    hint: 'Enter Value',
                    controller: metalValueController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Please enter value";
                      } else {
                        return null;
                      }
                    },
                  ),
                  _partsTextContainer(
                    height: height,
                    width: width,
                    fieldName: "Other Parts",
                    hint: 'Enter Value',
                    controller: otherPartsValueController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Please enter value";
                      } else {
                        return null;
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: ElevatedButton(
                onPressed: () {
                  if (_key.currentState!.validate() &&
                      selectedVehicleType != null &&
                      selectedVehicleAge != null &&
                      selectedClaimType != null) {
                    Map<String, double> parts = {
                      'metal': double.parse(metalValueController.text.trim()),
                      'other parts':
                          double.parse(otherPartsValueController.text.trim())
                    };
                    setState(() {
                      odCompensation = calculateODClaimIRDA(
                        idv: double.parse(idvController.text.trim()),
                        vehicleType: selectedVehicleType!,
                        vehicleCc:
                            int.parse(ccOrBussPassengerController.text.trim()),
                        vehicleAgeYears: selectedVehicleAge == 'Above 5'
                            ? 6
                            : int.parse(selectedVehicleAge!),
                        claimType: selectedVehicleType!,
                        repairEstimate:
                            double.parse(repairEstimateController.text.trim()),
                        parts: parts,
                      );
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Please Select the required Field")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.indigo.shade700,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  "Calculate",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.01),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 9),
              child: Text(
                "Compensation Availble",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
              ),
            ),
            Container(
              height: 40,
              width: 180,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border.all(color: Colors.indigo.shade700),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(child: Text("Rs $odCompensation")),
            ),
            SizedBox(height: height * 0.01),
          ],
        ),
      );
  }

  Widget _partsTextContainer({
    required double height,
    required double width,
    required String fieldName,
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
  }) {
    return Column(
      children: [
        Text(
          fieldName,
          style: GoogleFonts.poppins(
            color: Colors.indigo.shade700,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: width * 0.35,
          child: TextFormField(
            controller: controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
            style: GoogleFonts.poppins(fontSize: 14),
            validator: validator,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.all(10),
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: Colors.indigo.shade700),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: Colors.indigo.shade700),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: Colors.indigo.shade700),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _Fields({
    required double height,
    required String fieldName,
    required List<String> fieldList,
    required String? fieldValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fieldName,
            style: GoogleFonts.poppins(
              color: Colors.indigo.shade700,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border.all(color: Colors.indigo.shade700),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: fieldValue,
              underline: const SizedBox(),
              isExpanded: true,
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(12),
              onChanged: onChanged,
              hint: Text(
                'Select $fieldName',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              items: fieldList
                  .map((element) => DropdownMenuItem(
                        value: element,
                        child: Text(element),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textFields({
    required double height,
    required String fieldName,
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fieldName,
            style: GoogleFonts.poppins(
              color: Colors.indigo.shade700,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
            style: GoogleFonts.poppins(fontSize: 14),
            validator: validator,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.all(10),
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: Colors.indigo.shade700),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: Colors.indigo.shade700),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: Colors.indigo.shade700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///This is Method is used
  double calculateODClaimIRDA({
    required double idv, // Insured Declared Value
    required String vehicleType, // "two", "four", "goods", "misc"
    required int vehicleCc,
    required int vehicleAgeYears,
    required String claimType, // "loss" or "damage"
    required double repairEstimate, // Workshop estimate for damage
    required Map<String, double>
        parts, // {"metal": %, "rubber": %, "plastic": %, "glass": %, "fiberglass": %}
  }) {
    // --- Step 1: Compulsory Deductible ---
    double compulsoryDeductible;
    if (vehicleType == "Two Wheeler") {
      compulsoryDeductible = 100;
    } else if (vehicleType == "Four Wheeler") {
      compulsoryDeductible = (vehicleCc < 1500) ? 1000 : 2000;
    } else if (vehicleType == "Good Carying Vehicle" ||
        vehicleType == "Miscellaneous") {
      compulsoryDeductible = 2000;
    } else {
      compulsoryDeductible = 1000; // fallback
    }

    // --- Step 2: IDV depreciation (for Total Loss / Theft) ---
    double getIDVDepPercent(int ageYears) {
      if (ageYears < 1) return (ageYears < 0.5) ? 0.05 : 0.15;
      if (ageYears < 2) return 0.20;
      if (ageYears < 3) return 0.30;
      if (ageYears < 4) return 0.40;
      if (ageYears < 5) return 0.50;
      return 0.50; // >5 years → mutual, assume 50% max
    }

    // --- Step 3: Metal parts depreciation as per IRDA ---
    double getMetalDepPercent(int ageYears) {
      if (ageYears < 0.5) return 0.0;
      if (ageYears < 1) return 0.05;
      if (ageYears < 2) return 0.10;
      if (ageYears < 3) return 0.15;
      if (ageYears < 4) return 0.25;
      if (ageYears < 5) return 0.35;
      if (ageYears <= 10) return 0.40;
      return 0.50;
    }

    // --- Step 4: Claim calculation ---
    if (claimType.toLowerCase() == "Lost") {
      // Total loss = IDV after depreciation - deductible
      double depreciatedIDV = idv * (1 - getIDVDepPercent(vehicleAgeYears));
      return (depreciatedIDV - compulsoryDeductible).clamp(0, idv);
    } else {
      // Damage = Apply IRDA depreciation part-wise
      double claimable = 0.0;

      /* parts.forEach((part, cost) {
        double dep = 0.0;
        if (part == "metal") dep = getMetalDepPercent(vehicleAgeYears);
        else if (part == "rubber" || part == "plastic" || part == "nylon" || part == "battery" || part == "tyre") dep = 0.50;
        else if (part == "fiberglass") dep = 0.30;
        else if (part == "glass") dep = 0.0;

        claimable += cost * (1 - dep);
      });*/

      parts.forEach((part, cost) {
        double dep = 0.0;
        if (part == "metal") {
          dep = getMetalDepPercent(vehicleAgeYears);
        } else {
          dep = 0.50;
        }

        claimable += cost * (1 - dep);
      });

      // Deduct compulsory deductible
      double finalClaim = claimable - compulsoryDeductible;
      return finalClaim.clamp(0, idv);
    }
  }

  ///This Method is not Used Right Now
  double calculateSimplifiedODClaim({
    required double idv,
    required String vehicleType, // "two", "four", "goods", "misc"
    required int vehicleCc,
    required int vehicleAgeYears,
    required String claimType, // "loss" or "damage"
  }) {
    // --- Step 1: Find compulsory deductible ---
    double compulsoryDeductible;
    if (vehicleType == "two") {
      compulsoryDeductible = 100;
    } else if (vehicleType == "four") {
      compulsoryDeductible = (vehicleCc < 1500) ? 1000 : 2000;
    } else if (vehicleType == "goods" || vehicleType == "misc") {
      compulsoryDeductible = 2000;
    } else {
      compulsoryDeductible = 1000; // fallback
    }

    // --- Step 2: Calculate depreciation based on vehicle age ---
    double depreciationPercent;
    if (vehicleAgeYears < 1) {
      depreciationPercent = 0.15; // assume > 6 months but < 1 year
    } else if (vehicleAgeYears < 2) {
      depreciationPercent = 0.20;
    } else if (vehicleAgeYears < 3) {
      depreciationPercent = 0.30;
    } else if (vehicleAgeYears < 4) {
      depreciationPercent = 0.40;
    } else if (vehicleAgeYears < 5) {
      depreciationPercent = 0.50;
    } else {
      depreciationPercent = 0.60; // > 5 years (approx)
    }

    // --- Step 3: Apply claim type logic ---
    if (claimType.toLowerCase() == "loss") {
      // Total loss = depreciated IDV - deductible
      double depreciatedIDV = idv * (1 - depreciationPercent);
      return (depreciatedIDV - compulsoryDeductible).clamp(0, idv);
    } else {
      // Damage case = Assume 30% of IDV as repair, then apply age depreciation
      double estimatedRepair = idv * 0.30;
      double repairAfterDep = estimatedRepair * (1 - depreciationPercent);
      double claim = repairAfterDep - compulsoryDeductible;
      return claim.clamp(0, idv);
    }
  }
}
