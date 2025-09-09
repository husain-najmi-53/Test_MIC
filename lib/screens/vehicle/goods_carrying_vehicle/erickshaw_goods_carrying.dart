import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motor_insurance_app/screens/vehicle/goods_carrying_vehicle/gcv_result_screen.dart';
import 'package:motor_insurance_app/models/result_data.dart';

class ERickshawGoodsScreen extends StatefulWidget {
  const ERickshawGoodsScreen({super.key});

  @override
  State<ERickshawGoodsScreen> createState() => _ERickshawGoodsScreenState();
}

class _ERickshawGoodsScreenState extends State<ERickshawGoodsScreen> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> _controllers = {
    'idv': TextEditingController(),
    'lastYearIdv': TextEditingController(),
    'yearOfManufacture': TextEditingController(),
    'discountOnOd': TextEditingController(),
    'loadingOnDiscount': TextEditingController(),
    'electricalAccessories': TextEditingController(),
    'valueAddedService': TextEditingController(),
    'paOwnerDriver': TextEditingController(),
    'otherCess': TextEditingController(),
  };

  String? _selectedAge;
  String? _selectedZone;
  String? _selectedImt23;
  String? _selectedNcb;
  String? _selectedLlPaidDriver;
  String? _selectedRestrictedTppd;
  String? _selectedDepreciation;

  final List<String> _ageOptions = [
    'Upto 5 Years',
    '6 to 7 Years',
    'Above 7 Years'
  ];
  final List<String> _zoneOptions = ['A', 'B', 'C'];
  final List<String> _yesNoOptions = ['Yes', 'No'];
  final List<String> _ncbOptions = ['0%', '20%', '25%', '35%', '45%', '50%'];
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
    _controllers['lastYearIdv']!.addListener(_updateIdv);
    // Auto-select LL to Paid Driver to 50
    _selectedLlPaidDriver = '50';
  }

  void _updateIdv() {
    double lastYearIdv =
        double.tryParse(_controllers['lastYearIdv']!.text) ?? 0.0;
    double depreciation = 0.0;

    if (_selectedDepreciation != null) {
      depreciation =
          double.tryParse(_selectedDepreciation!.replaceAll('%', '')) ?? 0.0;
    }

    double calculatedIdv = lastYearIdv - ((lastYearIdv * depreciation) / 100);
    _controllers['idv']!.text =
        calculatedIdv > 0 ? calculatedIdv.toStringAsFixed(2) : '';
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      double idv = double.tryParse(_controllers['idv']!.text) ?? 0.0;
      String year = _controllers['yearOfManufacture']!.text;
      String zone = _selectedZone ?? 'A';
      String age = _selectedAge ?? 'Upto 5 Years';
      double discount =
          double.tryParse(_controllers['discountOnOd']!.text) ?? 0.0;
      double loadingOnDiscount =
          double.tryParse(_controllers['loadingOnDiscount']!.text) ?? 0.0;
      double electricalAcc =
          double.tryParse(_controllers['electricalAccessories']!.text) ?? 0.0;
      double valueAddedService =
          double.tryParse(_controllers['valueAddedService']!.text) ?? 0.0;
      double paOwnerDriver =
          double.tryParse(_controllers['paOwnerDriver']!.text) ?? 0.0;
      double otherCess =
          double.tryParse(_controllers['otherCess']!.text) ?? 0.0;
      double ncb =
          double.tryParse((_selectedNcb ?? '0%').replaceAll('%', '')) ?? 0.0;

      double imt23Percent = _selectedImt23 == 'Yes' ? 15.0 : 0.0;
      double restrictedTppdAmt = _selectedRestrictedTppd == 'Yes' ? 200.0 : 0.0;
      double llPaidDriverAmt =
          (_selectedLlPaidDriver != null && _selectedLlPaidDriver != '0')
              ? double.tryParse(_selectedLlPaidDriver!) ?? 0.0
              : 0.0;

      double electricAccessoriesVal = electricalAcc * 0.04;
      double basicRate = _getERickshawOdRate(zone, age);
      double basicOd = (idv * basicRate) / 100;
      double BasicOdPremium = basicOd + electricAccessoriesVal;
      double imt23Amt = (BasicOdPremium * imt23Percent) / 100;
      double odBeforeDiscount = BasicOdPremium + imt23Amt;
      double discountAmt = (odBeforeDiscount * discount) / 100;

      //double odAfterDiscount = odBeforeDiscount - discountAmt;

      double loadingAmt = (odBeforeDiscount * loadingOnDiscount) / 100;
      double odBeforeNcb = odBeforeDiscount - discountAmt + loadingAmt;
      double ncbAmt = (odBeforeNcb * ncb) / 100;
      double netOdPremium = odBeforeNcb - ncbAmt;
      double TotalA = netOdPremium;
      double basicTp = 3139.00;
      double totalTp =
          basicTp + paOwnerDriver + llPaidDriverAmt - restrictedTppdAmt;

      double totalAB = netOdPremium + valueAddedService + totalTp;
      double gst = TotalA * 0.18;
      double otherCessAmt = (totalAB * otherCess) / 100;
      double finalPremium = totalAB + gst + otherCessAmt;

      Map<String, String> resultMap = {
        "IDV": idv.toStringAsFixed(2),
        "Year of Manufacture": year,
        "Zone": zone,
        "Vehicle Basic rate": basicRate.toStringAsFixed(3),
        "Basic for Vehicle": basicOd.toStringAsFixed(2),
        "Electrical Accessories": electricAccessoriesVal.toStringAsFixed(2),
        "IMT 23": imt23Amt.toStringAsFixed(2),
        "OD Before Discount": odBeforeDiscount.toStringAsFixed(2),
        "Discount on OD Premium": discountAmt.toStringAsFixed(2),
        //"OD After Discount": odAfterDiscount.toStringAsFixed(2),
        "Loading on Discount": loadingAmt.toStringAsFixed(2),
        "OD Before NCB": odBeforeNcb.toStringAsFixed(2),
        "NCB": ncbAmt.toStringAsFixed(2),
        "Net OD Premium": netOdPremium.toStringAsFixed(2),
        "Basic TP": basicTp.toStringAsFixed(2),
        "Value Added Service": valueAddedService.toStringAsFixed(2),
        "Total Addon Premium:": valueAddedService.toStringAsFixed(2),
        "PA Owner Driver": paOwnerDriver.toStringAsFixed(2),
        "LL to Paid Driver": llPaidDriverAmt.toStringAsFixed(2),
        "Restricted TPPD": restrictedTppdAmt.toStringAsFixed(2),
        "Total TP Premium": totalTp.toStringAsFixed(2),
        "Total Premium (OD+TP)": totalAB.toStringAsFixed(2),
        "GST (18%)": gst.toStringAsFixed(2),
        "Other Cess": otherCessAmt.toStringAsFixed(2),
        "Final Premium": finalPremium.toStringAsFixed(2),
      };

      InsuranceResultData resultData = InsuranceResultData(
        vehicleType: "E-Rickshaw Goods Carrying",
        fieldData: resultMap,
        totalPremium: finalPremium,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              GcvInsuranceResultScreen(resultData: resultData),
        ),
      );
    }
  }

  double _getERickshawOdRate(String zone, String age) {
    if (zone == 'A') {
      if (age == 'Upto 5 Years') return 1.664;
      if (age == '6 to 7 Years') return 1.706;
      if (age == 'Above 7 Years') return 1.747;
    } else if (zone == 'B') {
      if (age == 'Upto 5 Years') return 1.656;
      if (age == '6 to 7 Years') return 1.697;
      if (age == 'Above 7 Years') return 1.739;
    } else if (zone == 'C') {
      if (age == 'Upto 5 Years') return 1.640;
      if (age == '6 to 7 Years') return 1.681;
      if (age == 'Above 7 Years') return 1.722;
    }
    return 0.00; // fallback
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
      _selectedNcb = null;
      _selectedLlPaidDriver = null;
      _selectedRestrictedTppd = null;
      _selectedDepreciation = null;
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
              SizedBox(width: 8),
              Text(
                'E-Rickshaw Goods Carrying',
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
                _buildTextField(
                    'lastYearIdv', 'Last Year IDV (₹)', 'Enter IDV'),
                _buildDropdownField('Depreciation (%)', _depreciationOptions,
                    _selectedDepreciation, (val) {
                  setState(() {
                    _selectedDepreciation = val;
                    _updateIdv();
                  });
                }),
                _buildTextField('idv', 'IDV (₹)', '', enabled: false),
                _buildDropdownField('Age of Vehicle', _ageOptions, _selectedAge,
                    (val) => setState(() => _selectedAge = val)),
                _buildTextField(
                    'yearOfManufacture', 'Year of Manufacture', 'Enter Year'),
                _buildDropdownField('Zone', _zoneOptions, _selectedZone,
                    (val) => setState(() => _selectedZone = val)),
                _buildTextField('discountOnOd', 'Discount on OD Premium (%)',
                    'Enter Discount'),
                _buildTextField('loadingOnDiscount',
                    'Loading on Discount Premium (%)', 'Enter Loading'),
                _buildTextField('electricalAccessories',
                    'Electrical Accessories (₹)', 'Enter Value'),
                _buildDropdownField('IMT 23', _yesNoOptions, _selectedImt23,
                    (val) => setState(() => _selectedImt23 = val)),
                _buildDropdownField('No Claim Bonus (%)', _ncbOptions,
                    _selectedNcb, (val) => setState(() => _selectedNcb = val)),
                _buildTextField('valueAddedService', 'Value Added Service (₹)',
                    'Enter Amount'),
                _buildTextField(
                    'paOwnerDriver', 'PA to Owner Driver (₹)', 'Enter Amount'),
                _buildDropdownField(
                    'LL to Paid Driver',
                    _llPaidDriverOptions,
                    _selectedLlPaidDriver,
                    (val) => setState(() => _selectedLlPaidDriver = val)),
                _buildDropdownField(
                    'Restricted TPPD',
                    _yesNoOptions,
                    _selectedRestrictedTppd,
                    (val) => setState(() => _selectedRestrictedTppd = val)),
                _buildTextField('otherCess', 'Other CESS (%)', 'Enter Cess %'),
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

// _buildDropdownField with optional handling
  Widget _buildTextField(String key, String label, String placeholder,
      {bool enabled = true}) {
    const optionalFields = [
      'electricalAccessories',
      'externalCngLpgKit',
      'zeroDepreciation',
      'rsaAmount',
      'paOwnerDriver',
      'otherCess',
      'discountOnOd',
      'valueAddedService',
      'loadingOnDiscount'
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
              controller: _controllers[key],
              enabled: enabled,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: placeholder,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: enabled
                  ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
                  : [],
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

                return null; // ✅ Always return null if valid
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> options,
      String? selected, Function(String?) onChanged) {
    const optionalDropdowns = [
      'LL to Paid Driver',
      'IMT 23',
      'Geographical Extn.',
      'Anti Theft',
      'No Claim Bonus (%)',
      'LL to Paid Driver',
      'LL to Employee Other than paid Driver',
      'CNG/LPG Kits',
      'Restricted TPPD'
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
                if (optionalDropdowns.contains(label)) return null;

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
