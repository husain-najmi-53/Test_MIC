import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motor_insurance_app/models/result_data.dart';
import 'package:motor_insurance_app/screens/vehicle/passenger_carrying_vehicle/pcv_result_screen.dart';
class SchoolBusFormScreen extends StatefulWidget {
  const SchoolBusFormScreen({super.key});

  @override
  State<SchoolBusFormScreen> createState() => _SchoolBusFormScreenState();
}

class _SchoolBusFormScreenState extends State<SchoolBusFormScreen> {
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

  final List<String> _ageOptions = ['Upto 5 Years', '6 to 7 Years', 'Above 7 Years'];
  final List<String> _zoneOptions = ['A', 'B', 'C'];
  final List<String> _imt23Options = ['Yes', 'No'];
  final List<String> _yesNoOptions = ['Yes', 'No'];
  final List<String> _ncbOptions = ['0', '20', '25', '35', '45', '50'];
  final List<String> _geographicalExtnOptions = ['0', '400'];
  final List<String> _llPaidDriverOptions = ['0', '50'];
  final List<String> _llOtherEmployeeOptions = ['0', '50', '100', '150'];
  final List<String> _depreciationOptions = ['5%', '10%', '15%', '20%', '25%', '30%'];

  @override
  void initState() {
    super.initState();
    _controllers['idv']!.addListener(_updateCurrentIdv);
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
    double depreciation = double.tryParse((_selectedDepreciation ?? '0').replaceAll('%', '')) ?? 0.0;
    setState(() {
      if (idv > 0 && depreciation >= 0) {
        _currentIdv = idv * (1 - (depreciation / 100));
      } else {
        _currentIdv = 0.0;
      }
    });
  }
 
  void _submitForm() {
    // if (!_formKey.currentState!.validate()) return;

    double idv = double.tryParse(_controllers['idv']!.text) ?? 0.0;
    double depreciation = double.tryParse((_selectedDepreciation ?? '0').replaceAll('%', '')) ?? 0.0;
    String age = _selectedAge ?? 'Upto 5 Years';
    String zone = _selectedZone ?? 'A';
    int passengerCount = int.tryParse(_controllers['numberOfPassengers']!.text) ?? 0;
    double discountOnOd = double.tryParse(_controllers['discountOnOd']!.text) ?? 0.0;
    double accessories = double.tryParse(_controllers['electricalAccessories']!.text) ?? 0.0;
    double externalCng = double.tryParse(_controllers['externalCngLpgKit']!.text) ?? 0.0;
    double rsaAddons = double.tryParse(_controllers['rsaAddon']!.text) ?? 0.0;
    double paOwnerDriver = double.tryParse(_controllers['paOwnerDriver']!.text) ?? 0.0;
    double otherCessPercent = double.tryParse(_controllers['otherCess']!.text) ?? 0.0;

    String imt23 = _selectedImt23 ?? 'No';
    String cngLpgKit = _selectedCngLpgKit ?? 'No';
    String antiTheft = _selectedAntiTheft ?? 'No';

    double selectedNcbPercent = double.tryParse(_selectedNcb ?? '0') ?? 0.0;
    double llPaidDriverAmount = double.tryParse(_selectedLlPaidDriver ?? '0') ?? 0.0;
    double llOtherEmployeeAmount = double.tryParse(_selectedLlOtherEmployee ?? '0') ?? 0.0;
    double geographicalExtnAmount = double.tryParse(_selectedGeExtn ?? '0') ?? 0.0;

    // Current IDV after depreciation
    double currentIdv = idv * (1 - (depreciation / 100));

    // Map age text to key for rates
    String ageKey = '';
    if (age == 'Upto 5 Years') {
      ageKey = 'Upto5Years';
    } else if (age == '6 to 7 Years') {
      ageKey = '5to10Years'; // approximate reuse
    } else {
      ageKey = 'Above10Years';
    }

    // 1. Calculate OD Premium
    double odRate = _getOdRate(zone, ageKey);
    double basicOdPremium = (currentIdv * odRate) / 100;

    // 2. IMT 23 - if Yes, 5% discount on OD premium
    if (imt23 == 'Yes') {
      basicOdPremium *= 0.95;
    }

    // 3. Anti Theft Discount - 2.5% discount on OD if Yes
    if (antiTheft == 'Yes') {
      basicOdPremium *= 0.975;
    }

    // 4. Discount on OD (from user)
    double discountAmount = basicOdPremium * discountOnOd / 100;
    double odAfterDiscount = basicOdPremium - discountAmount;

    // 5. Add accessories, external CNG/LPG kit, RSA Addons
    double totalBasicPremium = odAfterDiscount + accessories + externalCng + rsaAddons;

    // 6. NCB discount on totalBasicPremium
    double ncbAmount = totalBasicPremium * selectedNcbPercent / 100;
    double netOdPremium = totalBasicPremium - ncbAmount;

    // 7. TP Premium based on passenger count using official IRDA rates
    double tpPremium = _getSchoolBusTpRate(passengerCount: passengerCount);

    // 8. Add geographical extension if any
    double geographicalExtn = geographicalExtnAmount;

    // 9. Sum before cess and GST
    double premiumBeforeCess = netOdPremium + tpPremium + paOwnerDriver + llPaidDriverAmount + llOtherEmployeeAmount + geographicalExtn;

    // 10. Other cess
    double otherCessAmount = (otherCessPercent / 100) * premiumBeforeCess;

    // 11. GST 18% on premiumBeforeCess + otherCessAmount
    double gstAmount = (premiumBeforeCess + otherCessAmount) * 0.18;

    // 12. Final premium
    double finalPremium = premiumBeforeCess + otherCessAmount + gstAmount;

    // Prepare result map
    Map<String, String> resultData = {
      'IDV (₹)': currentIdv.toStringAsFixed(2),
      'Depreciation (%)': depreciation.toStringAsFixed(2),
      'Current IDV (₹)': currentIdv.toStringAsFixed(2),
      'Age of Vehicle': age,
      'Zone': zone,
      'No. of Passengers': passengerCount.toString(),
      'Basic OD Premium (₹)': basicOdPremium.toStringAsFixed(2),
      'IMT 23 Applied': imt23,
      'Anti Theft Applied': antiTheft,
      'Discount on OD Premium (₹)': discountAmount.toStringAsFixed(2),
      'OD Premium after Discount (₹)': odAfterDiscount.toStringAsFixed(2),
      'Electrical Accessories(₹)': accessories.toStringAsFixed(2),
      'CNG/LPG Kits':cngLpgKit,
      'External CNG/LPG Kit (₹)': externalCng.toStringAsFixed(2),
      'RSA/Addons (₹)': rsaAddons.toStringAsFixed(2),
      'Total Basic Premium (₹)': totalBasicPremium.toStringAsFixed(2),
      'No Claim Bonus (%)': selectedNcbPercent.toStringAsFixed(2),
      'NCB Amount (₹)': ncbAmount.toStringAsFixed(2),
      'Net OD Premium (₹)': netOdPremium.toStringAsFixed(2),
      'TP Premium (₹)': tpPremium.toStringAsFixed(2),
      'Geographical Extension (₹)': geographicalExtn.toStringAsFixed(2),
      'PA to Owner Driver (₹)': paOwnerDriver.toStringAsFixed(2),
      'LL to Paid Driver (₹)': llPaidDriverAmount.toStringAsFixed(2),
      'LL to Other Employees (₹)': llOtherEmployeeAmount.toStringAsFixed(2),
      'Premium Before Cess (₹)': premiumBeforeCess.toStringAsFixed(2),
      'Other Cess (%)': otherCessPercent.toStringAsFixed(2),
      'Other Cess Amount (₹)': otherCessAmount.toStringAsFixed(2),
      'GST @ 18% (₹)': gstAmount.toStringAsFixed(2),
      'Final Premium Payable (₹)': finalPremium.toStringAsFixed(2),
    };

    InsuranceResultData insuranceResultData = InsuranceResultData(
      vehicleType: "School Bus",
      fieldData: resultData,
      totalPremium: finalPremium,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PcvInsuranceResultScreen(resultData: insuranceResultData),
      ),
    );
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
            'School Bus',
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
                        _buildDropdownField('Age of Vehicle', _ageOptions, _selectedAge,
                            (val) => setState(() => _selectedAge = val)),
                        _buildTextField('yearOfManufacture', 'Year of Manufacture', 'Enter Year'),
                        _buildDropdownField('Zone', _zoneOptions, _selectedZone,
                            (val) => setState(() => _selectedZone = val)),
                        _buildTextField('numberOfPassengers', 'No. of Passengers', 'Enter Number'),
                        _buildTextField('discountOnOd', 'Discount On OD Premium (%)', 'Enter Discount'),
                        _buildDropdownField('IMT 23', _imt23Options, _selectedImt23,
                            (val) => setState(() => _selectedImt23 = val), hintText: 'Select Option'),
                        _buildTextField('electricalAccessories', 'Electrical Accessories (₹)', 'Enter Value'),
                        _buildDropdownField('CNG/LPG Kits', _yesNoOptions, _selectedCngLpgKit,
                            (val) => setState(() => _selectedCngLpgKit = val), hintText: 'Select Option'),
                        _buildTextField('externalCngLpgKit', 'Externally Fitted CNG/LPG (₹)', 'Enter Kit Value'),
                        _buildDropdownField('Anti Theft', _yesNoOptions, _selectedAntiTheft,
                            (val) => setState(() => _selectedAntiTheft = val), hintText: 'Select Option'),
                        _buildDropdownField('No Claim Bonus (%)', _ncbOptions, _selectedNcb,
                            (val) => setState(() => _selectedNcb = val), hintText: 'Select Option'),
                        _buildDropdownField('Geographical Extn.', _geographicalExtnOptions, _selectedGeExtn,
                            (val) => setState(() => _selectedGeExtn = val), hintText: 'Select Option'),
                        _buildTextField('rsaAddon', 'RSA/Addons (₹)', 'Enter Amount'),
                        _buildTextField('paOwnerDriver', 'PA to Owner Driver (₹)', 'Enter Amount'),
                        _buildDropdownField('LL to Paid Driver', _llPaidDriverOptions, _selectedLlPaidDriver,
                            (val) => setState(() => _selectedLlPaidDriver = val), hintText: 'Select Option'),
                        _buildDropdownField('LL to Other Employees', _llOtherEmployeeOptions, _selectedLlOtherEmployee,
                            (val) => setState(() => _selectedLlOtherEmployee = val), hintText: 'Select Option'),
                        _buildTextField('otherCess', 'Other Cess (%)', 'Enter Cess %'),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Calculate', style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ),
    );
  }

  Widget _buildTextField(String key, String label, String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label, style: const TextStyle(fontSize: 16))),
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
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              validator: (value) => value == null || value.trim().isEmpty ? 'Enter $label' : null,
            ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label, style: const TextStyle(fontSize: 16))),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: DropdownButtonFormField<String>(
              value: selected,
              items: options.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
              onChanged: onChanged,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              validator: (value) => value == null ? 'Select $label' : null,
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
    if (zone == 'A') return 1.278;
    if (zone == 'B') return 1.310;
    if (zone == 'C') return 1.342;
  } else if (age == '5to10Years') {
    if (zone == 'A') return 1.803;
    if (zone == 'B') return 1.830;
    if (zone == 'C') return 1.874;
  } else if (age == 'Above10Years') {
    // You can adjust as per rates; keeping slightly higher
    if (zone == 'A') return 2.0;
    if (zone == 'B') return 2.05;
    if (zone == 'C') return 2.10;
  }
  return 1.0; // fallback
}

double _getSchoolBusTpRate({required int passengerCount, }) {
  // Official IRDA rates for TP premium - fixed sums
  if (passengerCount <= 6) {
    return 2539.0;
  } else if (passengerCount > 6 && passengerCount <= 17) {
    return 6763.0;
  } else if (passengerCount > 17 && passengerCount <= 26) {
    return 9697.0;
  } else if (passengerCount > 26) {
    return 13725.0;
  }
  return 0.0;
}
