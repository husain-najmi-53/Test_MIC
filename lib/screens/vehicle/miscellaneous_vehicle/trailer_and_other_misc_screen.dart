import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motor_insurance_app/models/result_data.dart';
import 'package:motor_insurance_app/screens/vehicle/miscellaneous_vehicle/misc_result_screen.dart';

class TrailerAndOtherFormScreen extends StatefulWidget {
  const TrailerAndOtherFormScreen({super.key});

  @override
  State<TrailerAndOtherFormScreen> createState() =>
      _TrailerAndOtherFormScreenState();
}

class _TrailerAndOtherFormScreenState extends State<TrailerAndOtherFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> _controllers = {
    'idv': TextEditingController(),
    'depreciation': TextEditingController(),
    'currentIdv': TextEditingController(),
    'idvAttached': TextEditingController(),
    'depreciation (Attached trailer)': TextEditingController(),
    'currentIdv (Attached trailer)': TextEditingController(),
    'No_of_trailers(Attached)': TextEditingController(),
    'Year_of_manufacture': TextEditingController(),
    'Discount_on_OD_premium(%)': TextEditingController(),
    'Loading_on_discount_premium(%)': TextEditingController(),
    'CNG/LPG_kit(Externally_fitted)': TextEditingController(),
    'll2Passenger': TextEditingController(), // <-- add this
    'PA_to_owner_driver': TextEditingController(),
    'Other_CESS(%)': TextEditingController(),
  };

  String? _selectedTrailerTowedBy;
  String? _selectedDepreciation;
  String? _selectedDepreciationAttached;
  String? _selectedOverturningForCranes;
  String? _selectedAge;
  String? _selectedZone;
  String? _selectedCNG;
  String? _selectedImt23;
  String? _selectedNcb;
  String? _selectedLlPaidDriver;
  String? _selectedLlEmployeeOther;
  String? _selectedRestrictedTppd;

  final List<String> _depreciationOptions = [
    '0%',
    '5%',
    '10%',
    '15%',
    '20%',
    '25%',
    '30%',
  ];
  final List<String> _depreciationAttachedOptions = [
    '0%',
    '5%',
    '10%',
    '15%',
    '20%',
    '25%',
    '30%',
  ];
  final List<String> _trailerTowedByOptions = [
    'Other Vehicle',
    'Agriculture Tractors upto 6 HP'
  ];
  final List<String> _overturningForCranesOptions = ['Yes', 'No'];
  final List<String> _ageOptions = [
    'Upto 5 Years',
    '6-7 Years',
    'Above 7 Years'
  ];
  final List<String> _zoneOptions = ['A', 'B', 'C'];
  final List<String> _cngOptions = ['Yes', 'No'];
  final List<String> _imt23Options = ['Yes', 'No'];
  final List<String> _ncbOptions = ['0', '20', '25', '35', '45', '50'];
  final List<String> _llPaidDriverOptions = ['0', '50'];
  final List<String> _llEmployeeOtherOptions = [
    '0',
    '50',
    '100',
    '100',
    '150',
    '200',
    '250',
    '300',
    '350'
  ];
  final List<String> _restrictedTppdOptions = ['Yes', 'No'];

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildReadOnlyField(String key, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
            width: 180,
            child: Text(label, style: const TextStyle(fontSize: 16)),
          ),
          Expanded(
            child: TextFormField(
              controller: _controllers[key],
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateCurrentIdv() {
    double idv = double.tryParse(_controllers['idv']!.text) ?? 0.0;
    double depreciation = 0.0;

    if (_selectedDepreciation != null) {
      depreciation =
          double.tryParse(_selectedDepreciation!.replaceAll('%', '')) ?? 0.0;
    }

    double currentIdv = idv - ((idv * depreciation) / 100);
    _controllers['currentIdv']!.text = currentIdv.toStringAsFixed(2);
  }

  void _updateCurrentAttachedIdv() {
    double idvAttached =
        double.tryParse(_controllers['idvAttached']!.text) ?? 0.0;
    double depreciation = 0.0;

    if (_selectedDepreciationAttached != null) {
      depreciation =
          double.tryParse(_selectedDepreciationAttached!.replaceAll('%', '')) ??
              0.0;
    }

    double currentIdvAttached =
        idvAttached - ((idvAttached * depreciation) / 100);
    _controllers['currentIdv (Attached trailer)']!.text =
        currentIdvAttached.toStringAsFixed(2);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Fetch form inputs
      // double idv = double.tryParse(_controllers['idv']!.text) ?? 0.0;
      double currentIdv =
          double.tryParse(_controllers['currentIdv']!.text) ?? 0.0;
      // double trailerIdv = double.tryParse(_controllers['idv (Attached trailer)']!.text) ?? 0.0;
      double currentIdvAttached = double.tryParse(
              _controllers['currentIdv (Attached trailer)']!.text) ??
          0.0;
      // double DepreciationAttached = double.tryParse(_controllers['Depreciation (Attached trailer)']!.text) ?? 0.0;
      double ageOfVehicle = double.tryParse(_selectedAge ?? '0') ?? 0.0;
      String yearOfManufacture = _controllers['Year_of_manufacture']!.text;
      String zone = _selectedZone ?? "A";
      double imt23 = _selectedImt23 == 'Yes' ? 15.0 : 0.0; // IMT 23 percentage
      String selectedTrailerTowedBy =
          _selectedTrailerTowedBy ?? 'Other Vehicle';
      double overturningForCranes = _selectedOverturningForCranes == 'Yes'
          ? 5.0
          : 0.0; // Overturning for Cranes percentage change as per client given IRDA Rates
      double discountRate =
          double.tryParse(_controllers['Discount_on_OD_premium(%)']!.text) ??
              0.0;
      double paOwnerDriver =
          double.tryParse(_controllers['PA_to_owner_driver']!.text) ?? 0.0;
      double otherCess =
          double.tryParse(_controllers['Other_CESS(%)']!.text) ?? 0.0;
      double ll2Passenger =
          double.tryParse(_controllers['ll2Passenger']!.text) ?? 0.0;
      double loadingRate = double.tryParse(
              _controllers['Loading_on_discount_premium(%)']!.text) ??
          0.0;
      double llPaidDriver =
          double.tryParse(_selectedLlPaidDriver ?? "0") ?? 0.0;
      double llLEmployeeOther =
          double.tryParse(_selectedLlEmployeeOther ?? "0") ?? 0.0;
      double llToPaidDriver =
          double.tryParse(_selectedLlPaidDriver ?? "0") ?? 0.0;
      double restrictedTPPDValue =
          (_selectedRestrictedTppd == "Yes") ? 100 : 0.0;
      double noOfTrailersAttached =
          double.tryParse(_controllers['No_of_trailers(Attached)']!.text) ??
              0.0;
      double ncbRate = double.tryParse(_selectedNcb ?? "0") ?? 0.0;
      double cngLpgKitValue = double.tryParse(
              _controllers['CNG/LPG_kit(Externally_fitted)']!.text) ??
          0.0;

      // Get base rate from function
      double vehicleBasicRate =
          _getOdRate(zone, selectedTrailerTowedBy, ageOfVehicle);

      // OD Calculations
      double trailerODRate = 1.0; //change this when confirmed
      double cngLpgRate = 4.0; // change this when confirmed
      double basicForVehicle =
          currentIdv * vehicleBasicRate / 100; //Basic for Vehicle
      double trailerOD = currentIdv * trailerODRate / 100; //Trailer OD
      double basicODPremium =
          basicForVehicle + trailerOD; //Basic OD Premium (before crane/imt/cng)
      double overturningCranePremium =
          basicODPremium * overturningForCranes / 100; //Overturning for Cranes
      double imt23Loading = basicODPremium * imt23 / 100; //IMT 23
      double cngLpgPremium =
          cngLpgKitValue * cngLpgRate / 100; // CNG/LPG kit (Externally Fitted)
      double basicODBeforePremium = basicODPremium +
          overturningCranePremium +
          imt23Loading +
          cngLpgPremium; // Basic OD Before Discount
      double discountOnODPremium =
          basicODBeforePremium * discountRate / 100; //Discount on OD Premium
      double loadingOnODPremium =
          basicODBeforePremium * loadingRate / 100; //Loading on OD Premium
      double basicODBeforeNCB = basicODBeforePremium -
          discountOnODPremium +
          loadingOnODPremium; //Basic OD Before NCB
      double ncbAmount = basicODBeforeNCB * ncbRate / 100; //No Claim Bonus
      double netOwnDamage =
          basicODBeforeNCB - ncbAmount; // Net Own Damage Premium
      double totalA = netOwnDamage;

      // TP Section
      double trailerTpRate = 1047; //change this when confirmed
      double trailerLiabilityTP =
          noOfTrailersAttached * trailerTpRate; //Trailer Liability Premium (TP)
      double cngLpgKitTP = _selectedCNG == "Yes" ? 4 : 0.0;

      double liabilityPremiumTP = _getTpRate(selectedTrailerTowedBy);
      double totalB = liabilityPremiumTP +
          trailerLiabilityTP +
          cngLpgKitTP +
          paOwnerDriver +
          llPaidDriver +
          restrictedTPPDValue +
          llLEmployeeOther +
          ll2Passenger;

      // Total Premium (C)
      double totalAB = totalA + totalB;
      double gst = totalAB * 0.18;
      otherCess = (otherCess * totalAB) / 100;
      double finalPremium = totalAB + gst + otherCess;

      // Result Map
      Map<String, String> resultMap = {
        // Basic Details
        "IDV": currentIdv.toStringAsFixed(2),
        "Trailer IDV (Attached trailer)":
            (currentIdvAttached * 0.1).toStringAsFixed(2),
        "No of Trailers (Attached)": noOfTrailersAttached.toStringAsFixed(2),
        "Trailer Towed By": _selectedTrailerTowedBy ?? 'Other Vehicle',
        "Year of Manufacture": yearOfManufacture.toString(),
        "Zone": zone,

        // A - Own Damage Premium Package
        "Vehicle Basic Rate": vehicleBasicRate.toStringAsFixed(3),
        "Basic for Vehicle": basicForVehicle.toStringAsFixed(2),
        "Trailer OD": trailerOD.toStringAsFixed(2),
        "Basic OD Premium": basicODPremium.toStringAsFixed(2),
        "Overturning for Cranes": overturningCranePremium.toStringAsFixed(2),
        "IMT 23": imt23Loading.toStringAsFixed(2),
        "CNG/LPG kit (Externally Fitted)": cngLpgKitValue.toStringAsFixed(2),
        "Basic OD Premium before discount": basicODPremium.toStringAsFixed(2),
        "Discount on OD Premium": discountOnODPremium.toStringAsFixed(2),
        "Loading on OD Premium": loadingOnODPremium.toStringAsFixed(2),
        "Basic OD Before NCB": basicODBeforeNCB.toStringAsFixed(2),
        "No Claim Bonus": ncbAmount.toStringAsFixed(2),
        "Net Own Damage Premium": totalA.toStringAsFixed(2),
        "Total A": totalA.toStringAsFixed(2),

        // B - Liability Premium
        "Basic Liability Premium (TP)": liabilityPremiumTP.toStringAsFixed(2),
        "Trailer Liability Premium (TP)": trailerLiabilityTP.toStringAsFixed(2),
        "Restricted TPPD": restrictedTPPDValue.toStringAsFixed(2),
        "CNG/LPG Kit": cngLpgKitTP.toStringAsFixed(2),
        "PA to Owner Driver": paOwnerDriver.toStringAsFixed(2),
        "LL to Paid Driver": llToPaidDriver.toStringAsFixed(2),
        "LL to Employee Other than Paid Driver":
            llLEmployeeOther.toStringAsFixed(2),
        "Total Liability Premium (B)": totalB.toStringAsFixed(2),

        // C - Total Premium
        "Total Package Premium[A+B]": totalAB.toStringAsFixed(2),
        "GST @ 18%": gst.toStringAsFixed(2),
        "Other CESS": otherCess.toStringAsFixed(2),

        // Final Premium
        "Final Premium": finalPremium.toStringAsFixed(2),
      };

      // Pass data to result screen
      InsuranceResultData resultData = InsuranceResultData(
        vehicleType: "Trailer And Other Miscellaneous",
        fieldData: resultMap,
        totalPremium: finalPremium,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MiscInsuranceResultScreen(resultData: resultData),
        ),
      );
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    for (var controller in _controllers.values) {
      controller.clear();
    }
    setState(() {
      _selectedAge = null;
      _selectedZone = null;
      _selectedNcb = null;
      _selectedImt23 = null;
      _selectedLlPaidDriver = null;
      _selectedRestrictedTppd = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade700,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon(Icons.people, color: Colors.white),
              // SizedBox(width: 8),
              Text(
                'Trailer and Other Miscellaneous',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _resetForm,
            tooltip: 'Reset Form',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField('idv', 'IDV', 'IDV'),
                _buildDropdownField(
                  'Depreciation (%)',
                  _depreciationOptions,
                  _selectedDepreciation,
                  (val) {
                    setState(() {
                      _selectedDepreciation = val;
                      _updateCurrentIdv(); // <-- Add this
                    });
                  },
                ),
                _buildReadOnlyField(
                    'currentIdv', 'Current IDV (₹)'), // Read-only field
                _buildTextField('idvAttached', 'IDV (Attached Trailer)',
                    'IDV (Attached Trailer)'),
                _buildDropdownField(
                  'Depreciation (Attached Trailer)',
                  _depreciationAttachedOptions,
                  _selectedDepreciationAttached,
                  (val) {
                    setState(() {
                      _selectedDepreciationAttached = val;
                      _updateCurrentAttachedIdv(); // <-- Add this
                    });
                  },
                ),
                _buildReadOnlyField('currentIdv (Attached Trailer)',
                    'Current IDV (Attached) (₹)'), // Read-only field
                _buildDropdownField('Age of Vehicle', _ageOptions, _selectedAge,
                    (val) => setState(() => _selectedAge = val)),
                _buildTextField('Year_of_manufacture', 'Year of Manufacture',
                    'Year of Manufacture'),
                _buildDropdownField('Zone', _zoneOptions, _selectedZone,
                    (val) => setState(() => _selectedZone = val)),
                _buildTextField('No_of_trailers(Attached)',
                    'No. of Trailers(Attached)', 'No of Trailers(Attached)'),
                _buildDropdownField(
                    'Trailer Towed by',
                    _trailerTowedByOptions,
                    _selectedTrailerTowedBy,
                    (val) => setState(() => _selectedTrailerTowedBy = val)),
                _buildDropdownField(
                    'Overturning For Cranes',
                    _overturningForCranesOptions,
                    _selectedOverturningForCranes,
                    (val) =>
                        setState(() => _selectedOverturningForCranes = val)),
                _buildTextField('Discount_on_OD_premium(%)',
                    'Discount on OD Premium(%)', 'Discount on OD Premium(%)'),
                _buildTextField(
                    'Loading_on_discount_premium(%)',
                    'Loading on Discount Premium(%)',
                    'Loading on Discount Premium(%)'),
                _buildDropdownField('CNG/LPG kits', _cngOptions, _selectedCNG,
                    (val) => setState(() => _selectedCNG = val)),
                _buildTextField(
                    'CNG/LPG_kit(Externally_fitted)',
                    'CNG/LPG kit(Externally fitted)',
                    'CNG/LPG kit(Externally fitted)'),
                _buildDropdownField('IMT 23', _imt23Options, _selectedImt23,
                    (val) => setState(() => _selectedImt23 = val)),
                _buildDropdownField('No Claim Bonus(%)', _ncbOptions,
                    _selectedNcb, (val) => setState(() => _selectedNcb = val)),
                _buildTextField('PA_to_owner_driver', 'PA to owner driver',
                    'PA to owner driver'),
                _buildDropdownField(
                    'LL to Paid Driver',
                    _llPaidDriverOptions,
                    _selectedLlPaidDriver,
                    (val) => setState(() => _selectedLlPaidDriver = val)),
                _buildDropdownField(
                    'LL to Employee (Other Than Paid Driver)',
                    _llEmployeeOtherOptions,
                    _selectedLlEmployeeOther,
                    (val) => setState(() => _selectedLlEmployeeOther = val)),
                _buildDropdownField(
                    'Restrcited TPPD',
                    _restrictedTppdOptions,
                    _selectedRestrictedTppd,
                    (val) => setState(() => _selectedRestrictedTppd = val)),
                _buildTextField(
                    'Other_CESS(%)', 'Other CESS(%)', 'Other CESS(%)'),
                // const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo.shade700,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Calculate',
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ),
    );
  }

  Widget _buildTextField(String key, String label, String placeholder) {
    // Optional dropdown fields
    const optionalFields = [
      'Other_CESS(%)',
      'PA_to_owner_driver',
      'CNG/LPG_kit(Externally_fitted)',
      'Loading_on_discount_premium(%)',
      'Discount_on_OD_premium(%)',
      'No_of_trailers(Attached)',
      'idvAttached'
    ];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
              width: 180,
              child: Text(label, style: const TextStyle(fontSize: 16))),
          Expanded(
            child: TextFormField(
                controller: _controllers[key],
                onChanged: (value) {
                  if (key == 'idvAttached') {
                    // _updateCurrentIdv();
                    _updateCurrentAttachedIdv();
                  } else if (key == 'idv') {
                    _updateCurrentIdv();
                  }
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: placeholder,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                ],
                validator: (value) {
                  // Skip validation if this field is optional
                  if (optionalFields.contains(key)) return null;

                  // Required validation
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter $label';
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> options,
      String? selected, Function(String?) onChanged) {
    String? keyName; // Optional: pass a key for validation skip
    const optionalDropdowns = [
      'Restrcited TPPD', 'LL to Employee (Other Than Paid Driver)',
      'LL to Paid Driver', 'No Claim Bonus(%)',
      'IMT 23', 'CNG/LPG kits',
      'Overturning For Cranes', 'Depreciation (Attached Trailer)',
      'Trailer Towed by' // matches label or keyName
    ];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
              width: 180,
              child: Text(label, style: const TextStyle(fontSize: 16))),
          Expanded(
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              value: selected,
              items: options.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    overflow: label == 'Trailer towed by'
                        ? TextOverflow.ellipsis
                        : null,
                    maxLines: 1,
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              validator: (value) {
                // Skip validation if optional
                if (optionalDropdowns.contains(label) ||
                    (keyName != null && optionalDropdowns.contains(keyName))) {
                  return null;
                }

                if (value == null) {
                  return 'Select $label';
                }
                return null;
              },
              hint: label == 'Zone'
                  ? const Text('Select Zone')
                  : const Text('Select Option'),
            ),
          ),
        ],
      ),
    );
  }
}

double _getOdRate(String zone, String trailerTowedBy, double ageOfVehicle) {
  zone = zone.toUpperCase();
  trailerTowedBy = trailerTowedBy.toLowerCase();

  if (zone == 'A') {
    if (ageOfVehicle <= 5) return 1.208;
    if (ageOfVehicle <= 7) return 1.238;
    return 1.268;
  } else if (zone == 'B') {
    if (ageOfVehicle <= 5) return 1.202;
    if (ageOfVehicle <= 7) return 1.232;
    return 1.262;
  } else if (zone == 'C') {
    if (ageOfVehicle <= 5) return 1.190;
    if (ageOfVehicle <= 7) return 1.220;
    return 1.250;
  }
  return 0.0;
}

double _getTpRate(String trailerTowedBy) {
  trailerTowedBy = trailerTowedBy.toLowerCase();

  if (trailerTowedBy == 'Agriculture Tractors upto 6 HP') {
    return 1645;
  } else if (trailerTowedBy == 'Other Vehicle') {
    return 7267;
  } else {
    return 1645; // fallback/default TP premium if type unknown
  }
}
