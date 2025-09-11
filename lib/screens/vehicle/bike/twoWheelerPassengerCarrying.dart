import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motor_insurance_app/models/result_data.dart';
import 'package:motor_insurance_app/screens/vehicle/bike/bike_result_screen.dart';

class TwoWheelerPassengerCarryingFormScreen extends StatefulWidget {
  const TwoWheelerPassengerCarryingFormScreen({super.key});

  @override
  State<TwoWheelerPassengerCarryingFormScreen> createState() =>
      _TwoWheelerPassengerCarryingFormScreenState();
}

class _TwoWheelerPassengerCarryingFormScreenState
    extends State<TwoWheelerPassengerCarryingFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> _controllers = {
    'idv': TextEditingController(),
    'yearOfManufacture': TextEditingController(),
    'cubicCapacity': TextEditingController(),
    'numberOfPassengers': TextEditingController(),
    'discountOnOd': TextEditingController(),
    'accessoriesValue': TextEditingController(),
    'paOwnerDriver': TextEditingController(),
    'otherCess': TextEditingController(),
    'currentIdv': TextEditingController(),
  };

  String? _selectedAge;
  String? _selectedDepreciation;
  String? _selectedZone;
  String? _selectedNcb;
  String? _selectedImt23;
  String? _selectedLlPaidDriver;
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
  final List<String> _ageOptions = [
    'Upto 5 Years',
    '6-10 Years',
    'Above 10 Years'
  ];
  final List<String> _zoneOptions = ['A', 'B'];
  final List<String> _ncbOptions = ['0%', '20%', '25%', '35%', '45%', '50%'];
  final List<String> _imt23Options = ['Yes', 'No'];
  final List<String> _llPaidDriverOptions = ['0', '50'];
  final List<String> _restrictedTppdOptions = ['Yes', 'No'];

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
      double idv = double.tryParse(_controllers['currentIdv']!.text) ?? 0.0;
      String yearOfManufacture = _controllers['yearOfManufacture']!.text;
      String zone = _selectedZone ?? "A";
      int cubicCapacity =
          int.tryParse(_controllers['cubicCapacity']!.text) ?? 0;
      double discountOnOd =
          double.tryParse(_controllers['discountOnOd']!.text) ?? 0.0;
      double accessoriesValue =
          double.tryParse(_controllers['accessoriesValue']!.text) ?? 0.0;
      double paOwnerDriver =
          double.tryParse(_controllers['paOwnerDriver']!.text) ?? 0.0;
      double otherCess =
          double.tryParse(_controllers['otherCess']!.text) ?? 0.0;
      double llToPaidDriver =
          double.tryParse(_selectedLlPaidDriver ?? "0") ?? 0.0;
      String selectedNCBText = _selectedNcb ?? "0%";
      double ncbPercentage =
          double.tryParse(selectedNCBText.replaceAll('%', '')) ?? 0.0;
      String selectedImt23 = _selectedImt23 ?? "No";
      String selectedRestrictedTppd = _selectedRestrictedTppd ?? "No";
      int numberOfPassengers =
          int.tryParse(_controllers['numberOfPassengers']!.text) ?? 1;

      // Get age of vehicle
      String ageOfVehicle = _selectedAge ?? "Upto 5 Years";

      // Get base rate from function
      double vehicleBasicRate =
          _getOdRate(zone, ageOfVehicle, cubicCapacity);

      double passenegrCoverage = numberOfPassengers * 580.0;

      // Calculate accessories premium (4% of accessories value)
      double accessoriesPremium = (accessoriesValue * 4) / 100;

      // OD Calculations
      double basicForVehicle = (idv * vehicleBasicRate) / 100;
      double imt23Premium = 0.0;
      if (selectedImt23 == "Yes") {
        imt23Premium = (basicForVehicle * 15) / 100;
      }
      
      // Add accessories and IMT23 value before discount
      // double basicPremiumWithImt23AndAccessories = basicForVehicle + imt23Premium + accessoriesPremium;
      double discountAmount = (basicForVehicle * discountOnOd) / 100;
      double basicOdAfterDiscount = basicForVehicle - discountAmount;
      double totalBasicPremium = basicOdAfterDiscount + accessoriesPremium + imt23Premium;
      double ncbAmount = (totalBasicPremium * ncbPercentage) / 100;
      double netOdPremium = totalBasicPremium - ncbAmount;
      double totalA = netOdPremium;

      // TP Section
      String restrictedTppd = selectedRestrictedTppd == "Yes" ? "-50.00" : "0.00";
      double liabilityPremiumTP =
          _getTpPremiumPCV(cubicCapacity, numberOfPassengers);
      double totalLiabilityPremium = liabilityPremiumTP;
      if (selectedRestrictedTppd == "Yes") {
        totalLiabilityPremium =
            (totalLiabilityPremium - 50); // Apply restricted TPPD discount
      }
      double totalB = totalLiabilityPremium +
          paOwnerDriver +
          llToPaidDriver +
          passenegrCoverage;

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
        "Cubic Capacity": cubicCapacity.toString(),
        "No. of Passengers": numberOfPassengers.toString(),

        // A - Own Damage Premium Package
        "Vehicle Basic Rate": vehicleBasicRate.toStringAsFixed(3),
        "Basic for Vehicle": basicForVehicle.toStringAsFixed(2),
        "Discount on OD": discountAmount.toStringAsFixed(2),
        "Basic OD after Discount": basicOdAfterDiscount.toStringAsFixed(2),
        "IMT 23": imt23Premium.toStringAsFixed(2),
        "Accessories Value": accessoriesPremium.toStringAsFixed(2),
        "Total Basic Premium": totalBasicPremium.toStringAsFixed(2),
        "No Claim Bonus": ncbAmount.toStringAsFixed(2),
        "Total A": netOdPremium.toStringAsFixed(2),

        // B - Liability Premium
        "Basic Liability Premium": liabilityPremiumTP.toStringAsFixed(2),
        "Passenger Coverage": passenegrCoverage.toStringAsFixed(2),
        "PA to Owner Driver": paOwnerDriver.toStringAsFixed(2),
        "LL to Paid Driver": llToPaidDriver.toStringAsFixed(2),
        "Restricted TPPD": restrictedTppd,
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
        vehicleType: "Two Wheeler Passenger Carrying",
        fieldData: resultMap,
        totalPremium: finalPremium,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              BikeInsuranceResultScreen(resultData: resultData),
        ),
      );
    }
  }

  Future<void> _resetForm() async {
    _formKey.currentState?.reset();
    for (var controller in _controllers.values) {
      controller.clear();
    }
    setState(() {
      _selectedDepreciation = null;
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
              //Icon(Icons.people, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Two Wheeler Passenger Carrying',
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
                _buildTextField(
                    'cubicCapacity', 'Cubic Capacity (cc)', 'Enter Capacity'),
                _buildTextField(
                    'numberOfPassengers', 'No. of Passengers', 'Enter Number'),
                _buildTextField('discountOnOd', 'Discount on OD Premium (%)',
                    'Enter Discount'),
                _buildDropdownField('IMT 23', _imt23Options, _selectedImt23,
                    (val) => setState(() => _selectedImt23 = val)),
                _buildTextField('accessoriesValue', 'Accessories Value (₹)',
                    'Enter Accessories Value'),
                _buildDropdownField('No Claim Bonus (%)', _ncbOptions,
                    _selectedNcb, (val) => setState(() => _selectedNcb = val)),
                _buildTextField(
                    'paOwnerDriver', 'PA to Owner Driver (₹)', 'Enter Amount'),
                _buildDropdownField(
                    'LL to Paid Driver',
                    _llPaidDriverOptions,
                    _selectedLlPaidDriver,
                    (val) => setState(() => _selectedLlPaidDriver = val)),
                _buildDropdownField(
                    'Restricted TPPD',
                    _restrictedTppdOptions,
                    _selectedRestrictedTppd,
                    (val) => setState(() => _selectedRestrictedTppd = val)),
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
    // Optional dropdown fields
    const optionalFields = [
      'accessoriesValue',
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
    const optionalDropdowns = [
      'LL to Paid Driver', 'No Claim Bonus (%)','IMT 23','Restricted TPPD' // matches label or keyName
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

double _getOdRate(String zone, String age, int cc) {
  if (zone == 'A') {
    if (cc < 150) {
      if (age == 'Upto 5 Years') return 1.708;
      if (age == '6-10 Years') return 1.793;
      if (age == 'Above 10 Years') return 1.886; // Corrected rate
    } else if (cc <= 350) {
      if (age == 'Upto 5 Years') return 1.793;
      if (age == '6-10 Years') return 1.883;
      if (age == 'Above 10 Years') return 1.978; // Corrected rate
    } else { // cc > 350
      if (age == 'Upto 5 Years') return 1.879;
      if (age == '6-10 Years') return 1.973;
      if (age == 'Above 10 Years') return 2.020; // Corrected rate
    }
  } else if (zone == 'B') {
    if (cc < 150) {
      if (age == 'Upto 5 Years') return 1.676;
      if (age == '6-10 Years') return 1.760;
      if (age == 'Above 10 Years') return 1.802; // Corrected rate
    } else if (cc <= 350) {
      if (age == 'Upto 5 Years') return 1.760;
      if (age == '6-10 Years') return 1.848;
      if (age == 'Above 10 Years') return 1.892; // Corrected rate
    } else { // cc > 350
      if (age == 'Upto 5 Years') return 1.844; // Corrected rate
      if (age == '6-10 Years') return 1.936;
      if (age == 'Above 10 Years') return 1.982; // Corrected rate
    }
  }

  // Fallback for invalid input. Returning -1 is a better practice
  // than returning a rate value that corresponds to valid data.
  return -1.0; 
}

double _getTpPremiumPCV(int cubicCapacity, int numberOfPassengers) {
  double basicRate;

  if (cubicCapacity <= 350) {
    basicRate = 861.0;
  } else {
    basicRate = 2254.0;
  }

  return basicRate;
}
