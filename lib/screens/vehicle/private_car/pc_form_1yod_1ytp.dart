import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motor_insurance_app/models/result_data.dart';
import 'package:motor_insurance_app/screens/vehicle/private_car/pc_result_screen.dart';

class PCForm1YOD1TP extends StatefulWidget {
  const PCForm1YOD1TP({
    super.key,
  });

  @override
  State<PCForm1YOD1TP> createState() => _PCForm1YOD1TPState();
}

class _PCForm1YOD1TPState extends State<PCForm1YOD1TP> {
  final _formKey = GlobalKey<FormState>();

  // TextEditingControllers
  late Map<String, TextEditingController> _controllers;

  String? _selectedDepreciation;
  String? _selectedAge;
  String? _selectedZone;
  String? _selectedCngLpgKit;
  String? _selectedNcb;
  String? _selectedLlPaidDriver;

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
  final List<String> _cngLpgKitOptions = ['Yes', 'No'];
  final List<String> _ncbOptions = ['0%', '20%', '25%', '35%', '45%', '50%'];
  // final List<String> _imt23Options = ['Yes', 'No'];
  final List<String> _llPaidDriverOptions = ['0', '50'];
  // final List<String> _restrictedTppdOptions = ['Yes', 'No'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllers = {
      'od': TextEditingController(), //1
      'tp': TextEditingController(), //2
      'idv': TextEditingController(), //3
      'currentIdv': TextEditingController(), //3
      'vehicleAge': TextEditingController(), //4
      'yearOfManufacture': TextEditingController(), //5
      'cubicCapacity': TextEditingController(), //7
      'discountOnOd': TextEditingController(), //8
      'loading_on_discount_premium': TextEditingController(), //9
      'electricAccessories': TextEditingController(), //10
      'nonElectricAccessories': TextEditingController(), //11
      'CNG_LPG_kits_Ex_fitted': TextEditingController(), //13
      'zeroDepreciation': TextEditingController(), //15
      'RSAaddons': TextEditingController(), //16
      'otherAddonCoverage': TextEditingController(), //17
      'ValueAddedServices': TextEditingController(), //18
      'paOwnerDriver': TextEditingController(), //319
      'paUnnamedPassenger': TextEditingController(), //21
      'otherCess': TextEditingController(), //22
      // 'currentIdv': TextEditingController(),
    };
    _controllers['od']!.text = '1';
    _controllers['tp']!.text = '1';
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
      double idv = double.tryParse(_controllers['idv']!.text) ?? 0.0;
      double currentIdv =
          double.tryParse(_controllers['currentIdv']!.text) ?? 0.0;
      String yearOfManufacture = _controllers['yearOfManufacture']!.text;
      String zone = _selectedZone ?? "A";
      int cubicCapacity =
          int.tryParse(_controllers['cubicCapacity']!.text) ?? 0;
      double discountOnOd =
          double.tryParse(_controllers['discountOnOd']!.text) ?? 0.0;
      double loading_on_discount_premium =
          double.tryParse(_controllers['loading_on_discount_premium']!.text) ??
              0.0;
      double electricAccessories =
          double.tryParse(_controllers['electricAccessories']!.text) ?? 0.0;
      double nonElectricAccessories =
          double.tryParse(_controllers['nonElectricAccessories']!.text) ?? 0.0;
      double CNG_LPG_kits_Ex_fitted =
          double.tryParse(_controllers['CNG_LPG_kits_Ex_fitted']!.text) ?? 0.0;
      double zeroDepreciation =
          double.tryParse(_controllers['zeroDepreciation']!.text) ?? 0.0;
      double RSAaddons =
          double.tryParse(_controllers['RSAaddons']!.text) ?? 0.0;
      double otherAddonCoverage =
          double.tryParse(_controllers['otherAddonCoverage']!.text) ?? 0.0;
      double ValueAddedServices =
          double.tryParse(_controllers['ValueAddedServices']!.text) ?? 0.0;
      double paOwnerDriver =
          double.tryParse(_controllers['paOwnerDriver']!.text) ?? 0.0;
      double paUnnamedPassenger =
          double.tryParse(_controllers['paUnnamedPassenger']!.text) ?? 0.0;
      double otherCess =
          double.tryParse(_controllers['otherCess']!.text) ?? 0.0;
      double llToPaidDriver =
          double.tryParse(_selectedLlPaidDriver ?? "0") ?? 0.0;
      String selectedNCBText = _selectedNcb ?? "0%";
      double ncbPercentage =
          double.tryParse(selectedNCBText.replaceAll('%', '')) ?? 0.0;

      // Get base rate from function
      int cc = int.tryParse(_controllers['cubicCapacity']?.text ?? "") ?? 1000;
      /*int age = (_selectedAge != null && _selectedAge != _ageOptions.last)
          ? int.tryParse(_selectedAge!) ?? 1
          : 6;*/
      String age = _selectedAge ?? 'Upto 5 Years';
      double vehicleBasicRate = getOdRate(
        vehicleAgeYears: age,
        zone: zone,
        cubicCapacity: cc,
        kiloWatt: 0,
        isElectric: false,
      ); // ODRate
      

      // OD Calculations
      double basicForVehicle = currentIdv * vehicleBasicRate / 100;
      double discountAmount = (basicForVehicle * discountOnOd) / 100;
      double basicOdAfterDiscount = basicForVehicle - discountAmount;
      basicOdAfterDiscount +=
          (basicOdAfterDiscount * loading_on_discount_premium) / 100;
      double electricAccessoriesValue = electricAccessories==0.0?0.0:(electricAccessories/1000)*40;
      double nonElectricAccessoriesValue = nonElectricAccessories==0.0?0.0:(nonElectricAccessories/1000)*30;
      double accessoriesValue = electricAccessoriesValue + nonElectricAccessoriesValue;
      double cngLpgPremium = 0.0;
      if (_cngLpgKitOptions == 'Yes' && CNG_LPG_kits_Ex_fitted > 0) {
        cngLpgPremium = (CNG_LPG_kits_Ex_fitted / 1000) * 60;
      }
      double totalBasicPremium =
          basicOdAfterDiscount + accessoriesValue + cngLpgPremium;
      double ncbAmount = (totalBasicPremium * ncbPercentage) / 100;
      double netOdPremium = totalBasicPremium - ncbAmount;
      double totalA = netOdPremium;

      //Add-ons
      double totalB = zeroDepreciation +
          RSAaddons +
          otherAddonCoverage +
          ValueAddedServices;

      // TP Section
      double cngLpgRate = 60;   // change to actual IRDA rate
      double cngLpgKit = _cngLpgKitOptions == 'Yes'?cngLpgRate:0.0;
      int tp_years =
          findTPYear(int.tryParse(_controllers['tp']?.text.trim() ?? "") ?? 1);
      double liabilityPremiumTP = getThirdPartyPremium(
          cubicCapacity: cc, isElectric: false, batteryKwh: 0, years: tp_years);
      double totalC = liabilityPremiumTP +
          cngLpgKit +
          paOwnerDriver +
          llToPaidDriver +
          paUnnamedPassenger;

      // Total Premium (C)
      double totalABC = totalA + totalB + totalC;
      double gst = totalABC * 0.18;
      double otherCessAmt = (otherCess * totalABC) / 100;
      double finalPremium = totalABC + gst + otherCessAmt;

      // Result Map
      Map<String, String> resultMap = {
        // Basic Details
        "IDV": currentIdv.toStringAsFixed(2),
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
        "Total A": totalA.toStringAsFixed(2),

        // B - Add-ons
        "Zero Dep Premium": zeroDepreciation.toStringAsFixed(2),
        "RSA": RSAaddons.toStringAsFixed(2),
        "Other Addon Coverage": otherAddonCoverage.toStringAsFixed(2),
        "Value Added Services": ValueAddedServices.toStringAsFixed(2),
        "Total B": totalB.toStringAsFixed(2),

        // C - Liability Premium
        "Liability Premium (TP)": liabilityPremiumTP.toStringAsFixed(2),
        "PA to Owner Driver": paOwnerDriver.toStringAsFixed(2),
        "LL to Paid Driver": llToPaidDriver.toStringAsFixed(2),
        "PA to Unnamed Passenger": paUnnamedPassenger.toStringAsFixed(2),
        "Total C": totalC.toStringAsFixed(2),

        // D - Total Premium
        "Total Package Premium[A+B+C]": totalABC.toStringAsFixed(2),
        "GST @ 18%": gst.toStringAsFixed(2),
        "Other CESS": otherCessAmt.toStringAsFixed(2).trim(),

        // Final Premium
        "Final Premium": finalPremium.toStringAsFixed(2),
      };

      // Pass data to result screen
      InsuranceResultData resultData = InsuranceResultData(
        vehicleType: "Four Wheeler",
        fieldData: resultMap,
        totalPremium: finalPremium,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              InsuranceCarResultScreen(resultData: resultData),
        ),
      );
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    for (var entry in _controllers.entries) {
    if (entry.key != "od" && entry.key != "tp") {
      entry.value.clear();
    }
  }
    setState(() {
      _selectedAge = null;
      _selectedZone = null;
      _selectedNcb = null;
      _selectedCngLpgKit = null;
      _selectedDepreciation = null;
      // _selectedImt23 = null;
      _selectedLlPaidDriver = null;
      // _selectedRestrictedTppd = null;
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
              SizedBox(width: 8),
              Text(
                'Private Car 1Yr OD 1Yr TP',
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
                const SizedBox(height: 20),
                _buildTextField('od', 'OD Term (in years)', true, "Enter OD "),
                _buildTextField('tp', 'TP Term (in years)', true, "Enter TP "),
                _buildTextField('idv', 'IDV (₹)', true, "Enter IDV "),
                _buildDropdownField(
                    'Depreciation',
                    _depreciationOptions,
                    _selectedDepreciation,
                    (val) => setState(() {
                          _selectedDepreciation = val;
                          _updateCurrentIdv();
                        })),
                _buildReadOnlyField(
                    'currentIdv', 'Current IDV (₹)'), // Read-only field
                _buildDropdownField('Age of Vehicle', _ageOptions, _selectedAge,
                    (val) => setState(() => _selectedAge = val)),
                _buildTextField('yearOfManufacture', 'Year of Manufacture',
                    true, "Enter Year"),
                _buildDropdownField('Zone', _zoneOptions, _selectedZone,
                    (val) => setState(() => _selectedZone = val)),
                _buildTextField('cubicCapacity', 'Cubic Capacity (cc)', true,
                    "Enter Capacity"),
                _buildTextField('discountOnOd', 'Discount on OD Premium (%)',
                    true, "Enter Discount "),
                _buildTextField('loading_on_discount_premium',
                    'Loading on Discount Premium (%)', true, "Enter Discount"),
                _buildTextField('electricAccessories', 'Electrical Accessories',
                    true, "Enter value"),
                _buildTextField('nonElectricAccessories',
                    'Non Electrical Accessories', true, "Enter Value"),
                _buildDropdownField(
                    'CNG/ LPG kits',
                    _cngLpgKitOptions,
                    _selectedCngLpgKit,
                    (val) => setState(() => _selectedCngLpgKit = val)),
                _buildTextField('CNG_LPG_kits_Ex_fitted',
                    'CNG/LPG kits (externally fitted)', true, "Enter Value"),
                _buildDropdownField('No Claim Bonus (%)', _ncbOptions,
                    _selectedNcb, (val) => setState(() => _selectedNcb = val)),
                _buildTextField('zeroDepreciation', 'Zero Depreciation (rate)',
                    true, "Enter Depreciation "),
                _buildTextField('RSAaddons',
                    'RSA/Additional for Addons(amount)', true, "Enter Addons "),
                _buildTextField('otherAddonCoverage',
                    'Other Addon Coverage(rate)', true, "Enter rate "),
                _buildTextField('ValueAddedServices',
                    'Value Added Service(amount)', true, "Enter Amount "),
                _buildTextField('paOwnerDriver', 'PA to Owner Driver (₹)', true,
                    "Enter Amount "),
                _buildDropdownField(
                    'LL to Paid Driver',
                    _llPaidDriverOptions,
                    _selectedLlPaidDriver,
                    (val) => setState(() => _selectedLlPaidDriver = val)),
                _buildTextField('paUnnamedPassenger',
                    'PA to Unnamed Passenger (₹)', true, "Enter Passengers "),
                _buildTextField(
                    'otherCess', 'Other Cess (%)', true, "Enter Cess % "),
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
            textStyle: const TextStyle(fontSize: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Calculate', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildStickyNote() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        // color: const Color.fromARGB(47, 35, 87, 219),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(CupertinoIcons.car, color: Color.fromARGB(255, 167, 13, 13)),
          const SizedBox(width: 8),
          Text(
            'Private Car 1 Year Old ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 167, 13, 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      String key, String label, bool isNumeric, String placeholder) {
    const optionalFields = [
      'electricAccessories',
      'nonElectricAccessories',
      'loading_on_discount_premium',
      'discountOnOd',
      'zeroDepreciation',
      'RSAaddons',
      'otherAddonCoverage',
      'ValueAddedServices',
      'paOwnerDriver',
      'paUnnamedPassenger',
      'otherCess',
      'CNG_LPG_kits_Ex_fitted'
    ];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Left-aligned label
          SizedBox(
            width: 180, // Space for the label
            child: Text(
              label,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.left,
            ),
          ),
          // Right-aligned input field
          Expanded(
            child: TextFormField(
              controller: _controllers[key],
              readOnly: key == 'od' || key == 'tp' ? true : false,
              onChanged: (val) {
                if (key == 'idv') _updateCurrentIdv();
              },
              decoration: InputDecoration(
                  border: const OutlineInputBorder(), hintText: placeholder),
              keyboardType:
                  isNumeric ? TextInputType.number : TextInputType.text,
              inputFormatters: isNumeric
                  ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
                  : null,
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

              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> options,
      String? selected, Function(String?) onChanged) {
    String? keyName;
    const optionalDropdowns = [
      'LL to Paid Driver', 'CNG/ LPG kits',
      'No Claim Bonus (%)' // matches label or keyName
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

  int findTPYear(int i) {
    if (i == 1) return 1;
    return 3;
  }
}

double getOdRate({
  required String vehicleAgeYears,
  required String zone, // "A" or "B"
  int? cubicCapacity, // For Petrol/Diesel
  double? kiloWatt, // For Electric Vehicle
  required bool isElectric,
}) {
  print(
      "age= ${vehicleAgeYears} , zone= ${zone} cubicCapacity= ${cubicCapacity}");
  // Petrol/Diesel rate table (CC based)
  Map<String, Map<String, List<double>>> rateTableCC = {
    "A": {
      "<=1000": [3.127, 3.283, 3.362],
      "1001-1500": [3.283, 3.447, 3.529],
      ">1500": [3.440, 3.612, 3.698],
    },
    "B": {
      "<=1000": [3.039, 3.191,3.267 ],
      "1001-1500": [3.191, 3.351,3.430],
      ">1500": [3.343, 3.510,3.594],
    },
  };

  // Electric Vehicle rate table (kW based)
  Map<String, Map<String, List<double>>> rateTableKW = {
    "A": {
      "<=30": [3.127, 3.283, 3.362],
      "31-65": [3.283, 3.447, 3.529],
      ">65": [3.440, 3.612, 3.698],
    },
    "B": {
      "<=30": [3.039, 3.191,3.267 ],
      "31-65": [3.191, 3.351,3.430],
      ">65": [3.343, 3.510,3.594],
    },
  };

  // Pick correct rate table
  var table = isElectric ? rateTableKW : rateTableCC;

  // Determine band based on type
  String band;
  if (isElectric) {
    if (kiloWatt == null) throw ArgumentError("kiloWatt is required for EV");
    if (kiloWatt <= 30)
      band = "<=30";
    else if (kiloWatt <= 65)
      band = "31-65";
    else
      band = ">65";
  } else {
    if (cubicCapacity == null)
      throw ArgumentError("cubicCapacity is required for Petrol/Diesel");
    if (cubicCapacity <= 1000)
      band = "<=1000";
    else if (cubicCapacity <= 1500)
      band = "1001-1500";
    else
      band = ">1500";
  }

  // Determine age index
  int idx;
  if (vehicleAgeYears == 'Upto 5 Years')
    idx = 0;
  else if (vehicleAgeYears == '6-10 Years')
    idx = 1;
  // else if (vehicleAgeYears == 'Above 10 Years')
  //   idx = 2;
  else
    idx = 2;

  // Get the rate
  List<double>? list = table[zone]?[band];
  if (list == null) return 2.5; // fallback
  return list[idx];
}

int getYearDifference(int previousMonth, int previousYear) {
  DateTime now = DateTime.now();
  DateTime previousDate = DateTime(previousYear, previousMonth);

  int yearDiff = now.year - previousDate.year;

  // Adjust if the current month is earlier than the previous month
  if (now.month < previousDate.month) {
    yearDiff -= 1;
  }

  return yearDiff;
}

double getThirdPartyPremium({
  required int? cubicCapacity,
  bool isElectric = false,
  double? batteryKwh,
  required int years, // 1, 3, or 5 based on IRDAI tables
}) {
  print("Years: ${years}, CubicCapacity: ${cubicCapacity}");
  // Fallback if CC missing
  int cc = (cubicCapacity == null || cubicCapacity <= 0) ? 1200 : cubicCapacity;

  // ---- IRDAI Rate Tables ----
  // All values are examples — replace with latest IRDAI rates before production

  // Petrol/Diesel/Hybrid/CNG cars
  const Map<int, Map<String, double>> fuelRates = {
    1: {"upto1000": 2094.0, "1001to1500": 3416.0, "above1500": 7897.0},
    3: {"upto1000": 6521.0, "1001to1500": 10640.0, "above1500": 24596.0},
    // 5: {"upto1000": 7896.0, "1001to1500": 12890.0, "above1500": 29340.0}
  };

  // Electric Vehicles (battery capacity in kWh)
  const Map<int, Map<String, double>> evRates = {
    1: {"upto30": 1780.0, "31to65": 2904.0, "above65": 6712.0},
    3: {"upto30": 5543.0, "31to65": 9044.0, "above65": 20907.0},
    // 5: {"upto30": 7500.0, "31to65": 12500.0, "above65": 28000.0}
  };

  // ---- Validation ----
  if (years != 1 && years != 3 && years != 5) {
    throw ArgumentError("Invalid policy duration: $years (Allowed: 1, 3, 5)");
  }

  // ---- Electric Vehicle Logic ----
  if (isElectric) {
    double kwh = batteryKwh ?? 30.0;
    final rates = evRates[years]!;
    if (kwh <= 30) return rates["upto30"]!;
    if (kwh <= 65) return rates["31to65"]!;
    return rates["above65"]!;
  }

  // ---- Petrol/Diesel/Hybrid/CNG Logic ----
  final rates = fuelRates[years]!;
  if (cc <= 1000) return rates["upto1000"]!;
  if (cc <= 1500) return rates["1001to1500"]!;
  return rates["above1500"]!;
}
