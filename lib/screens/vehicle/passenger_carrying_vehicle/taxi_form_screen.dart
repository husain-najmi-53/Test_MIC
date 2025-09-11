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
      'currentIdv',
    ];
    for (var key in fieldKeys) {
      _controllers[key] = TextEditingController();
    }
    _controllers['idv']!.addListener(_updateCurrentIdv);
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
      int cubicCapacity = int.tryParse(_controllers['cubicCapacity']!.text) ?? 1000;

      double selectedNcb = 0.0;
      if (_selectedNcb != null) {
        selectedNcb = double.tryParse(_selectedNcb!) ?? 0.0;
      }

      double llPaidDriverAmount = 0.0;
      if (_selectedLlPaidDriver != null) {
        llPaidDriverAmount = double.tryParse(_selectedLlPaidDriver!) ?? 0.0;
      }

      String antiTheft = _selectedAntiTheft ?? 'No';

      double depreciationPercent = 0.0;
      if (_selectedDepreciation != null) {
        depreciationPercent =
            double.tryParse(_selectedDepreciation!.replaceAll('%', '')) ?? 0.0;
      }
      double currentIdv = idv * (1 - (depreciationPercent / 100));

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

      // OD Premium calculations
      double vehicleBasicRate = _getOdRate(zone, ageKey, cubicCapacity);
      
      double basicforvehicle = (currentIdv * vehicleBasicRate) / 100;
      
      
      double electronicAccessoriesPremium = (electronicAccessories * 0.04);
      double cngKitLoading = (externalCngLpgKit * 0.04);
      double basicOdPremium =  basicforvehicle+ electronicAccessoriesPremium + cngKitLoading;

      double antiTheftDiscount = 0.0;
      if (antiTheft == 'Yes') {
        antiTheftDiscount = (basicOdPremium  * 2.5) / 100;
      }

      
       double cngTpExtra = 0.0;
      if (_selectedCngLpgKit== 'Yes') {
        cngTpExtra = 60;
      }
      
      double odBeforeDiscount = basicOdPremium - antiTheftDiscount;
      
      double discountAmount = (odBeforeDiscount * discountOnOd) / 100;
      double odPremiumAfterDiscounts = odBeforeDiscount - discountAmount;

      double odBeforeNcb=discountAmount;
      // odPremiumAfterDiscounts+
      //     electronicAccessoriesPremium +
      //     cngKitLoading +
      //     rsaAmount ;
      
      double ncbAmount = (odPremiumAfterDiscounts * selectedNcb) / 100;
      double netOdPremium = odPremiumAfterDiscounts - ncbAmount;

      // Addons calculations
      double zeroDepPremium = (currentIdv * zeroDepRate) / 100;
      double totalA = netOdPremium;
      double totalAddon=zeroDepPremium+rsaAmount;

      // Liability Premium (TP) calculations
      double liabilityPremiumTP = _getTpRate(cubicCapacity);
      double passCov= numberOfPassengers* _getPaPassengerRate(cubicCapacity);

      // double paUnnamedPassenger = _getPaPassengerRate(numberOfPassengers);
      double totalB = liabilityPremiumTP + paOwnerDriver + llPaidDriverAmount + passCov+cngTpExtra;

      // Total premium before GST
      double totalAB = totalA + totalB+ totalAddon;
      
      // GST & Other CESS
      double gst = totalAB * 0.18;
      double otherCessAmt = (otherCess * totalAB) / 100;

      // Final payable premium
      double finalPremium = totalAB + gst + otherCessAmt;

      // Prepare results map
      Map<String, String> resultMap = {
        "IDV": currentIdv.toStringAsFixed(2),
        // "Current IDV": currentIdv.toStringAsFixed(2),
        "Year of Manufacture": yearOfManufacture,
        "Zone": zone,
        // "Age of Vehicle": ageOfVehicle,
        "No. of Passengers": numberOfPassengers.toString(),
        "Cubic Capacity": cubicCapacity.toString(),

        "Vehicle Basic Rate": vehicleBasicRate.toStringAsFixed(3),
        "Basic for Vehicle": basicforvehicle.toStringAsFixed(2),
        "Electronic/Electrical Accessories": electronicAccessoriesPremium.toStringAsFixed(2),
        "CNG/LPG kits": cngKitLoading.toStringAsFixed(2),
        "Basic OD Premium": basicOdPremium.toStringAsFixed(2),
        "Anti-Theft": antiTheftDiscount.toStringAsFixed(2),
        "Basic OD Before Discount":odBeforeDiscount.toStringAsFixed(2),
        "Discount on OD": discountAmount.toStringAsFixed(2),
        "Basic OD Before NCB":odBeforeNcb.toStringAsFixed(2), //check formula
        // "Discount Amount": discountAmount.toStringAsFixed(2),
        "No Claim Bonus": ncbAmount.toStringAsFixed(2),
        // "OD Premium after Discounts": odPremiumAfterDiscounts.toStringAsFixed(2),
        // "NCB Amount": ncbAmount.toStringAsFixed(2),
        "Net OD Premium[A]": netOdPremium.toStringAsFixed(2),
        "Total A": totalA.toStringAsFixed(2),

        "Zero Dep Premium": zeroDepPremium.toStringAsFixed(2),
        "RSA/Additional for Addons": rsaAmount.toStringAsFixed(2),
        "Total Addon Premium": totalAddon.toStringAsFixed(2),
        "Total B": totalAddon.toStringAsFixed(2),

        //C liability premium
        "Basic Liability Premium": liabilityPremiumTP.toStringAsFixed(2),
        "Passenger Coverage": passCov.toStringAsFixed(2),
        // "PA to Unnamed Passengers": paUnnamedPassenger.toStringAsFixed(2),
        "CNG/LPG Kit (TP)":cngTpExtra.toStringAsFixed(2), 
        "PA to Owner Driver": paOwnerDriver.toStringAsFixed(2),
        "LL to Paid Driver": llPaidDriverAmount.toStringAsFixed(2),
        "Total C": totalB.toStringAsFixed(2),

        //D 
        "Total Package Premium(A + B + C)": totalAB.toStringAsFixed(2),
        'GST @ 18% [Applied on OD and TP]': gst.toStringAsFixed(2),
        "Other CESS": otherCessAmt.toStringAsFixed(2),
        // "Other CESS Amount": otherCessAmt.toStringAsFixed(2),
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
    }
  }

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
      'externalCngLpgKit',
      'rsaAmount'
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
                if (optionalFields.contains(key)) return null;

                if (value == null || value.trim().isEmpty) {
                  return 'Enter $label';
                }

                 // Passenger count validation
                  if (key == 'numberOfPassengers') {
                    int? passengerCount = int.tryParse(value.trim());
                    if (passengerCount == null) {
                      return 'Enter a valid number';
                    }
                    if (passengerCount > 6) {
                      return 'Can\'t be more than 6';
                    }
                    if (passengerCount < 1) {
                      return 'Must be at least 1';
                    }
                  }
                  
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
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> options,
      String? selected, Function(String?) onChanged,
      {String placeholder = 'Select Option'}) {
    String? keyName;
    const optionalDropdowns = [
      'LL To Paid Driver',
      'No Claim Bonus (%)',
      'Geographical Extn.',
      'CNG/LPG Kits',
      'IMT 23',
      'Restricted TPPD',
      'Anti Theft'
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

double _getOdRate(String zone, String age, int cubicCapacity) {
  if (cubicCapacity <= 1000) {
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
  } else if (cubicCapacity > 1000 && cubicCapacity <= 1500) {
    if (age == 'Upto5Years') {
      if (zone == 'A') return 3.448;
      if (zone == 'B') return 3.351;
    } else if (age == '5to7Years') {
      if (zone == 'A') return 3.534;
      if (zone == 'B') return 3.435;
    } else if (age == 'Above7Years') {
      if (zone == 'A') return 3.620;
      if (zone == 'B') return 3.519;
    }
  } else {
    if (age == 'Upto5Years') {
      if (zone == 'A') return 3.612;
      if (zone == 'B') return 3.510;
    } else if (age == '5to7Years') {
      if (zone == 'A') return 3.703;
      if (zone == 'B') return 3.598;
    } else if (age == 'Above7Years') {
      if (zone == 'A') return 3.793;
      if (zone == 'B') return 3.686;
    }
  }
  return 3.284;
}

double _getTpRate(int cc) {
  if (cc <= 1000) return 6040.0;
  if (cc > 1000 && cc <= 1500) return 7940.0;
  if (cc > 1500) return 10523.0;
  return 0.0;
}

double _getPaPassengerRate(int cc) {
  if (cc <= 1000) return 1162;
  if (cc > 1000 && cc <= 1500) return 978;
  if (cc > 1500) return 1117;
  return 0.0;
}