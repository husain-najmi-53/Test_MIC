import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motor_insurance_app/screens/result_screen.dart';
import 'package:motor_insurance_app/models/result_data.dart';

class ElectricTwoWheeler1YOD5YTPFormScreen extends StatefulWidget {
  const ElectricTwoWheeler1YOD5YTPFormScreen({super.key});

  @override
  State<ElectricTwoWheeler1YOD5YTPFormScreen> createState() =>
      _ElectricTwoWheeler1YOD5YTPFormScreenState();
}

class _ElectricTwoWheeler1YOD5YTPFormScreenState
    extends State<ElectricTwoWheeler1YOD5YTPFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> _controllers = {
    'idv': TextEditingController(),
    'depreciation': TextEditingController(),
    'currentIdv': TextEditingController(),
    'yearOfManufacture': TextEditingController(),
    'kwCapacity': TextEditingController(),
    'discountOnOd': TextEditingController(),
    'accessoriesValue': TextEditingController(),
    'zeroDepreciation': TextEditingController(),
    'paOwnerDriver': TextEditingController(),
    'paUnnamedPassenger': TextEditingController(),
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
    //if (_formKey.currentState!.validate()) {
    // Fetch form inputs
    double idv = double.tryParse(_controllers['idv']!.text) ?? 0.0;
    String yearOfManufacture = _controllers['yearOfManufacture']!.text;
    String zone = _selectedZone ?? "A";
    double kwCapacity =
        double.tryParse(_controllers['kwCapacity']!.text) ?? 0.0;
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

    // Get base rate from function
    double vehicleBasicRate = _getElectricTwoWheelerOdRate(kwCapacity);

    // OD Calculations
    double basicForVehicle = (idv * vehicleBasicRate) / 100;
    double discountAmount = (basicForVehicle * discountOnOd) / 100;
    double basicOdAfterDiscount = basicForVehicle - discountAmount;
    double totalBasicPremium = basicOdAfterDiscount + accessoriesValue;
    double ncbAmount = (totalBasicPremium * ncbPercentage) / 100;
    double netOdPremium = totalBasicPremium - ncbAmount;
    double totalA = netOdPremium + zeroDepreciation;

    // TP Section
    double liabilityPremiumTP = _getElectricTwoWheelerTpRate(kwCapacity,
        isFiveYear: true); //Else false for 1 Year TP
    double totalB = liabilityPremiumTP +
        paOwnerDriver +
        llToPaidDriver +
        paUnnamedPassenger;

    // Total Premium (C)
    double totalAB = totalA + totalB;
    double gst = totalAB * 0.18;
    double otherCessAmt = (otherCess * totalAB) / 100;
    double finalPremium = totalAB + gst + otherCessAmt;

    // Result Map
    Map<String, String> resultMap = {
      // Basic Details
      "IDV": idv.toStringAsFixed(2),
      "Year of Manufacture": yearOfManufacture.toString(),
      "Zone": zone,
      "Kilowatt": kwCapacity.toString(),

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
      "Other CESS": otherCessAmt.toStringAsFixed(2).trim(),

      // Final Premium
      "Final Premium": finalPremium.toStringAsFixed(2),
    };

    // Pass data to result screen
    InsuranceResultData resultData = InsuranceResultData(
      vehicleType: "Electric Two Wheeler",
      fieldData: resultMap,
      totalPremium: finalPremium,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InsuranceResultScreen(resultData: resultData),
      ),
    );
  }
  //}

  void _resetForm() {
    _formKey.currentState?.reset();
    for (var controller in _controllers.values) {
      controller.clear();
    }
    setState(() {
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
              //Icon(Icons.electric_bike, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Electric Two Wheeler 1Y OD + 5Y TP',
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
                _buildTextField('kwCapacity', 'KW (Kilowatt)', 'Enter KW'),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
              width: 180,
              child: Text(label, style: const TextStyle(fontSize: 16))),
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
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Enter $label' : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> options,
      String? selected, Function(String?) onChanged) {
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
              validator: (value) => value == null ? 'Select $label' : null,
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

double _getElectricTwoWheelerOdRate(double kwCapacity) {
  if (kwCapacity <= 3) {
    return 1.41;
  } else if (kwCapacity <= 7) {
    return 1.76;
  } else {
    return 2.10;
  }
}

double _getElectricTwoWheelerTpRate(double kwCapacity,
    {bool isFiveYear = false}) {
  if (isFiveYear) {
    if (kwCapacity <= 3) return 2466.0;
    if (kwCapacity <= 7) return 3273.0;
    if (kwCapacity <= 16) return 6260.0;
    return 12849.0;
  } else {
    if (kwCapacity <= 3) return 457.0;
    if (kwCapacity <= 7) return 607.0;
    if (kwCapacity <= 16) return 1161.0;
    return 2383.0;
  }
}
