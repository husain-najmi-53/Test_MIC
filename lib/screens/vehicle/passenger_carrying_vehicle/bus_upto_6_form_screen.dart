import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motor_insurance_app/models/result_data.dart';
import 'package:motor_insurance_app/screens/vehicle/passenger_carrying_vehicle/pcv_result_screen.dart';

class BusUpto6FormScreen extends StatefulWidget {
  const BusUpto6FormScreen({super.key});

  @override
  State<BusUpto6FormScreen> createState() => BusUpto6FormScreenState();
}

class BusUpto6FormScreenState extends State<BusUpto6FormScreen> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> _controllers = {
    'idv': TextEditingController(),
    'yearOfManufacture': TextEditingController(),
    'numberOfPassengers': TextEditingController(),
    'discountOnOd': TextEditingController(),
    'electricalAccessories': TextEditingController(),
    'externalCngLpgKit': TextEditingController(),
    'rsaAddon': TextEditingController(),
    'paOwnerDriver': TextEditingController(),
    'otherCess': TextEditingController(),
    'zeroDepreciation': TextEditingController(),
  };

  String? _selectedAge;
  String? _selectedZone;
  String? _selectedImt23;
  String? _selectedCngLpgKit;
  String? _selectedAntiTheft;
  String? _selectedNcb;
  String? _selectedGeExtn;
  String? _selectedLlPaidDriver;
  String? _selectedLlOtherEmployee;
  String? _selectedDepreciation;

  double _currentIdv = 0.0;

  final List<String> _ageOptions = [
    'Upto 5 Years',
    '6 to 7 Years',
    'Above 7 Years'
  ];
  final List<String> _zoneOptions = ['A', 'B', 'C'];
  final List<String> _imt23Options = ['Yes', 'No'];
  final List<String> _yesNoOptions = ['Yes', 'No'];
  final List<String> _ncbOptions = ['0', '20', '25', '35', '45', '50'];
  final List<String> _geographicalExtnOptions = ['0', '400'];
  final List<String> _llPaidDriverOptions = ['0', '50'];
  final List<String> _llOtherEmployeeOptions = ['0', '50', '100', '150'];
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
    _controllers['idv']!.addListener(_updateCurrentIdv);
    // Auto-select LL to Paid Driver to 50
    _selectedLlPaidDriver = '50';
  }

  @override
  void dispose() {
    _controllers['idv']!.removeListener(_updateCurrentIdv);
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateCurrentIdv() {
    double idv = double.tryParse(_controllers['idv']!.text) ?? 0.0;
    double depreciation =
        double.tryParse((_selectedDepreciation ?? '0').replaceAll('%', '')) ??
            0.0;
    setState(() {
      if (idv > 0 && depreciation >= 0) {
        _currentIdv = idv * (1 - (depreciation / 100));
      } else {
        _currentIdv = 0.0;
      }
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate())
    {
      double idv = double.tryParse(_controllers['idv']!.text) ?? 0.0;
      double depreciation =
          double.tryParse((_selectedDepreciation ?? '0').replaceAll('%', '')) ??
              0.0;
      String yearOfManufacture = _controllers['yearOfManufacture']!.text;
      String age = _selectedAge ?? 'Upto 5 Years';
      String zone = _selectedZone ?? 'A';
      int passengerCount =
          int.tryParse(_controllers['numberOfPassengers']!.text) ?? 0;
      double geographicalExtent =
          double.tryParse(_selectedGeExtn ?? "0") ?? 0.0;
      double discountOnOd =
          double.tryParse(_controllers['discountOnOd']!.text) ?? 0.0;
      double electricalAccessories =
          double.tryParse(_controllers['electricalAccessories']!.text) ?? 0.0;
      double externalCng =
          double.tryParse(_controllers['externalCngLpgKit']!.text) ?? 0.0;
      double rsaAddons = double.tryParse(_controllers['rsaAddon']!.text) ?? 0.0;
      double paOwnerDriver =
          double.tryParse(_controllers['paOwnerDriver']!.text) ?? 0.0;
      double otherCessPercent =
          double.tryParse(_controllers['otherCess']!.text) ?? 0.0;

      // String imt23 = _selectedImt23 ?? 'No';
      double imt23 =
          _selectedImt23 == 'Yes' ? 15.0 : 0.0; // Assuming 15% for IMT 23
      String cngLpgKit = _selectedCngLpgKit ?? 'No';
      String antiTheft = _selectedAntiTheft ?? 'No';
      double selectedNcbPercent = double.tryParse(_selectedNcb ?? '0') ?? 0.0;
      double llPaidDriverAmount =
          double.tryParse(_selectedLlPaidDriver ?? '0') ?? 0.0;
      double llOtherEmployeeAmount =
          double.tryParse(_selectedLlOtherEmployee ?? '0') ?? 0.0;
      double geographicalExtnAmount =
          double.tryParse(_selectedGeExtn ?? '0') ?? 0.0;
      double zeroDepreciation =
          double.tryParse(_controllers['zeroDepreciation']!.text) ?? 0.0;

      double cngTpExtra = 0.0;
      if (_selectedCngLpgKit == 'Yes') {
        cngTpExtra = 60;
      }
      // 🔹 Step 1: Current IDV
      double currentIdv = idv * (1 - (depreciation / 100));

      // 🔹 Step 2: OD Rate
      String ageKey = (age == 'Upto 5 Years')
          ? 'Upto5Years'
          : (age == '6 to 7 Years')
              ? '5to10Years'
              : 'Above10Years';
      double odRate = _getOdRate(zone, ageKey);
      double basicforvehicle = (currentIdv * odRate) / 100;
      double accessories = (electricalAccessories * 4) / 100;
      double cngKitLoading = (externalCng * 0.04);
      double basicOdPremium = basicforvehicle + accessories + cngKitLoading;
      double geographicalExt = geographicalExtent;
      // 🔹 Step 3: Discounts
      // if (imt23 == 'Yes') {
      //   basicOdPremium *= 0.95; // 5% discount
      // }
      double imt23value = (basicforvehicle * imt23) / 100;

      // double atDiscount=0.0;
      // if (antiTheft == 'Yes') {
      //   double atDiscount = basicOdPremium * 0.025;
      //   if (atDiscount > 500) atDiscount = 500;
      //   basicOdPremium -= atDiscount;
      // }

      //ANTI THEFT
      double atDiscount =  antiTheft=='Yes'?(2.5 * basicOdPremium) / 100:0.0;
      double basicOdBeforeDiscount = basicOdPremium +
          imt23value +
          geographicalExt +
          atDiscount; //basic od before disc
      // 🔹 Step 4: OD discount
      double discountAmount = (basicOdBeforeDiscount * discountOnOd) / 100;
      double odAfterDiscount = basicOdBeforeDiscount - discountAmount;

      // 🔹 Step 6: Total OD before NCB
      /*double totalBasicPremium = odAfterDiscount +
          accessories +
          cngKitLoading +
          rsaAddons +
          geographicalExtnAmount;*/
      double totalBasicPremium = odAfterDiscount;

      // 🔹 Step 7: Apply NCB
      double ncbAmount = (odAfterDiscount * selectedNcbPercent) / 100;
      double netOdPremium = odAfterDiscount - ncbAmount;

      // 🔹 Step 8: Liability Premium (dynamic)
      double tpPremium =
          14343.0; // ← if this should be dynamic, replace with field
      double passCov = passengerCount * 877;
      double fixedGeogExt = _selectedGeExtn=='400'?100.0:0.0;
      double liabilityPremium = tpPremium +
          paOwnerDriver +
          llPaidDriverAmount +
          passCov +
          fixedGeogExt +
          cngTpExtra +
          llOtherEmployeeAmount;

      double zeroDep = (zeroDepreciation * idv) / 100;
      double addonPremium = zeroDep + rsaAddons;

      // 🔹 Step 9: Premium before cess
      double premiumBeforeCess = netOdPremium + liabilityPremium;

      double totalABC = netOdPremium + liabilityPremium + addonPremium;

      // 🔹 Step 10: Other Cess
      double otherCessAmount = (totalABC * otherCessPercent) / 100;

      // 🔹 Step 11: GST (18% on OD + Liability)
      double gstAmount =
          (netOdPremium + liabilityPremium + addonPremium) * 0.18;

      // 🔹 Step 12: Final premium
      double finalPremium = totalABC + otherCessAmount + gstAmount;

      // ✅ Flattened Map<String, String> for result screen
      Map<String, String> resultData = {
        // Basic
        "IDV": idv.toStringAsFixed(2),
        // "Current IDV (₹)": currentIdv.toStringAsFixed(2),
        "Year Of Manufacture": yearOfManufacture,
        "Zone": zone,
        // "Age of Vehicle": age,
        "No. of Passengers": passengerCount.toString(),

        // [A] Own Damage
        "Vehicle Basic Rate": odRate.toStringAsFixed(3),
        "Basic for Vehicle": basicforvehicle.toStringAsFixed(2),
        "Electrical Accessories": accessories.toStringAsFixed(2),
        "CNG/LPG Kits":
            cngKitLoading.toStringAsFixed(2),
        "Basic OD Premium":
            basicOdPremium.toStringAsFixed(2), //check the formula
        "Geographical Extn": geographicalExt.toStringAsFixed(2),
        "IMT 23": imt23value.toStringAsFixed(2),
        "Anti-Theft": atDiscount.toStringAsFixed(2),
        "Basic OD Before Discount":
            basicOdBeforeDiscount.toStringAsFixed(2), //check formula
        "Discount on OD": discountAmount.toStringAsFixed(2),
       // "No Claim Bonus": selectedNcbPercent.toStringAsFixed(2),
        "Basic OD Before NCB": totalBasicPremium.toStringAsFixed(2),
        "No Claim Bonus": ncbAmount.toStringAsFixed(2),

        "Net OD Premium": netOdPremium.toStringAsFixed(2),
        "Total A": netOdPremium.toStringAsFixed(2),

        //[B] Addon Coverages
        "Zero Dep Premium": zeroDep.toStringAsFixed(2),
        "RSA/Additional for Addons": rsaAddons.toStringAsFixed(2),
        "Total Addon Premium": addonPremium.toStringAsFixed(2),
        "Total B": addonPremium.toStringAsFixed(2),

        // [C] Liability
        "Basic Liability Premium": tpPremium.toStringAsFixed(2),
        "Passenger Coverage": passCov.toStringAsFixed(2),
        "Geographical Extn (TP)": fixedGeogExt.toStringAsFixed(2),
        "CNG/LPG Kit (TP)": cngTpExtra.toStringAsFixed(2),
        "PA to Owner Driver": paOwnerDriver.toStringAsFixed(2),
        "LL to Paid Driver": llPaidDriverAmount.toStringAsFixed(2),
        "LL to Other Employees": llOtherEmployeeAmount.toStringAsFixed(2),
        "Total Liability Premium": liabilityPremium.toStringAsFixed(2),
        "Total C": liabilityPremium.toStringAsFixed(2),

        // [D] Total
        "Total Package premium[A+B+C]": totalABC.toStringAsFixed(2),
        "GST @ 18% [Applied on A+B+C]": gstAmount.toStringAsFixed(2),
        "Other CESS": otherCessAmount.toStringAsFixed(2),
        "Final Premium Payable": finalPremium.toStringAsFixed(2),
      };

      InsuranceResultData insuranceResultData = InsuranceResultData(
        vehicleType: "Bus More than 6 Passenger",
        fieldData: resultData,
        totalPremium: finalPremium,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PcvInsuranceResultScreen(
            resultData: insuranceResultData,
          ),
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
      _selectedImt23 = null;
      _selectedCngLpgKit = null;
      _selectedAntiTheft = null;
      _selectedNcb = null;
      _selectedGeExtn = null;
      _selectedLlPaidDriver = null;
      _selectedLlOtherEmployee = null;
      _selectedDepreciation = null;
      // _currentIdv = 0.0;
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
            "Bus More than 6 Passenger",
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
                        _buildTextField('idv', 'IDV (₹)', 'Enter IDV'),
                        _buildDropdownField(
                          'Depreciation (%)',
                          _depreciationOptions,
                          _selectedDepreciation,
                          (val) {
                            setState(() {
                              _selectedDepreciation = val;
                            });
                            _updateCurrentIdv();
                          },
                          hintText: 'Select Depreciation',
                        ),
                        _buildCurrentIdvField(),
                        // _buildReadOnlyField('currentIdv', 'Current IDV (₹)'),
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
                        _buildTextField('discountOnOd',
                            'Discount On OD Premium (%)', 'Enter Discount'),
                        _buildDropdownField(
                            'IMT 23',
                            _imt23Options,
                            _selectedImt23,
                            (val) => setState(() => _selectedImt23 = val),
                            hintText: 'Select Option'),
                        _buildTextField('electricalAccessories',
                            'Electrical Accessories (₹)', 'Enter Value'),
                        _buildDropdownField(
                            'CNG/LPG Kits',
                            _yesNoOptions,
                            _selectedCngLpgKit,
                            (val) => setState(() => _selectedCngLpgKit = val),
                            hintText: 'Select Option'),
                        _buildTextField('externalCngLpgKit',
                            'Externally Fitted CNG/LPG (₹)', 'Enter Kit Value'),
                        _buildDropdownField(
                            'Anti Theft',
                            _yesNoOptions,
                            _selectedAntiTheft,
                            (val) => setState(() => _selectedAntiTheft = val),
                            hintText: 'Select Option'),
                        _buildDropdownField(
                            'No Claim Bonus (%)',
                            _ncbOptions,
                            _selectedNcb,
                            (val) => setState(() => _selectedNcb = val),
                            hintText: 'Select Option'),
                        _buildDropdownField(
                            'Geographical Extn.',
                            _geographicalExtnOptions,
                            _selectedGeExtn,
                            (val) => setState(() => _selectedGeExtn = val),
                            hintText: 'Select Option'),
                        _buildTextField(
                          'zeroDepreciation',
                          'Zero Depreciation (₹)',
                          'Enter Amount',
                        ),

                        _buildTextField(
                            'rsaAddon', 'RSA/Addons (₹)', 'Enter Amount'),
                        _buildTextField('paOwnerDriver',
                            'PA to Owner Driver (₹)', 'Enter Amount'),
                        _buildDropdownField(
                            'LL to Paid Driver',
                            _llPaidDriverOptions,
                            _selectedLlPaidDriver,
                            (val) =>
                                setState(() => _selectedLlPaidDriver = val),
                            hintText: 'Select Option'),
                        _buildDropdownField(
                            'LL to Other Employees',
                            _llOtherEmployeeOptions,
                            _selectedLlOtherEmployee,
                            (val) =>
                                setState(() => _selectedLlOtherEmployee = val),
                            hintText: 'Select Option'),
                        _buildTextField(
                            'otherCess', 'Other Cess (%)', 'Enter Cess %'),
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

  Widget _buildTextField(String key, String label, String placeholder) {
    const optionalFields = [
      'electricalAccessories',
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
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(fontSize: 16)),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: TextFormField(
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

                  // Passenger count validation
                  if (key == 'numberOfPassengers') {
  int? passengerCount = int.tryParse(value.trim());
  if (passengerCount == null) {
    return 'Please enter a valid number';
  }
  if (passengerCount < 6) {
    return 'Must be 6 or more';
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
    Function(String?) onChanged, {
    String? hintText,
  }) {
    String? keyName; // Optional: pass a key for validation skip
    const optionalDropdowns = [
      'LL to Paid Driver', 'No Claim Bonus (%)', 'Geographical Extn.',
      'CNG/LPG Kits', 'IMT 23', 'Restricted TPPD', 'LL to Other Employees',
      'Anti Theft' // matches label or keyName
    ];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(fontSize: 16)),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
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
              hint: Text(hintText ?? 'Select $label'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentIdvField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          const Expanded(
            flex: 2,
            child: Text('Current IDV (₹)', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _currentIdv > 0 ? _currentIdv.toStringAsFixed(2) : '-',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper methods for premium calculations (adapted for School Bus)
double _getOdRate(String zone, String age) {
  if (age == 'Upto5Years') {
    if (zone == 'A') return 1.680;
    if (zone == 'B') return 1.672;
    if (zone == 'C') return 1.656;
  } else if (age == '5to10Years') {
    if (zone == 'A') return 1.722;
    if (zone == 'B') return 1.714;
    if (zone == 'C') return 1.697;
  } else if (age == 'Above10Years') {
    // You can adjust as per rates; keeping slightly higher
    if (zone == 'A') return 1.764;
    if (zone == 'B') return 1.756;
    if (zone == 'C') return 1.739;
  }
  return 1.680; // fallback
}
