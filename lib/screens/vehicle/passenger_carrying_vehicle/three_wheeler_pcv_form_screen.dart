// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:motor_insurance_app/models/result_data.dart';
// import 'package:motor_insurance_app/screens/vehicle/passenger_carrying_vehicle/pcv_result_screen.dart';
// class ThreeWheelerPCVFormScreen

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motor_insurance_app/models/result_data.dart';
import 'package:motor_insurance_app/screens/vehicle/passenger_carrying_vehicle/pcv_result_screen.dart';

class ThreeWheelerPCVFormScreen extends StatefulWidget {
  const ThreeWheelerPCVFormScreen({super.key});

  @override
  State<ThreeWheelerPCVFormScreen> createState() =>
      _ThreeWheelerPCVFormScreenState();
}

class _ThreeWheelerPCVFormScreenState extends State<ThreeWheelerPCVFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'idv': TextEditingController(),
    'yearOfManufacture': TextEditingController(),
    'numberOfPassengers': TextEditingController(),
    'discountOnOd': TextEditingController(),
    'electronicAccessories': TextEditingController(),
    'externalCngLpgKit': TextEditingController(),
    'paOwnerDriver': TextEditingController(),
    'zeroDepRate': TextEditingController(),
    'rsaAmount': TextEditingController(),
    'otherCess': TextEditingController(),
    'currentIdv': TextEditingController(), // new field for current IDV
  };

  String? _selectedZone;
  String? _selectedImt23;
  String? _selectedCngLpgKit;
  String? _selectedNcb;
  String? _selectedLlPaidDriver;
  String? _selectedRestrictedTPPD;
  String? _selectedDepreciation; // new selected depreciation value
  String? _selectedAge; // for Age of Vehicle dropdown

  final List<String> _zoneOptions = ['A', 'B', 'C'];
  final List<String> _yesNoOptions = ['Yes', 'No'];
  final List<String> _ncbOptions = ['0', '20', '25', '35', '45', '50'];
  final List<String> _llPaidDriverOptions = ['0', '50'];
  final List<String> _depreciationOptions = [
    '0%',
    '5%',
    '10%',
    '15%',
    '20%',
    '25%',
    '30%'
  ];
  final List<String> _ageOptions = [
    'Upto 5 Years',
    '5 to 7 Years',
    'Above 7 Years'
  ];

  @override
  void initState() {
    super.initState();
    // Auto-select LL to Paid Driver to 50
    _selectedLlPaidDriver = '50';
    _selectedImt23='No';
    _selectedRestrictedTPPD='No';
    _selectedNcb='0';
    _controllers['paOwnerDriver']!.text=0.toString();
    _controllers['otherCess']!.text=0.toString();
    
  }

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

  void _submitForm() {
  if (_formKey.currentState!.validate()) {
    double idv = double.tryParse(_controllers['idv']!.text) ?? 0.0;
    String ageOfVehicle = _selectedAge ?? 'Upto 5 Years';
    String yearOfManufacture = _controllers['yearOfManufacture']!.text;
    String zone = _selectedZone ?? "A";
    int numberOfPassengers = int.tryParse(_controllers['numberOfPassengers']!.text) ?? 1;
    double discountOnOd = double.tryParse(_controllers['discountOnOd']!.text) ?? 0.0;
    double electronicAccessories = double.tryParse(_controllers['electronicAccessories']!.text) ?? 0.0;
    double externalCngLpgKit = double.tryParse(_controllers['externalCngLpgKit']!.text) ?? 0.0;
    double paOwnerDriver = double.tryParse(_controllers['paOwnerDriver']!.text) ?? 40.0;
    double otherCess = double.tryParse(_controllers['otherCess']!.text) ?? 50.0;

    String selectedImt23 = _selectedImt23 ?? "Yes";
    String cngLpgKit = _selectedCngLpgKit ?? "Yes";
    double selectedNcb = _selectedNcb != null ? double.tryParse(_selectedNcb!) ?? 0.0 : 25.0;
    String llPaidDriver = _selectedLlPaidDriver ?? "50";
    // String restrictedTPPD = _selectedRestrictedTPPD ?? "Yes";
     double restrictedTPPD =
          (_selectedRestrictedTPPD == "Yes") ? 150 : 0.0;

    double currentIdv = double.tryParse(_controllers['currentIdv']!.text) ?? 0.0;

    // OD Premium calculations
    double vehicleBasicRate = _getOdRate(zone, ageOfVehicle);
    double basicForVehicle = (currentIdv * vehicleBasicRate) / 100;
    
    double imt23Loading = 0.0;
    if (selectedImt23 == 'Yes') {
      imt23Loading = basicForVehicle * 0.15;
    }
    
    double cngKitLoading = 0.0;
    if (cngLpgKit == 'Yes' && externalCngLpgKit > 0) {
      cngKitLoading = (externalCngLpgKit * 0.04);
    }
    
    double accessories = 0.0;
    if (electronicAccessories > 0) {
      accessories = (electronicAccessories * 0.04);
    }

    double cngTpExtra = 0.0;
      if (_selectedCngLpgKit== 'Yes') {
        cngTpExtra = 60;
      }
     
     double basicOdPremium = basicForVehicle+ accessories + cngKitLoading ;

    double totalOdBeforeDiscount = basicForVehicle + imt23Loading + accessories + cngKitLoading;

    double discountAmount = (totalOdBeforeDiscount * discountOnOd) / 100;
    double odAfterDiscount = totalOdBeforeDiscount - discountAmount;

    /*double odBeforeNcb =
      odAfterDiscount +
          accessories +
          cngKitLoading ;*/
    double odBeforeNcb=odAfterDiscount;

    double ncbAmount = (odAfterDiscount * selectedNcb) / 100;
    double netOdPremium = odAfterDiscount - ncbAmount;

    // Liability Premium calculations
    double baseTpPremium = _getTpRate(
      passengerCount: numberOfPassengers,
      usePerPassenger: false,
    );

    double paUnnamedPassengerRate = _getTpRate(
      passengerCount: numberOfPassengers,
      usePerPassenger: true,
    );
    double paUnnamedPassengerAmount = paUnnamedPassengerRate * numberOfPassengers;

    // double tpPremium = baseTpPremium;
    // if (restrictedTPPD == 'Yes') {
    //   tpPremium = baseTpPremium * 0.80;
    // }

    double llPaidDriverAmount = double.tryParse(llPaidDriver) ?? 0.0;
    
    // Corrected line: Including paUnnamedPassengerAmount
    double totalLiabilityPremium = baseTpPremium + paOwnerDriver + llPaidDriverAmount + paUnnamedPassengerAmount+cngTpExtra-restrictedTPPD;

    // Total Premium and Taxes
    double totalPremiumBeforeTaxes = netOdPremium + totalLiabilityPremium;
    double gst = totalPremiumBeforeTaxes * 0.18;
    double otherCessAmt = (otherCess * totalPremiumBeforeTaxes) / 100;
    double finalPremium = totalPremiumBeforeTaxes + gst + otherCessAmt;

    // Result map for display
    Map<String, String> resultMap = {
      // Basic Details
      "IDV": idv.toStringAsFixed(2),
      "Current IDV": currentIdv.toStringAsFixed(2),
      "Year of Manufacture": yearOfManufacture,
      "Zone": zone,
      "Age of Vehicle": ageOfVehicle,
      'No. of Passengers': numberOfPassengers.toString(),

      // A - Own Damage Premium Package
      "Vehicle Basic Rate": vehicleBasicRate.toStringAsFixed(3),
      "Basic For Vehicle": basicForVehicle.toStringAsFixed(2),
      "Electronic/Electrical Accessories": accessories.toStringAsFixed(2),
      "CNG/LPG Kit(Externally Fitted)": cngKitLoading.toStringAsFixed(2),
      "Basic OD Premium":basicOdPremium.toStringAsFixed(2),
       "IMT 23 Loading": imt23Loading.toStringAsFixed(2),
      "Basic OD before Discount": totalOdBeforeDiscount.toStringAsFixed(2),
     
      "Discount on OD Premium": discountAmount.toStringAsFixed(2),
      "Basic OD Before NCB":odBeforeNcb.toStringAsFixed(2),
      // "Discount Amount": discountAmount.toStringAsFixed(2),
      // "OD after Discount": odAfterDiscount.toStringAsFixed(2),
      "No Claim Bonus": ncbAmount.toStringAsFixed(2),
      // "NCB Amount": ncbAmount.toStringAsFixed(2),
      "Net OD Premium(A)": netOdPremium.toStringAsFixed(2),

      // B - Liability Premium
      "Basic TP Premium": baseTpPremium.toStringAsFixed(2),
      "Passenger Coverage": paUnnamedPassengerAmount.toStringAsFixed(2),
      "CNG/LPG kit":cngTpExtra.toStringAsFixed(2),
      "PA to Owner Driver": paOwnerDriver.toStringAsFixed(2),
      "LL to Paid Driver": llPaidDriverAmount.toStringAsFixed(2),
      "Restricted TPPD": restrictedTPPD.toStringAsFixed(2),
      "Total Liability Premium (B)": totalLiabilityPremium.toStringAsFixed(2),

      // C - Total Premium and Taxes
      "Total Premium before GST[A+B]": totalPremiumBeforeTaxes.toStringAsFixed(2),
      'GST @ 18% [Applied on OD and TP]': gst.toStringAsFixed(2),
      "Other CESS (%)": otherCessAmt.toStringAsFixed(2),
      

      // Final Premium
      "Final Premium Payable": finalPremium.toStringAsFixed(2),
    };

    // Pass data to result screen
    InsuranceResultData resultData = InsuranceResultData(
      vehicleType: "Three Wheeler PCV (More Than 6 Upto 17 passenger)",
      fieldData: resultMap,
      totalPremium: finalPremium,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PcvInsuranceResultScreen(resultData: resultData),
      ),
    );
  }
}

  void _resetForm() {
    _formKey.currentState!.reset();
    for (var controller in _controllers.values) {
      controller.clear();
    }  
    setState(() {
      _selectedZone = null;
      _selectedImt23 = null;
      _selectedCngLpgKit = null;
      _selectedNcb = null;
      _selectedLlPaidDriver = null;
      _selectedRestrictedTPPD = null;
      _selectedDepreciation = null;
      _selectedAge = null;
      _controllers['currentIdv']!.text = '';
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
              Text(
                "Three Wheeler PCV (More Than 6 Upto 17 passenger)",
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
                _buildTextField('idv', 'IDV', 'Enter IDV',
                    onChanged: (val) => _updateCurrentIdv()),
                _buildDropdownField(
                    'Depreciation', _depreciationOptions, _selectedDepreciation,
                    (val) {
                  setState(() {
                    _selectedDepreciation = val;
                    _updateCurrentIdv();
                  });
                }),
                _buildReadOnlyField('currentIdv', 'Current IDV (₹)'),
                _buildDropdownField('Age of Vehicle', _ageOptions, _selectedAge,
                    (val) => setState(() => _selectedAge = val)),
                _buildTextField(
                    'yearOfManufacture', 'Year of Manufacture', 'Enter Year'),
                _buildDropdownField('Zone', _zoneOptions, _selectedZone,
                    (val) => setState(() => _selectedZone = val)),
                _buildTextField(
                    'numberOfPassengers', 'No. of Passengers', 'Enter Number'),
                _buildTextField('discountOnOd', 'Discount on OD Premium (%)',
                    'Enter Discount'),
                _buildDropdownField('IMT 23', _yesNoOptions, _selectedImt23,
                    (val) => setState(() => _selectedImt23 = val)),
                _buildTextField('electronicAccessories',
                    'Electronic Accessories', 'Enter Amount'),
                _buildDropdownField(
                    'CNG/LPG Kits',
                    _yesNoOptions,
                    _selectedCngLpgKit,
                    (val) => setState(() => _selectedCngLpgKit = val)),
                _buildTextField('externalCngLpgKit',
                    'CNG/LPG Kits (Externally fitted)', 'Enter Amount'),
                _buildDropdownField('No Claim Bonus (%)', _ncbOptions,
                    _selectedNcb, (val) => setState(() => _selectedNcb = val)),
                _buildTextField(
                    'paOwnerDriver', 'PA to Owner Driver', 'Enter Amount'),
                _buildDropdownField(
                    'LL to Paid Driver',
                    _llPaidDriverOptions,
                    _selectedLlPaidDriver,
                    (val) => setState(() => _selectedLlPaidDriver = val)),
                _buildDropdownField(
                    'Restricted TPPD',
                    _yesNoOptions,
                    _selectedRestrictedTPPD,
                    (val) => setState(() => _selectedRestrictedTPPD = val)),
                _buildTextField('otherCess', 'Other CESS (%)', 'Enter %'),
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

  Widget _buildTextField(String key, String label, String placeholder,
      {bool enabled = true, Function(String)? onChanged}) {
    const optionalFields = [
      'electronicAccessories',
      'zeroDepreciation',
      'paOwnerDriver',
      'paUnnamedPassenger',
      'otherCess',
      'discountOnOd',
      'externalCngLpgKit',
      'rsaAddon'
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
                enabled: enabled,
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

                  // Passenger count validation
                  if (key == 'numberOfPassengers') {
                    int? passengerCount = int.tryParse(value.trim());
                    if (passengerCount == null) {
                      return 'Enter Between 7 to 16';
                    }
                    if (passengerCount <= 6) {
                      return 'Must be greater than 6';
                    }
                    if (passengerCount >= 17) {
                      return 'Must be less than 17';
                    }
                  }

                  // Date validation for Year of Manufacture
                  if (key == 'yearOfManufacture') {
                    int? year = int.tryParse(value.trim());
                    if (year == null) {
                      return 'Enter a valid year';
                    }
                    int currentYear = DateTime.now().year;
                    if (year > currentYear) {
                      return 'Year cannot be greater than $currentYear';
                    }
                    if (year < 1900) {
                      return 'Year cannot be less than 1900';
                    }
                  }
                  return null;
                }
                // onChanged: onChanged,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> options,
      String? selected, Function(String?) onChanged) {
    const optionalDropdowns = [
      'LL to Paid Driver', 'No Claim Bonus (%)', 'Geographical Extn.',
      'CNG/LPG Kits', 'IMT 23', 'Restricted TPPD', 'LL to Other Employees',
      'Anti Theft' // matches label or keyName
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
              value: selected,
              items: options
                  .map((item) =>
                      DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: onChanged,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              validator: (value) {
                // Skip validation if optional
                if (optionalDropdowns.contains(label)) {
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

double _getOdRate(String zone, String age) {
  if (age == 'Upto 5 Years') {
    if (zone == 'A') return 1.785;
    if (zone == 'B') return 1.777; // 0.9x
    if (zone == 'C') return 1.759; // 0.8x
  } else if (age == '5 to 7 Years') {
    if (zone == 'A') return 1.830;
    if (zone == 'B') return 1.821;
    if (zone == 'C') return 1.803;
  } else if (age == 'Above 7 Years') {
    if (zone == 'A') return 1.874;
    if (zone == 'B') return 1.866;
    if (zone == 'C') return 1.847;
  }
  return 1.785; // fallback
}

double _getTpRate({
  required int passengerCount,
  bool usePerPassenger = false,
}) {
  if (passengerCount <= 6) {
    return usePerPassenger ? 1214.0 : 2539.0;
  } else if (passengerCount > 6 && passengerCount <= 17) {
    return usePerPassenger ? 1349.0 : 6763.0;
  }
  return 0.0;
}
