import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motor_insurance_app/models/result_data.dart';
import 'package:motor_insurance_app/screens/vehicle/bike/bike_result_screen.dart';

class TwoWheeler1YearOD1YearTPFormScreen extends StatefulWidget {
  const TwoWheeler1YearOD1YearTPFormScreen({super.key});

  @override
  State<TwoWheeler1YearOD1YearTPFormScreen> createState() =>
      _TwoWheeler1YearOD1YearTPFormScreenState();
}

class _TwoWheeler1YearOD1YearTPFormScreenState
    extends State<TwoWheeler1YearOD1YearTPFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> _controllers = {
    'idv': TextEditingController(),
    'depreciation': TextEditingController(),
    'currentIdv': TextEditingController(),
    'yearOfManufacture': TextEditingController(),
    'cubicCapacity': TextEditingController(),
    'discountOnOd': TextEditingController(),
    'accessoriesValue': TextEditingController(),
    'paOwnerDriver': TextEditingController(),
    'paUnnamedPassenger': TextEditingController(),
    'zeroDepreciation': TextEditingController(),
    'otherCess': TextEditingController(),
  };

  String? _selectedDepreciation;
  String? _selectedAge;
  String? _selectedZone;
  String? _selectedNoClaimBonus;
  String? _selectedLLPaidDriver;

  final List<String> _depreciationOptions = [
    '0%',
    '5%',
    '10%',
    '15%',
    '20%',
    '25%',
    '30%',
  ];
  final List<String> _ageOptions = [
    'Upto 5 Years',
    '6-10 Years',
    'Above 10 Years'
  ];
  final List<String> _zoneOptions = ['A', 'B'];
  final List<String> _ncbOptions = ['0%', '20%', '25%', '35%', '45%', '50%'];
  final List<String> _llPaidDriverOptions = ['0', '50'];

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
    double idv = double.tryParse(_controllers['currentIdv']!.text) ?? 0.0;
    String yearOfManufacture = _controllers['yearOfManufacture']!.text;
    String zone = _selectedZone ?? "A";
    int cubicCapacity = int.tryParse(_controllers['cubicCapacity']!.text) ?? 0;
    double discountOnOd =
        double.tryParse(_controllers['discountOnOd']!.text) ?? 0.0;
    double accessoriesValue =
        double.tryParse(_controllers['accessoriesValue']!.text) ?? 0.0;
    double zeroDepreciation =
        double.tryParse(_controllers['zeroDepreciation']!.text) ?? 0.0;
    double paOwnerDriver =
        double.tryParse(_controllers['paOwnerDriver']!.text) ?? 0.0;
    double paUnnamedPassenger =
        double.tryParse(_controllers['paUnnamedPassenger']!.text) ?? 0.0;
    double otherCess = double.tryParse(_controllers['otherCess']!.text) ?? 0.0;
    double llToPaidDriver =
        double.tryParse(_selectedLLPaidDriver ?? "0") ?? 0.0;
    String selectedNCBText = _selectedNoClaimBonus ?? "0%";
    double ncbPercentage =
        double.tryParse(selectedNCBText.replaceAll('%', '')) ?? 0.0;

     // Get age of vehicle
      String ageOfVehicle = _selectedAge ?? "Upto 5 Years";

      // Get base rate from function
      double vehicleBasicRate =
          _getOdRate(zone, ageOfVehicle, cubicCapacity);

    // OD Calculations
    double basicForVehicle = (idv * vehicleBasicRate) / 100;
    double discountAmount = (basicForVehicle * discountOnOd) / 100;
    double basicOdAfterDiscount = basicForVehicle - discountAmount;
    double totalBasicPremium = basicOdAfterDiscount + accessoriesValue;
    double ncbAmount = (totalBasicPremium * ncbPercentage) / 100;
    double netOdPremium = totalBasicPremium - ncbAmount;
    double totalA = netOdPremium + zeroDepreciation;

    // TP Section
    double liabilityPremiumTP =
        getTpRate(cubicCapacity, isFiveYear: false); // This is 1 Year TP
    double totalB = liabilityPremiumTP +
        paOwnerDriver +
        llToPaidDriver +
        paUnnamedPassenger;

    // Total Premium (C)
    double totalAB = totalA + totalB;
    double gst = totalAB * 0.18;
    otherCess = (otherCess * totalAB) / 100;
    double finalPremium = totalAB + gst + otherCess;

    // Result Map
    Map<String, String> resultMap = {
      // Basic Details
      "IDV": idv.toStringAsFixed(2),
      "Year of Manufacture": yearOfManufacture.toString(),
      "Zone": zone,
      "Cubic Capacity": cubicCapacity.toString(),

      // A - Own Damage Premium Package
      "Vehicle Basic Rate": vehicleBasicRate.toStringAsFixed(3),
      "Basic for Vehicle": basicForVehicle.toStringAsFixed(2),
      "Discount on OD Premium": discountAmount.toStringAsFixed(2),
      "Basic OD Premium after discount":
          basicOdAfterDiscount.toStringAsFixed(2),
      "Accessories Value": accessoriesValue.toStringAsFixed(2),
      "Total Basic Premium": totalBasicPremium.toStringAsFixed(2),
      "No Claim Bonus": ncbAmount.toStringAsFixed(2),
      "Net Own Damage Premium": netOdPremium.toStringAsFixed(2),
      "Zero Dep Premium": zeroDepreciation.toStringAsFixed(2),
      "Total A": totalA.toStringAsFixed(2),

      // B - Liability Premium
      "Liability Premium (TP)": liabilityPremiumTP.toStringAsFixed(2),
      "PA to Owner Driver": paOwnerDriver.toStringAsFixed(2),
      "LL to Paid Driver": llToPaidDriver.toStringAsFixed(2),
      "PA to Unnamed Passenger": paUnnamedPassenger.toStringAsFixed(2),
      "Total B": totalB.toStringAsFixed(2),

      // C - Total Premium
      "Total Package Premium[A+B]": totalAB.toStringAsFixed(2),
      "GST @ 18%": gst.toStringAsFixed(2),
      "Other CESS": otherCess.toStringAsFixed(2),

      // Final Premium
      "Final Premium": finalPremium.toStringAsFixed(2),
    };

    // Pass data to result screen
    InsuranceResultData resultData = InsuranceResultData(
      vehicleType: "Two Wheeler 1Y OD + 1Y TP",
      fieldData: resultMap,
      totalPremium: finalPremium,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BikeInsuranceResultScreen(resultData: resultData),
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
      _selectedDepreciation = null;
      _selectedAge = null;
      _selectedZone = null;
      _selectedNoClaimBonus = null;
      _selectedLLPaidDriver = null;
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
              //Icon(Icons.two_wheeler, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Two Wheeler 1Y OD + 1Y TP',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                overflow: TextOverflow.ellipsis,
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
                // _buildTextField(
                //     'depreciation', 'Depreciation (%)', 'Enter Depreciation'),
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
                _buildDropdownField('Age of Vehicle', _ageOptions, _selectedAge,
                    (val) => setState(() => _selectedAge = val)),
                _buildTextField(
                    'yearOfManufacture', 'Year of Manufacture', 'Enter Year'),
                _buildDropdownField('Zone', _zoneOptions, _selectedZone,
                    (val) => setState(() => _selectedZone = val)),
                _buildTextField(
                    'cubicCapacity', 'Cubic Capacity (cc)', 'Enter CC'),
                _buildTextField('discountOnOd', 'Discount on OD Premium (%)',
                    'Enter Discount %'),
                _buildTextField('accessoriesValue', 'Accessories Value (₹)',
                    'Enter Accessories Value'),
                _buildDropdownField(
                    'No Claim Bonus (%)',
                    _ncbOptions,
                    _selectedNoClaimBonus,
                    (val) => setState(() => _selectedNoClaimBonus = val)),
                _buildTextField('zeroDepreciation', 'Zero Depreciation (₹)',
                    'Enter Amount'),
                _buildTextField(
                    'paOwnerDriver', 'PA to Owner Driver (₹)', 'Enter Amount'),
                _buildTextField('paUnnamedPassenger',
                    'PA to Unnamed Passenger (₹)', 'Enter Amount'),
                _buildDropdownField(
                    'LL to Paid Driver',
                    _llPaidDriverOptions,
                    _selectedLLPaidDriver,
                    (val) => setState(() => _selectedLLPaidDriver = val)),
                _buildTextField('otherCess', 'Other Cess (%)', 'Enter Cess %'),
                //const Divider(),
                // _buildTextField('tpBasic', 'Third Party Basic Premium (₹)',
                //     'Enter TP Premium'),
                // _buildTextField('tpCoverForCNG', 'TP CNG/LPG Kit Cover (₹)',
                //     'Enter CNG/LPG Cover'),
                // _buildTextField('tpLegalLiabilityEmployees',
                //     'TP LL for Employees (₹)', 'Enter TP Employee LL'),
                //const SizedBox(height: 80),
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
            backgroundColor: Colors.indigo,
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
      'accessoriesValue',
      'zeroDepreciation',
      'paOwnerDriver',
      'paUnnamedPassenger',
      'otherCess',
      'discountOnOd'
    ];
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
                onChanged: (val) {
                  if (key == 'idv') _updateCurrentIdv();
                },
                controller: _controllers[key],
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
                  return null;
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    List<String> options,
    String? selected,
    Function(String?) onChanged,
  ) {
    String? keyName; // Optional: pass a key for validation skip
    const optionalDropdowns = [
      'LL to Paid Driver', 'No Claim Bonus (%)' // matches label or keyName
    ];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
            width: 180,
            child: Text(label, style: const TextStyle(fontSize: 16)),
          ),
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

double _getOdRate(String zone, String age, int cc) {
  if (zone == 'A') {
    if (cc <= 150) {
      if (age == 'Upto 5 Years') return 1.708;
      if (age == '6-10 Years' || age == 'Above 10 Years') return 1.793;
    } else if (cc <= 350) {
      if (age == 'Upto 5 Years') return 1.793;
      if (age == '6-10 Years' || age == 'Above 10 Years') return 1.883;
    } else {
      if (age == 'Upto 5 Years') return 1.879;
      if (age == '6-10 Years' || age == 'Above 10 Years') return 1.973;
    }
  } else if (zone == 'B') {
    if (cc <= 150) {
      if (age == 'Upto 5 Years') return 1.676;
      if (age == '6-10 Years' || age == 'Above 10 Years') return 1.760;
    } else if (cc <= 350) {
      if (age == 'Upto 5 Years') return 1.760;
      if (age == '6-10 Years' || age == 'Above 10 Years') return 1.848;
    } else {
      if (age == 'Upto 5 Years') return 1.884;
      if (age == '6-10 Years' || age == 'Above 10 Years') return 1.936;
    }
  }

  return 1.936; // fallback
}

double getTpRate(int cc, {bool isFiveYear = false}) {
  if (isFiveYear) {
    if (cc <= 75) return 2901.0;
    if (cc <= 150) return 3851.0;
    if (cc <= 350) return 7365.0;
    return 15117.0; // above 350cc
  } else {
    if (cc <= 75) return 538.0;
    if (cc <= 150) return 714.0;
    if (cc <= 350) return 1366.0;
    return 2804.0; // above 350cc
  }
}
