import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motor_insurance_app/models/result_data.dart';
import 'package:motor_insurance_app/screens/vehicle/passenger_carrying_vehicle/pcv_result_screen.dart';

class BusUpto6FormScreen extends StatefulWidget {
  const BusUpto6FormScreen({super.key});

  @override
  State<BusUpto6FormScreen> createState() => _BusUpto6FormScreenState();
}

class _BusUpto6FormScreenState extends State<BusUpto6FormScreen> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> _controllers = {
    'idv': TextEditingController(),
    'yearOfManufacture': TextEditingController(),
    'numberOfPassengers': TextEditingController(),
    'discountOnOd': TextEditingController(),
    'accessoriesValue': TextEditingController(),
    'externalCngLpgKit': TextEditingController(),
    'paOwnerDriver': TextEditingController(),
    'otherCess': TextEditingController(),
  };

  String? _selectedAge;
  String? _selectedZone;
  String? _selectedImt23;
  String? _selectedCngKit;
  String? _selectedNcb;
  String? _selectedLlPaidDriver;
  String? _selectedRestrictedTppd;
  String? _selectedDepreciation;
  String? _selectedGeographicalExtn;

  double _currentIdv = 0.0;

  final List<String> _ageOptions = [
    'Upto 5 Years',
    '6-10 Years',
    'Above 10 Years'
  ];
  final List<String> _zoneOptions = ['A', 'B', 'C'];
  final List<String> _imt23Options = ['Yes', 'No'];
  final List<String> _cngKitOptions = ['Yes', 'No'];
  final List<String> _ncbOptions = ['0', '20', '25', '35', '45', '50'];
  final List<String> _llPaidDriverOptions = ['0', '50'];
  final List<String> _restrictedTppdOptions = ['Yes', 'No'];
  final List<String> _depreciationOptions = [
    '0%',
    '5%',
    '10%',
    '15%',
    '20%',
    '25%',
    '30%'
  ];
  final List<String> _geographicalExtnOptions = ['0', '400'];

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
        double.tryParse(_selectedDepreciation?.replaceAll('%', '') ?? '0') ??
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
    if (_formKey.currentState!.validate()) {
      double idv = double.tryParse(_controllers['idv']!.text) ?? 0.0;
      double depreciation =
          double.tryParse(_selectedDepreciation?.replaceAll('%', '') ?? '0') ??
              0.0;
      String age = _selectedAge ?? 'Upto 5 Years';
      String zone = _selectedZone ?? 'A';
      String yearOfManufacture = _controllers['yearOfManufacture']!.text;
      int passengerCount =
          int.tryParse(_controllers['numberOfPassengers']!.text) ?? 0;
      double discountOnOdPercent =
          double.tryParse(_controllers['discountOnOd']!.text) ?? 0.0;
      double accessories =
          double.tryParse(_controllers['accessoriesValue']!.text) ?? 0.0;
      double externalCng =
          double.tryParse(_controllers['externalCngLpgKit']!.text) ?? 0.0;
      double paOwnerDriver =
          double.tryParse(_controllers['paOwnerDriver']!.text) ?? 0.0;
      double otherCessPercent =
          double.tryParse(_controllers['otherCess']!.text) ?? 0.0;

      double selectedNcbPercent = double.tryParse(_selectedNcb ?? '0') ?? 0.0;
      double llPaidDriverAmount =
          double.tryParse(_selectedLlPaidDriver ?? '0') ?? 0.0;
      double geographicalExtnAmount =
          double.tryParse(_selectedGeographicalExtn ?? '0') ?? 0.0;
      bool imt23Yes = (_selectedImt23 == 'Yes');
      bool restrictedTppdYes = (_selectedRestrictedTppd == 'Yes');
      bool cngKitYes = (_selectedCngKit == 'Yes');

      double currentIdv = idv * (1 - (depreciation / 100));

      String ageKey = '';
      if (age == 'Upto 5 Years') {
        ageKey = 'Upto5Years';
      } else if (age == '6-10 Years') {
        ageKey = '5to10Years';
      } else {
        ageKey = 'Above10Years';
      }

      double odRate = _getBusOdRate(zone, ageKey);
      double basicOdPremium = (currentIdv * odRate) / 100;
      double imt23Loading = imt23Yes ? basicOdPremium * 0.05 : 0.0;
      double odAfterImt23 = basicOdPremium + imt23Loading;
      double discountAmount = odAfterImt23 * discountOnOdPercent / 100;
      double odAfterDiscount = odAfterImt23 - discountAmount;
      double odWithAccessories = odAfterDiscount + accessories + externalCng;
      double cngKitLoading = cngKitYes ? currentIdv * 0.02 : 0.0;
      double odWithCngLoading = odWithAccessories + cngKitLoading;
      double ncbAmount = odWithCngLoading * selectedNcbPercent / 100;
      double netOdPremium = odWithCngLoading - ncbAmount;
      double tpPremium = 14343.0; // Fixed for upto 6 passengers

      if (restrictedTppdYes) {
        tpPremium = tpPremium * 0.90;
      }

      double premiumBeforeCess = netOdPremium +
          tpPremium +
          paOwnerDriver +
          llPaidDriverAmount +
          geographicalExtnAmount;
      double otherCessAmount = (otherCessPercent / 100) * premiumBeforeCess;
      double gstAmount = premiumBeforeCess * 0.18;
      double finalPremium = premiumBeforeCess + otherCessAmount + gstAmount;

      Map<String, String> resultData = {
        'IDV (₹)': currentIdv.toStringAsFixed(2),
        'Depreciation (%)': depreciation.toStringAsFixed(2),
        'Current IDV (₹)': currentIdv.toStringAsFixed(2),
        'Age of Vehicle': age,
        'Zone': zone,
        'No. of Passengers': passengerCount.toString(),
        'Year Of Manufacture': yearOfManufacture,
        'Basic OD Rate (%)': odRate.toStringAsFixed(3),
        'Basic OD Premium (₹)': basicOdPremium.toStringAsFixed(2),
        'IMT 23 Loading (₹)': imt23Loading.toStringAsFixed(2),
        'OD Premium after IMT 23 (₹)': odAfterImt23.toStringAsFixed(2),
        'Discount on OD Premium (%)': discountOnOdPercent.toStringAsFixed(2),
        'Discount Amount (₹)': discountAmount.toStringAsFixed(2),
        'OD Premium after Discount (₹)': odAfterDiscount.toStringAsFixed(2),
        'Electrical/Electronic Accessories (₹)': accessories.toStringAsFixed(2),
        'CNG/LPG Kits (Externally Fitted) (₹)': externalCng.toStringAsFixed(2),
        'CNG/LPG Kit Loading (₹)': cngKitLoading.toStringAsFixed(2),
        'OD Premium after Accessories and CNG Loading (₹)':
            odWithCngLoading.toStringAsFixed(2),
        'No Claim Bonus (%)': selectedNcbPercent.toStringAsFixed(2),
        'NCB Amount (₹)': ncbAmount.toStringAsFixed(2),
        'Geographical Extn. (₹)': geographicalExtnAmount.toStringAsFixed(2),
        'Net OD Premium (₹)': netOdPremium.toStringAsFixed(2),
        'TP Premium (₹)': tpPremium.toStringAsFixed(2),
        'Restricted TPPD':
            restrictedTppdYes ? 'Yes (10% discount applied)' : 'No',
        'PA to Owner Driver (₹)': paOwnerDriver.toStringAsFixed(2),
        'LL to Paid Driver (₹)': llPaidDriverAmount.toStringAsFixed(2),
        'Premium Before Cess (₹)': premiumBeforeCess.toStringAsFixed(2),
        'Other Cess (%)': otherCessPercent.toStringAsFixed(2),
        'Other Cess Amount (₹)': otherCessAmount.toStringAsFixed(2),
        'GST @ 18% (₹)': gstAmount.toStringAsFixed(2),
        'Final Premium Payable (₹)': finalPremium.toStringAsFixed(2),
      };

      InsuranceResultData insuranceResultData = InsuranceResultData(
        vehicleType: "Bus Upto 6 Passenger",
        fieldData: resultData,
        totalPremium: finalPremium,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PcvInsuranceResultScreen(resultData: insuranceResultData),
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
      _selectedCngKit = null;
      _selectedNcb = null;
      _selectedLlPaidDriver = null;
      _selectedRestrictedTppd = null;
      _selectedDepreciation = null;
      _selectedGeographicalExtn = null;
      _currentIdv = 0.0;
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
            'Bus Upto 6 Passenger',
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
                        _buildDropdownField(
                            'Age of Vehicle',
                            _ageOptions,
                            _selectedAge,
                            (val) => setState(() => _selectedAge = val)),
                        _buildTextField('yearOfManufacture',
                            'Year Of Manufacture', 'Enter Year'),
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
                        _buildTextField(
                            'accessoriesValue',
                            'Electrical/Electronic Accessories (₹)',
                            'Enter Value'),
                        _buildDropdownField(
                            'CNG/LPG Kits',
                            _cngKitOptions,
                            _selectedCngKit,
                            (val) => setState(() => _selectedCngKit = val),
                            hintText: 'Select Option'),
                        _buildTextField(
                            'externalCngLpgKit',
                            'CNG/LPG Kits (Externally Fitted) (₹)',
                            'Enter Value'),
                        _buildDropdownField(
                            'No Claim Bonus (%)',
                            _ncbOptions,
                            _selectedNcb,
                            (val) => setState(() => _selectedNcb = val),
                            hintText: 'Select Option'),
                        _buildDropdownField(
                            'Geographical Extn.',
                            _geographicalExtnOptions,
                            _selectedGeographicalExtn,
                            (val) =>
                                setState(() => _selectedGeographicalExtn = val),
                            hintText: 'Select Option'),
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
                            'Restricted TPPD',
                            _restrictedTppdOptions,
                            _selectedRestrictedTppd,
                            (val) =>
                                setState(() => _selectedRestrictedTppd = val),
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
      'accessoriesValue',
      'zeroDepreciation',
      'paOwnerDriver',
      'paUnnamedPassenger',
      'otherCess',
      'discountOnOd',
      'externalCngLpgKit',
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
      'CNG/LPG Kits', 'IMT 23','Restricted TPPD' // matches label or keyName
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

// Helper methods
double _getBusOdRate(String zone, String age) {
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

// double _getBusTpRate(
//     {required int passengerCount, bool usePerPassenger = false}) {
//   if (passengerCount <= 6) {
//     return usePerPassenger ? 1214.0 * passengerCount : 2539.0;
//   } else if (passengerCount > 6 && passengerCount <= 17) {
//     return usePerPassenger ? 1349.0 * passengerCount : 6763.0;
//   } else if (passengerCount > 17 && passengerCount <= 26) {
//     return usePerPassenger ? 1349.0 * passengerCount : 9697.0;
//   } else if (passengerCount > 26) {
//     return usePerPassenger ? 1349.0 * passengerCount : 13725.0;
//   }
//   return 0.0; // fallback
// }
