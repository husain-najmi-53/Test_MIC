import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motor_insurance_app/models/result_data.dart';
import 'package:motor_insurance_app/screens/vehicle/miscellaneous_vehicle/misc_result_screen.dart';


class OtherMiscFormScreen extends StatefulWidget {
  const OtherMiscFormScreen({super.key});

  @override
  State<OtherMiscFormScreen> createState() =>
      _OtherMiscFormScreenState();
}

class _OtherMiscFormScreenState extends State<OtherMiscFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> _controllers = {
    'idv': TextEditingController(),
    'depreciation': TextEditingController(),
    'currentIdv': TextEditingController(), 
    'AgeOfVehicle': TextEditingController(),
    'yearOfManufacture': TextEditingController(),
    'discountOnOd': TextEditingController(),
    'paOwnerDriver': TextEditingController(),
    'otherCess': TextEditingController(),
  };

  String? _selectedAge;
  String? _selectedDepreciation;
  String? _selectedOverTurningForCranes;
  String? _selectedVehicleType;
  String? _selectedGeographicalExt;
  String? _selectedZone;
  String? _selectedNcb;
  String? _selectedImt23;
  String? _selectedLlPaidDriver;
  String? _selectedLlEmployeeOther;
  

  final List<String> _depreciationOptions = [
    '0%',
    '5%',
    '10%',
    '15%',
    '20%',
    '25%',
    '30%',
  ];
  final List<String> _ageOptions = ['Upto 5 Years', '6-7 Years', 'Above 7 Years'];
  final List<String> _vehicletypeOptions =['Others Vehicle', 'Agriculture upto 6 HP'];
  final List<String> _geographicalExtOptions = ['0', '400'];
  final List<String> _overTurningForCranesOptions = ['Yes', 'No'];
  final List<String> _zoneOptions = ['A', 'B', 'C'];
  final List<String> _ncbOptions = ['0%', '20%', '25%', '35%', '45%', '50%'];
  final List<String> _imt23Options = ['Yes', 'No'];
  final List<String> _llPaidDriverOptions = ['0', '50'];
  final List<String> _llEmployeeOtherOptions = ['0','50','100','150','200','250','300','350'];

  @override
  void initState() {
    super.initState();
    // Auto-select LL to Paid Driver to 50
    _selectedLlPaidDriver = '50';
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
    // Fetch form inputs
    // double idv = double.tryParse(_controllers['idv']!.text) ?? 0.0;
    double currentIdv = double.tryParse(_controllers['currentIdv']!.text) ?? 0.0;
    double selectIMT =_selectedImt23 == 'Yes' ? 15.0 : 0.0;
    String ageCategory = _selectedAge ?? 'Upto 5 Years';
    double geographicalExtent = double.tryParse(_selectedGeographicalExt ?? "0") ?? 0.0;
    double overturning = _selectedOverTurningForCranes == 'Yes' ? 5.0 : 0.0; 
    String vehicleType = _selectedVehicleType ?? "Others Vehicle";
    String yearOfManufacture = _controllers['yearOfManufacture']!.text;
    String zone = _selectedZone ?? "A";
    double discountOnOd = double.tryParse(_controllers['discountOnOd']!.text) ?? 0.0;
    double paOwnerDriver = double.tryParse(_controllers['paOwnerDriver']!.text) ?? 0.0;
    double otherCess = double.tryParse(_controllers['otherCess']!.text) ?? 0.0;
    double llLEmployeeOther = double.tryParse(_selectedLlEmployeeOther ?? "0") ?? 0.0;
    double llToPaidDriver = double.tryParse(_selectedLlPaidDriver ?? "0") ?? 0.0;
    String selectedNCBText = _selectedNcb ?? "0%";
    double ncbPercentage = double.tryParse(selectedNCBText.replaceAll('%', '')) ?? 0.0;

    // Get base rate from function
    double vehicleBasicRate =  _getOdRate(zone, ageCategory);

    // OD Calculations
    double basicForVehicle = (currentIdv * vehicleBasicRate) / 100;
    // double discountAmount = (basicForVehicle * discountOnOd) / 100;
    double basicOdPremium = (currentIdv * vehicleBasicRate) / 100.0;
    double discountAmount = (basicOdPremium * discountOnOd) / 100.0; //discount on OD premium
    double basicAfterDiscount = basicOdPremium - discountAmount; // Basic OD after discount
    double geographicalExtensionAmount = geographicalExtent; // Fixed amount: 0 or 400
    double fixedGeographicalExtensionAmount = _selectedGeographicalExt=='400'?100:0.0; //fixed value as if selected yes in dropdown
    double overturningAmount = (basicAfterDiscount * overturning) / 100.0;
    double imt23Amount = (basicForVehicle * selectIMT) / 100 ;
    double odBeforeNcb = basicAfterDiscount + geographicalExtensionAmount + overturningAmount + imt23Amount;
    double ncbAmount = (odBeforeNcb * ncbPercentage) / 100;
    double totalA = odBeforeNcb - ncbAmount;

    // TP Section
    double liabilityPremiumTP = _getTpRate(vehicleType);
    double totalB = liabilityPremiumTP +
      fixedGeographicalExtensionAmount +
      paOwnerDriver + 
      llToPaidDriver + 
      llLEmployeeOther;



    // Total Premium (C)
    double totalAB = totalA + totalB;
    double gst = totalAB * 0.18;
    double otherCessAmt = (otherCess * totalAB) / 100;
    double finalPremium = totalAB + gst + otherCessAmt;

    // Result Map
    Map<String, String> resultMap = {
      // Basic Details
      "IDV": currentIdv.toStringAsFixed(2),
      "Year of Manufacture": yearOfManufacture.toString(),
      "Zone": zone,
      "Vehicle Type": vehicleType,

      // A - Own Damage Premium Package
      "Vehicle Basic Rate": vehicleBasicRate.toStringAsFixed(3),
      "Basic for Vehicle": basicForVehicle.toStringAsFixed(2),
      "Discount on OD Premium": discountAmount.toStringAsFixed(2),
      "Basic OD Premium After discount":  basicAfterDiscount.toStringAsFixed(2),
      "Geographical Ext": geographicalExtensionAmount.toStringAsFixed(2),
      "Overturning For Cranes": overturningAmount.toStringAsFixed(2),
      "IMT 23": imt23Amount.toStringAsFixed(2),
      "Total Own Damage Premium": odBeforeNcb.toStringAsFixed(2),
      "No Claim Bonus": ncbAmount.toStringAsFixed(2),
      "Net Own Damage Premium": totalA.toStringAsFixed(2),
      // "Total A": totalA.toStringAsFixed(2),

      // B - Liability Premium
      "Liability Premium (TP)": liabilityPremiumTP.toStringAsFixed(2),
      "Geographical Extension": fixedGeographicalExtensionAmount.toStringAsFixed(2),
      "PA to Owner Driver": paOwnerDriver.toStringAsFixed(2),
      "LL to Paid Driver": llToPaidDriver.toStringAsFixed(2),
      "LL to Employee Other than Paid Driver": llLEmployeeOther.toStringAsFixed(2),
      "Total B": totalB.toStringAsFixed(2),

      // C - Total Premium
      "Total Package Premium[A+B]": totalAB.toStringAsFixed(2),
      "GST @ 18% [Applied on OD and TP]": gst.toStringAsFixed(2),
      "Other CESS": otherCessAmt.toStringAsFixed(2),

      // Final Premium
      "Final Premium": finalPremium.toStringAsFixed(2),
    };

    // Pass data to result screen
    InsuranceResultData resultData = InsuranceResultData(
      vehicleType: "Other MISC Vehicle",
      fieldData: resultMap,
      totalPremium: finalPremium,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MiscInsuranceResultScreen(resultData: resultData),
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
      _selectedDepreciation = null;
      _selectedOverTurningForCranes = null;
      _selectedVehicleType = null;
      _selectedGeographicalExt = null;
      _selectedZone = null;
      _selectedNcb = null;
      _selectedImt23 = null;
      _selectedLlPaidDriver = '50'; // Reset to default value
      _selectedLlEmployeeOther = null;
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
                'Other MISC Vehicle',
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
                _buildTextField('idv', 'IDV (₹)', 'Enter IDV'),
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
                // _buildTextField('depreciation', 'Depreciation (%)', 'Enter Depreciation'),
                _buildDropdownField('Age Of Vehicle', _ageOptions, _selectedAge,
                    (val) => setState(() => _selectedAge = val)),
                _buildTextField('yearOfManufacture', 'Year of Manufacture', 'Enter Year of Manufacture'),
                _buildDropdownField('Zone', _zoneOptions, _selectedZone,
                    (val) => setState(() => _selectedZone = val)),
                _buildDropdownField('Vehicle Type', _vehicletypeOptions, _selectedVehicleType,
                    (val) => setState(() => _selectedVehicleType = val)),
                _buildTextField('discountOnOd', 'Discount on OD Premium (%)', 'Enter Discount on OD Premium'),
                _buildDropdownField('Geographical Extension', _geographicalExtOptions, _selectedGeographicalExt,
                    (val) => setState(() => _selectedGeographicalExt = val)),
                _buildDropdownField('Over Turning for Cranes', _overTurningForCranesOptions, _selectedOverTurningForCranes,
                    (val) => setState(() => _selectedOverTurningForCranes = val)),
                _buildDropdownField('IMT 23', _imt23Options, _selectedImt23,
                    (val) => setState(() => _selectedImt23 = val)), 
                _buildDropdownField('No Claim Bonus (%)', _ncbOptions, _selectedNcb,
                    (val) => setState(() => _selectedNcb = val)), 
                _buildTextField('paOwnerDriver', 'PA to Owner Driver (₹)', 'Enter Amount'),
                _buildDropdownField('LL to Paid Driver', _llPaidDriverOptions, _selectedLlPaidDriver,
                    (val) => setState(() => _selectedLlPaidDriver = val)),
                _buildDropdownField('LL to Employee Other than Paid Driver', _llEmployeeOtherOptions, _selectedLlEmployeeOther,
                    (val) => setState(() => _selectedLlEmployeeOther = val)),
                _buildTextField('otherCess', 'Other CESS (%)', 'Enter Other CESS'),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Calculate', style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ),
    );
  }

  Widget _buildTextField(String key, String label, String placeholder) {
        // Optional dropdown fields
  const optionalFields=['otherCess','discountOnOd','paOwnerDriver'
  ];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(width: 180, child: Text(label, style: const TextStyle(fontSize: 16))),
          Expanded(
            child: TextFormField(
              onChanged: (val) {
                  if (key == 'idv') _updateCurrentIdv();
                },
              controller: _controllers[key],
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: placeholder,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
               validator: (value) {
              // Skip validation if this field is optional
              if (optionalFields.contains(key)) return null;

              // Required validation
              if (value == null || value.trim().isEmpty) {
                return 'Enter $label';
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
              return null; // Add missing return statement
            }
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
    String label, List<String> options, String? selected, Function(String?) onChanged) {
        const optionalDropdowns = [
    'LL to Paid Driver','LL to Employee Other than Paid Driver','No Claim Bonus (%)','IMT 23',
    'Geographical Extension','Over Turning for Cranes' // matches label or keyName
  ];
  
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(
      children: [
        SizedBox(
          width: 180,
          child: Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Expanded(
          child: DropdownButtonFormField<String>(
            isExpanded: true, // <-- prevents overflow
            value: selected,
            items: options
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        overflow: TextOverflow.ellipsis, // <-- avoids breaking layout
                      ),
                    ))
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



double _getOdRate(String zone, String ageCategory) {
  if (zone == 'A') {
    if (ageCategory == 'Upto 5 Years') return 1.208;
    if (ageCategory == '6-7 Years') return 1.238;
    return 1.268; // Above 7 Years
  } else if (zone == 'B') {
    if (ageCategory == 'Upto 5 Years') return 1.202;
    if (ageCategory == '6-7 Years') return 1.232;
    return 1.262; // Above 7 Years
  } else if (zone == 'C') {
    if (ageCategory == 'Upto 5 Years') return 1.190;
    if (ageCategory == '6-7 Years') return 1.220;
    return 1.250; // Above 7 Years
  }

  return 1.20; // Safe fallback
}

double _getTpRate(String vehicleType) {
  switch (vehicleType) {
    case 'Others Vehicle':
      return 7267;
    case 'Agriculture upto 6 HP':
      return 1645;
    default:
      return 7267; // default to Others Vehicle rate
  }
}
