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

class _ThreeWheelerPCVFormScreenState
    extends State<ThreeWheelerPCVFormScreen> {
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
    '5%',
    '10%',
    '15%',
    '20%',
    '25%',
    '30%'
  ];
  final List<String> _ageOptions = ['Upto 5 Years', '5 to 7 Years', 'Above 7 Years'];

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
    // if (!_formKey.currentState!.validate()) {
    //   return;
    // }

    double lastYearIdv = double.tryParse(_controllers['idv']!.text) ?? 0.0;
    String ageOfVehicle = _selectedAge ?? 'Upto 5 Years'; // dropdown value
    String yearOfManufacture = _controllers['yearOfManufacture']!.text;
    String zone = _selectedZone ?? "A";
    int numberOfPassengers =
        int.tryParse(_controllers['numberOfPassengers']!.text) ?? 0;
    double discountOnOd =
        double.tryParse(_controllers['discountOnOd']!.text) ?? 0.0;
    double electronicAccessories =
        double.tryParse(_controllers['electronicAccessories']!.text) ?? 0.0;
    double externalCngLpgKit =
        double.tryParse(_controllers['externalCngLpgKit']!.text) ?? 0.0;
    double paOwnerDriver =
        double.tryParse(_controllers['paOwnerDriver']!.text) ?? 150.0; // default 150 if blank
    double otherCess = double.tryParse(_controllers['otherCess']!.text) ?? 0.0;

    String selectedImt23 = _selectedImt23 ?? "No";
    String cngLpgKit = _selectedCngLpgKit ?? "No";
    double selectedNcb =
        _selectedNcb != null ? double.tryParse(_selectedNcb!) ?? 0.0 : 0.0;
    String llPaidDriver = _selectedLlPaidDriver ?? "0";
    String restrictedTPPD = _selectedRestrictedTPPD ?? "No";

    // Calculate current IDV based on depreciation
    double depreciationPercent = _selectedDepreciation != null
        ? double.tryParse(_selectedDepreciation!.replaceAll('%', '')) ?? 0.0
        : 0.0;
    double currentIdv = lastYearIdv * (1 - depreciationPercent / 100);

    // Helper to get base OD rate
    double vehicleBasicRate = _getOdRate(zone, ageOfVehicle);

    // 1) Base OD premium on current IDV
    double basicForVehicle = (currentIdv * vehicleBasicRate) / 100;

    // 2) IMT 23 Loading
    double imt23Loading = 0.0;
    if (selectedImt23 == 'Yes') {
      // 2% on electrical accessories value
      imt23Loading = electronicAccessories * 0.02;
    }

    // 3) CNG/LPG factory fitted kit loading
    double cngKitLoading = 0.0;
    if (cngLpgKit == 'Yes') {
      cngKitLoading = currentIdv * 0.10; // 10% of current IDV
    }

    // 4) CNG/LPG external kit loading
    double cngExternalLoading = externalCngLpgKit * 0.02; // 2% of external kit value

    // 5) Sum OD before discounts
    double totalOdBeforeDiscount =
        basicForVehicle + imt23Loading + cngKitLoading + cngExternalLoading;

    // 6) Apply discount on OD premium
    double discountAmount = (totalOdBeforeDiscount * discountOnOd) / 100;
    double odAfterDiscount = totalOdBeforeDiscount - discountAmount;

    // 7) Apply No Claim Bonus (NCB) on OD premium after discount
    double ncbAmount = (odAfterDiscount * selectedNcb) / 100;
    double netOdPremium = odAfterDiscount - ncbAmount;

    // TP Premium calculation (use existing function)
    double baseTpPremium = _getTpRate(
      passengerCount: numberOfPassengers,
      usePerPassenger: false,
    );

    // Apply restricted TPPD discount if yes (20%)
    double tpPremium = restrictedTPPD == 'Yes' ? baseTpPremium * 0.80 : baseTpPremium;

    // PA to owner driver and LL to paid driver fixed premium
    double llPaidDriverAmount = double.tryParse(llPaidDriver) ?? 0.0;
    if (paOwnerDriver == 0.0) paOwnerDriver = 150.0; // default if user left blank

    double totalLiabilityPremium = tpPremium + paOwnerDriver + llPaidDriverAmount;

    // Total premium before taxes
    double totalPremiumBeforeTaxes = netOdPremium + totalLiabilityPremium;

    // GST 18%
    double gst = totalPremiumBeforeTaxes * 0.18;

    // Other CESS (%)
    double otherCessAmt = (otherCess * totalPremiumBeforeTaxes) / 100;

    // Final premium payable
    double finalPremium = totalPremiumBeforeTaxes + gst + otherCessAmt;

    // Result map for display
    Map<String, String> resultMap = {
      // Basic Details
      "IDV": currentIdv.toStringAsFixed(2),
      // "Depreciation %": depreciationPercent.toStringAsFixed(2),
      // "Current IDV": currentIdv.toStringAsFixed(2),
      "Year of Manufacture": yearOfManufacture,
      "Zone": zone,
      "Age of Vehicle": ageOfVehicle,
      'No. of Passengers': numberOfPassengers.toString(),

      // A - Own Damage Premium Package
      "Base OD Rate (%)": vehicleBasicRate.toStringAsFixed(2),
      "Basic OD Premium": basicForVehicle.toStringAsFixed(2),
      "IMT 23 Loading": imt23Loading.toStringAsFixed(2),
      "CNG/LPG Kit Loading": cngKitLoading.toStringAsFixed(2),
      "External CNG/LPG Kit Loading": cngExternalLoading.toStringAsFixed(2),
      "Total OD before Discount": totalOdBeforeDiscount.toStringAsFixed(2),
      "Discount on OD Premium (%)": discountOnOd.toStringAsFixed(2),
      "Discount Amount": discountAmount.toStringAsFixed(2),
      "OD after Discount": odAfterDiscount.toStringAsFixed(2),
      "No Claim Bonus (%)": selectedNcb.toStringAsFixed(2),
      "NCB Amount": ncbAmount.toStringAsFixed(2),
      "Net OD Premium": netOdPremium.toStringAsFixed(2),

      // B - Liability Premium
      "Base TP Premium": baseTpPremium.toStringAsFixed(2),
      "Restricted TPPD": restrictedTPPD == 'Yes' ? "Yes (20% discount)" : "No",
      "TP Premium after restriction": tpPremium.toStringAsFixed(2),
      "PA to Owner Driver": paOwnerDriver.toStringAsFixed(2),
      "LL to Paid Driver": llPaidDriverAmount.toStringAsFixed(2),
      "Total Liability Premium (TP + PA + LL)": totalLiabilityPremium.toStringAsFixed(2),

      // C - Total Premium and Taxes
      "Total Premium before Taxes": totalPremiumBeforeTaxes.toStringAsFixed(2),
      "GST @ 18%": gst.toStringAsFixed(2),
      "Other CESS (%)": otherCess.toStringAsFixed(2),
      "Other CESS Amount": otherCessAmt.toStringAsFixed(2),

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
                'Three Wheeler PCV (Upto 6 Passenger)',
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
                _buildDropdownField('Depreciation', _depreciationOptions,
                    _selectedDepreciation, (val) {
                  setState(() {
                    _selectedDepreciation = val;
                    _updateCurrentIdv();
                  });
                }),
                _buildReadOnlyField(
                    'currentIdv', 'Current IDV (₹)'),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
              width: 180, child: Text(label, style: const TextStyle(fontSize: 16))),
          Expanded(
            child: TextFormField(
              controller: _controllers[key],
              enabled: enabled,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: placeholder,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              validator: (value) =>
                  (value == null || value.trim().isEmpty) && enabled
                      ? 'Enter $label'
                      : null,
              // onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> options, String? selected,
      Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
              width: 180, child: Text(label, style: const TextStyle(fontSize: 16))),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: selected,
              items: options
                  .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: onChanged,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              validator: (value) => value == null ? 'Select $label' : null,
              hint: label == 'Zone' ? const Text('Select Zone') : const Text('Select Option'),
            ),
          ),
        ],
      ),
    );
  }
}

double _getOdRate(String zone, String age) {
  if (age == 'Upto 5 Years') {
    if (zone == 'A') return 4.0;
    if (zone == 'B') return 3.6; // 0.9x
    if (zone == 'C') return 3.2; // 0.8x
  } else if (age == '5 to 7 Years') {
    if (zone == 'A') return 5.0;
    if (zone == 'B') return 4.5;
    if (zone == 'C') return 4.0;
  } else if (age == 'Above 7 Years') {
    if (zone == 'A') return 6.0;
    if (zone == 'B') return 5.4;
    if (zone == 'C') return 4.8;
  }

  return 4.0; // fallback
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
