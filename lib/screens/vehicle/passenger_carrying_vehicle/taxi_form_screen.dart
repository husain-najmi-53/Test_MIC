import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motor_insurance_app/models/result_data.dart';
import 'package:motor_insurance_app/screens/vehicle/passenger_carrying_vehicle/pcv_result_screen.dart';

class TaxiFormScreen extends StatefulWidget {
  const TaxiFormScreen({super.key});

  @override
  State<TaxiFormScreen> createState() => _TaxiFormScreenState();
}

class _TaxiFormScreenState extends State<TaxiFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  String? _selectedAge;
  String? _selectedZone;
  String? _selectedCngLpgKit;
  String? _selectedAntiTheft;
  String? _selectedNcb;
  String? _selectedLlPaidDriver;
  String? _selectedDepreciation;

  final List<String> _ageOptions = [
    'Upto 5 years',
    '6 to 7 years',
    'Above 7 years'
  ];
  final List<String> _zoneOptions = ['A', 'B'];
  final List<String> _cngLpgOptions = ['Yes', 'No'];
  final List<String> _antiTheftOptions = ['Yes', 'No'];
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

  @override
  void initState() {
    super.initState();
    final fieldKeys = [
      'idv',
      'yearOfManufacture',
      'numberOfPassengers',
      'cubicCapacity',
      'discountOnOd',
      'electronicAccessories',
      'externalCngLpgKit',
      'zeroDepRate',
      'rsaAmount',
      'paOwnerDriver',
      'otherCess',
      'currentIdv', // added controller for currentIdv
    ];
    for (var key in fieldKeys) {
      _controllers[key] = TextEditingController();
    }
    _controllers['idv']!.addListener(_updateCurrentIdv);
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
    String ageOfVehicle = _selectedAge ?? 'Upto 5 years';
    String yearOfManufacture = _controllers['yearOfManufacture']!.text;
    String zone = _selectedZone ?? 'A';
    int numberOfPassengers =
        int.tryParse(_controllers['numberOfPassengers']!.text) ?? 0;
    double discountOnOd =
        double.tryParse(_controllers['discountOnOd']!.text) ?? 0.0;
    double electronicAccessories =
        double.tryParse(_controllers['electronicAccessories']!.text) ?? 0.0;
    double externalCngLpgKit =
        double.tryParse(_controllers['externalCngLpgKit']!.text) ?? 0.0;
    double paOwnerDriver =
        double.tryParse(_controllers['paOwnerDriver']!.text) ?? 0.0;
    double zeroDepRate =
        double.tryParse(_controllers['zeroDepRate']!.text) ?? 0.0;
    double rsaAmount = double.tryParse(_controllers['rsaAmount']!.text) ?? 0.0;
    double otherCess = double.tryParse(_controllers['otherCess']!.text) ?? 0.0;
    int cubicCapacity = int.tryParse(_controllers['cubicCapacity']!.text) ?? 0;

    double selectedNcb = 0.0;
    if (_selectedNcb != null) {
      selectedNcb = double.tryParse(_selectedNcb!) ?? 0.0;
    }

    double llPaidDriverAmount = 0.0;
    if (_selectedLlPaidDriver != null) {
      llPaidDriverAmount = double.tryParse(_selectedLlPaidDriver!) ?? 0.0;
    }

    String antiTheft = _selectedAntiTheft ?? 'No';

    // Calculate current IDV after depreciation
    double depreciationPercent = 0.0;
    if (_selectedDepreciation != null) {
      depreciationPercent =
          double.tryParse(_selectedDepreciation!.replaceAll('%', '')) ?? 0.0;
    }
    double currentIdv = idv * (1 - (depreciationPercent / 100));
    // double currentIdv =
    //     double.tryParse(_controllers['currentIdv']!.text) ?? 0.0;

    // Convert age label to key for rate lookup
    String ageKey = '';
    switch (ageOfVehicle) {
      case 'Upto 5 years':
        ageKey = 'Upto5Years';
        break;
      case '6 to 7 years':
        ageKey = '5to7Years';
        break;
      case 'Above 7 years':
        ageKey = 'Above7Years';
        break;
      default:
        ageKey = 'Upto5Years';
    }

    // Base OD rate
    double vehicleBasicRate = _getOdRate(zone, ageKey);

    // 1) Basic OD premium based on current IDV and base rate
    double basicOdPremium = (currentIdv * vehicleBasicRate) / 100;

    // 2) Accessories loading: electronic accessories + external CNG/LPG kit
    double accessoriesLoading = electronicAccessories + externalCngLpgKit;

    // 3) Anti-theft discount/loading: assuming 5% discount if Yes
    double antiTheftDiscount = 0.0;
    if (antiTheft == 'Yes') {
      antiTheftDiscount =
          0.05 * basicOdPremium; // 5% discount on basic OD premium
    }

    // 4) Apply discount on OD premium (entered by user)
    double discountAmount = (basicOdPremium * discountOnOd) / 100;

    // OD premium after discount and anti-theft discount
    double odPremiumAfterDiscounts =
        basicOdPremium - discountAmount - antiTheftDiscount;

    // 5) Add accessories loading (usually full amount added)
    double odWithAccessories = odPremiumAfterDiscounts + accessoriesLoading;

    // 6) Apply No Claim Bonus (NCB) on OD premium after discounts and accessories
    double ncbAmount = (odWithAccessories * selectedNcb) / 100;
    double netOdPremium = odWithAccessories - ncbAmount;

    // 7) Zero Depreciation premium (if applicable) as % of current IDV
    double zeroDepPremium = (currentIdv * zeroDepRate) / 100;

    // 8) Add RSA amount
    double totalA = netOdPremium + zeroDepPremium + rsaAmount;

    // Liability Premium (TP)
    double liabilityPremiumTP = _getTpRate(cubicCapacity);
        // _getTpRate(passengerCount: numberOfPassengers, usePerPassenger: false);

    // Total Liability premium includes TP + PA Owner Driver + LL to Paid Driver
    double totalB = liabilityPremiumTP + paOwnerDriver + llPaidDriverAmount;

    // Total package premium before taxes
    double totalAB = totalA + totalB;

    // GST @18%
    double gst = totalAB * 0.18;

    // Other CESS amount
    double otherCessAmt = (otherCess * totalAB) / 100;

    // Final payable premium
    double finalPremium = totalAB + gst + otherCessAmt;

    // Prepare results map
    Map<String, String> resultMap = {
      "IDV": currentIdv.toStringAsFixed(2),
      // "Depreciation (%)": _selectedDepreciation ?? '0%',
      // "Current IDV": currentIdv.toStringAsFixed(2),
      "Year of Manufacture": yearOfManufacture,
      "Zone": zone,
      "Age of Vehicle": ageOfVehicle,
      "No. of Passengers": numberOfPassengers.toString(),
      "Cubic Capacity":cubicCapacity.toString(),
      "Vehicle Basic Rate (%)": vehicleBasicRate.toStringAsFixed(3),
      "Basic OD Premium": basicOdPremium.toStringAsFixed(2),
      "Discount on OD Premium (%)": discountOnOd.toStringAsFixed(2),
      "Discount Amount": discountAmount.toStringAsFixed(2),
      "Anti Theft Discount": antiTheftDiscount.toStringAsFixed(2),
      "OD Premium after Discounts": odPremiumAfterDiscounts.toStringAsFixed(2),
      "Accessories Loading": accessoriesLoading.toStringAsFixed(2),
      "No Claim Bonus (%)": selectedNcb.toStringAsFixed(2),
      "NCB Amount": ncbAmount.toStringAsFixed(2),
      "Net OD Premium": netOdPremium.toStringAsFixed(2),
      "Zero Depreciation Premium": zeroDepPremium.toStringAsFixed(2),
      "RSA Amount": rsaAmount.toStringAsFixed(2),
      "Total A (Net OD Premium + Zero Dep + RSA)": totalA.toStringAsFixed(2),
      "Liability Premium (TP)": liabilityPremiumTP.toStringAsFixed(2),
      "PA to Owner Driver": paOwnerDriver.toStringAsFixed(2),
      "LL to Paid Driver": llPaidDriverAmount.toStringAsFixed(2),
      "Total B (Liability Premium)": totalB.toStringAsFixed(2),
      "Total Package Premium (A + B)": totalAB.toStringAsFixed(2),
      "GST @ 18%": gst.toStringAsFixed(2),
      "Other CESS (%)": otherCess.toStringAsFixed(2),
      "Other CESS Amount": otherCessAmt.toStringAsFixed(2),
      "Final Premium Payable": finalPremium.toStringAsFixed(2),
    };

    // Show results screen
    InsuranceResultData resultData = InsuranceResultData(
      vehicleType: "Taxi (Upto 6 Passengers)",
      fieldData: resultMap,
      totalPremium: finalPremium,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PcvInsuranceResultScreen(resultData: resultData),
      ),
    );
  }}

  void _resetForm() {
    _formKey.currentState!.reset();
    for (var controller in _controllers.values) {
      controller.clear();
    }
    setState(() {
      _selectedAge = null;
      _selectedZone = null;
      _selectedCngLpgKit = null;
      _selectedAntiTheft = null;
      _selectedNcb = null;
      _selectedLlPaidDriver = null;
      _selectedDepreciation = null;
      _controllers['currentIdv']!.text = '-';
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
          child: Text(
            'Taxi (Upto 6 Passengers)',
            style: TextStyle(color: Colors.white, fontSize: 18),
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField('idv', 'IDV', 'Enter IDV'),
                        _buildDropdownField('Depreciation',
                            _depreciationOptions, _selectedDepreciation, (val) {
                          setState(() {
                            _selectedDepreciation = val;
                            _updateCurrentIdv();
                          });
                        }),
                        _buildReadOnlyField('currentIdv', 'Current IDV (₹)'),
                        _buildDropdownField(
                            'Age of Vehicle',
                            _ageOptions,
                            _selectedAge,
                            (val) => setState(() => _selectedAge = val)),
                        _buildTextField('yearOfManufacture',
                            'Year of Manufacture', 'Enter Year'),
                        _buildDropdownField('Zone', _zoneOptions, _selectedZone,
                            (val) => setState(() => _selectedZone = val)),
                        _buildTextField('numberOfPassengers',
                            'No. of Passengers', 'Enter Number'),
                        _buildTextField(
                            'cubicCapacity', 'Cubic Capacity', 'Enter CC'),
                        _buildTextField('discountOnOd',
                            'Discount on OD Premium (%)', 'Enter Discount'),
                        _buildTextField('electronicAccessories',
                            'Electronic Accessories', 'Enter Amount'),
                        _buildDropdownField(
                            'CNG/LPG Kits',
                            _cngLpgOptions,
                            _selectedCngLpgKit,
                            (val) => setState(() => _selectedCngLpgKit = val)),
                        _buildTextField('externalCngLpgKit',
                            'CNG/LPG Kits (Externally Fitted)', 'Enter Amount'),
                        _buildDropdownField(
                            'Anti Theft',
                            _antiTheftOptions,
                            _selectedAntiTheft,
                            (val) => setState(() => _selectedAntiTheft = val)),
                        _buildDropdownField(
                            'No Claim Bonus (%)',
                            _ncbOptions,
                            _selectedNcb,
                            (val) => setState(() => _selectedNcb = val)),
                        _buildTextField('zeroDepRate',
                            'Zero Depreciation (Rate %)', 'Enter Rate'),
                        _buildTextField(
                            'rsaAmount',
                            'RSA/Additional For Addons (Amount)',
                            'Enter Amount'),
                        _buildTextField('paOwnerDriver', 'PA to Owner Driver',
                            'Enter Amount'),
                        _buildDropdownField(
                            'LL To Paid Driver',
                            _llPaidDriverOptions,
                            _selectedLlPaidDriver,
                            (val) =>
                                setState(() => _selectedLlPaidDriver = val)),
                        _buildTextField(
                            'otherCess', 'Other CESS (%)', 'Enter %'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
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
      {bool readOnly = false}) {
        const optionalFields = [
      'electronicAccessories',
      'zeroDepRate',
      'paOwnerDriver',
      'paUnnamedPassenger',
      'otherCess',
      'discountOnOd',
      'externalCngLpgKit','rsaAmount'
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
              readOnly: readOnly,
              style: const TextStyle(color: Colors.black),
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
                }
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> options,
      String? selected, Function(String?) onChanged,
      {String placeholder = 'Select Option'}) {
        String? keyName; // Optional: pass a key for validation skip
    const optionalDropdowns = [
      'LL To Paid Driver', 'No Claim Bonus (%)', 'Geographical Extn.',
      'CNG/LPG Kits', 'IMT 23','Restricted TPPD','Anti Theft' // matches label or keyName
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
              hint: Text(placeholder),
            ),
          ),
        ],
      ),
    );
  }
}


double _getOdRate(String zone, String age) {
  if (age == 'Upto5Years') {
    if (zone == 'A') return 3.284;
    if (zone == 'B') return 3.191;
  } else if (age == '5to7Years') {
    if (zone == 'A') return 3.366;
    if (zone == 'B') return 3.271;
  } else if (age == 'Above7Years') {
    if (zone == 'A') return 3.448;
    if (zone == 'B') return 3.351;
  }
  return 1.0;
}


double _getTpRate(int cc) {
  if (cc <= 1000) return 6040.0;
  if (cc > 1000 && cc <= 1500) return 7940.0;
  if (cc > 1500) return 10523.0;
  return 0.0;
}