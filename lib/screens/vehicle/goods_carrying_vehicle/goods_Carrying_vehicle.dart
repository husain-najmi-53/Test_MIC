import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motor_insurance_app/screens/vehicle/goods_carrying_vehicle/gcv_result_screen.dart';
import 'package:motor_insurance_app/models/result_data.dart';

class GoodsCarryingVehicleScreen extends StatefulWidget {
  const GoodsCarryingVehicleScreen({super.key});

  @override
  State<GoodsCarryingVehicleScreen> createState() =>
      _GoodsCarryingVehicleScreenState();
}

class _GoodsCarryingVehicleScreenState
    extends State<GoodsCarryingVehicleScreen> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> _controllers = {
    'idv': TextEditingController(),
    'lastYearIdv': TextEditingController(),
    'yearOfManufacture': TextEditingController(),
    'grossVehicleWeight': TextEditingController(),
    'discountOnOd': TextEditingController(),
    'electricalAccessories': TextEditingController(),
    'externalCngLpgKit': TextEditingController(),
    'zeroDepreciation': TextEditingController(),
    'rsaAmount': TextEditingController(),
    'paOwnerDriver': TextEditingController(),
    'otherCess': TextEditingController(),
  };

  String? _selectedDepreciation;
  String? _selectedAge;
  String? _selectedZone;
  String? _selectedCngLpgKit;
  String? _selectedImt23;
  String? _selectedGeographicalExtn;
  String? _selectedAntiTheft;
  String? _selectedNcb;
  String? _selectedLlPaidDriver;
  String? _selectedLlOtherEmployee;
  String? _selectedRestrictedTppd;

  final List<String> _ageOptions = [
    'Upto 5 Years',
    '6 to 7 Years',
    'Above 7 Years'
  ];
  final List<String> _zoneOptions = ['A', 'B', 'C'];
  final List<String> _yesNoOptions = ['Yes', 'No'];
  final List<String> _ncbOptions = ['0%', '20%', '25%', '35%', '45%', '50%'];
  final List<String> _geoExtnOptions = ['0', '400'];
  final List<String> _llPaidDriverOptions = ['0', '50'];
  final List<String> _llOtherEmpOptions = [
    '0',
    '50',
    '100',
    '150',
    '200',
    '250',
    '300',
    '350'
  ];
  final List<String> _restrictedTppdOptions = ['Yes', 'No'];
  final List<String> _depreciationOptions = [
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
    _controllers['lastYearIdv']!.addListener(_calculateIdv);
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _calculateIdv() {
    double lastYearIdv =
        double.tryParse(_controllers['lastYearIdv']!.text) ?? 0.0;
    double depreciationPercent = 0.0;
    if (_selectedDepreciation != null) {
      depreciationPercent =
          double.tryParse(_selectedDepreciation!.replaceAll('%', '')) ?? 0.0;
    }
    double currentIdv = lastYearIdv * (1 - depreciationPercent / 100);
    setState(() {
      _controllers['idv']!.text =
          currentIdv > 0 ? currentIdv.toStringAsFixed(2) : '';
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      double idv = double.tryParse(_controllers['idv']!.text) ?? 0.0;
      String year = _controllers['yearOfManufacture']!.text;
      String zone = _selectedZone ?? 'A';
      String age = _selectedAge ?? 'Upto 5 Years';
      int gvw = int.tryParse(_controllers['grossVehicleWeight']!.text) ?? 0;
      double discount =
          double.tryParse(_controllers['discountOnOd']!.text) ?? 0.0;
      double electricalAccessories =
          double.tryParse(_controllers['electricalAccessories']!.text) ?? 0.0;
      double externalCngLpgKit =
          double.tryParse(_controllers['externalCngLpgKit']!.text) ?? 0.0;
      double zeroDep =
          double.tryParse(_controllers['zeroDepreciation']!.text) ?? 0.0;
      double rsaAmount =
          double.tryParse(_controllers['rsaAmount']!.text) ?? 0.0;
      double paOwnerDriver =
          double.tryParse(_controllers['paOwnerDriver']!.text) ?? 0.0;
      double otherCess =
          double.tryParse(_controllers['otherCess']!.text) ?? 0.0;
      double ncb =
          double.tryParse((_selectedNcb ?? '0%').replaceAll('%', '')) ?? 0.0;

      double geoExtAmt =
          (int.tryParse(_selectedGeographicalExtn ?? '0') == 0) ? 0.0 : 400;
      double imt23Amt = _selectedImt23 == 'Yes' ? 200.0 : 0.0;
      double antiTheftAmt = _selectedAntiTheft == 'Yes' ? -200.0 : 0.0;
      double restrictedTppdAmt =
          _selectedRestrictedTppd == 'Yes' ? -100.0 : 0.0;
      double llPaidDriverAmt = _selectedLlPaidDriver == 0 ? 0.0 : 50;
      double llOtherEmpAmt =
          double.tryParse(_selectedLlOtherEmployee ?? '0') ?? 0.0;
      double cngTpAmt = _selectedCngLpgKit == 'Yes' ? 60.0 : 0.0;

      double basicRate = _getOdRate(zone, age, gvw);

      double basicForVehicle = (idv * basicRate) / 100;
      double basicOdBeforeDiscount = basicForVehicle +
          electricalAccessories +
          externalCngLpgKit +
          geoExtAmt +
          imt23Amt +
          antiTheftAmt;
      double discountAmt = (basicOdBeforeDiscount * discount) / 100;
      double basicOdBeforeNcb = basicOdBeforeDiscount - discountAmt;
      double ncbAmt = (basicOdBeforeNcb * ncb) / 100;
      double netOdPremium = basicOdBeforeNcb - ncbAmt;
      double totalA = netOdPremium;

      double totalB = zeroDep + rsaAmount;

      double basicTp = _getTpRate(gvw);

      double totalC = basicTp +
          restrictedTppdAmt +
          cngTpAmt +
          geoExtAmt +
          paOwnerDriver +
          llPaidDriverAmt +
          llOtherEmpAmt;

      double totalABC = totalA + totalB + totalC;
      double gst = totalABC * 0.18;
      double otherCessAmt = (totalABC * otherCess) / 100;
      double finalPremium = totalABC + gst + otherCessAmt;

      Map<String, String> resultMap = {
        "IDV": idv.toStringAsFixed(2),
        "Year of Manufacture": year,
        "Zone": zone,
        "Gross Vehicle Weight": gvw.toString(),
        "Vehicle Basic Rate": basicRate.toStringAsFixed(2),
        "Basic for Vehicle": basicForVehicle.toStringAsFixed(2),
        "Electrical Accessories": electricalAccessories.toStringAsFixed(2),
        "CNG/LPG Kits": externalCngLpgKit.toStringAsFixed(2),
        "Geographical Ext": geoExtAmt.toStringAsFixed(2),
        "IMT 23": imt23Amt.toStringAsFixed(2),
        "Anti-Theft": antiTheftAmt.toStringAsFixed(2),
        "Basic OD before Discount": basicOdBeforeDiscount.toStringAsFixed(2),
        "Discount on OD": discountAmt.toStringAsFixed(2),
        "Basic OD before NCB": basicOdBeforeNcb.toStringAsFixed(2),
        "NCB": ncbAmt.toStringAsFixed(2),
        "Net Own Damage Premium (A)": totalA.toStringAsFixed(2),
        "Zero Depreciation": zeroDep.toStringAsFixed(2),
        "RSA": rsaAmount.toStringAsFixed(2),
        "Total Addon Premium (B)": totalB.toStringAsFixed(2),
        "Basic Liability Premium (TP)": basicTp.toStringAsFixed(2),
        "Restricted TPPD": restrictedTppdAmt.toStringAsFixed(2),
        "CNG/LPG Kit (TP)": cngTpAmt.toStringAsFixed(2),
        "Geographical Ext (TP)": geoExtAmt.toStringAsFixed(2),
        "PA to Owner Driver": paOwnerDriver.toStringAsFixed(2),
        "LL to Paid Driver": llPaidDriverAmt.toStringAsFixed(2),
        "LL to Other Employee": llOtherEmpAmt.toStringAsFixed(2),
        "Total Liability Premium (C)": totalC.toStringAsFixed(2),
        "Total Premium (A+B+C)": totalABC.toStringAsFixed(2),
        "GST (18%)": gst.toStringAsFixed(2),
        "Other CESS": otherCessAmt.toStringAsFixed(2),
        "Final Premium": finalPremium.toStringAsFixed(2),
      };

      InsuranceResultData resultData = InsuranceResultData(
        vehicleType: "Goods Carrying Vehicle",
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

  void _resetForm() {
    _formKey.currentState?.reset();
    for (var controller in _controllers.values) {
      controller.clear();
    }
    setState(() {
      _selectedAge = null;
      _selectedZone = null;
      _selectedNcb = null;
      _selectedLlPaidDriver = null;
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
                'Goods Carrying Vehicle',
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
                    _calculateIdv();
                  });
                }),
                _buildTextField('idv', 'IDV (₹)', 'Auto-calculated',
                    readOnly: true),
                _buildDropdownField('Age of Vehicle', _ageOptions, _selectedAge,
                    (val) => setState(() => _selectedAge = val)),
                _buildTextField(
                    'yearOfManufacture', 'Year of Manufacture', 'Enter Year'),
                _buildDropdownField('Zone', _zoneOptions, _selectedZone,
                    (val) => setState(() => _selectedZone = val)),
                _buildTextField('grossVehicleWeight',
                    'Gross Vehicle Weight (kg)', 'Enter Weight'),
                _buildTextField('discountOnOd', 'Discount on OD Premium (%)',
                    'Enter Discount'),
                _buildTextField('electricalAccessories',
                    'Electrical Accessories (₹)', 'Enter Value'),
                _buildDropdownField(
                    'CNG/LPG Kits',
                    _yesNoOptions,
                    _selectedCngLpgKit,
                    (val) => setState(() => _selectedCngLpgKit = val)),
                _buildTextField('externalCngLpgKit',
                    'Externally Fitted CNG/LPG (₹)', 'Enter Kit Value'),
                _buildDropdownField('IMT 23', _yesNoOptions, _selectedImt23,
                    (val) => setState(() => _selectedImt23 = val)),
                _buildDropdownField(
                    'Geographical Extn.',
                    _geoExtnOptions,
                    _selectedGeographicalExtn,
                    (val) => setState(() => _selectedGeographicalExtn = val)),
                _buildDropdownField(
                    'Anti Theft',
                    _yesNoOptions,
                    _selectedAntiTheft,
                    (val) => setState(() => _selectedAntiTheft = val)),
                _buildDropdownField('No Claim Bonus (%)', _ncbOptions,
                    _selectedNcb, (val) => setState(() => _selectedNcb = val)),
                _buildTextField(
                    'zeroDepreciation', 'Zero Depreciation (%)', 'Enter Rate'),
                _buildTextField('rsaAmount', 'RSA/Additional for Addons (₹)',
                    'Enter Amount'),
                _buildTextField(
                    'paOwnerDriver', 'PA to Owner Driver (₹)', 'Enter Amount'),
                _buildDropdownField(
                    'LL to Paid Driver',
                    _llPaidDriverOptions,
                    _selectedLlPaidDriver,
                    (val) => setState(() => _selectedLlPaidDriver = val)),
                _buildDropdownField(
                    'LL to Employee Other than paid Driver',
                    _llOtherEmpOptions,
                    _selectedLlOtherEmployee,
                    (val) => setState(() => _selectedLlOtherEmployee = val)),
                _buildDropdownField(
                    'Restricted TPPD',
                    _restrictedTppdOptions,
                    _selectedRestrictedTppd,
                    (val) => setState(() => _selectedRestrictedTppd = val)),
                _buildTextField('otherCess', 'Other Cess (%)', 'Enter Cess %'),
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

  Widget _buildTextField(String key, String label, String placeholder,
      {bool readOnly = false}) {
    const optionalFields = [
      'electricalAccessories',
      'externalCngLpgKit',
      'zeroDepreciation',
      'rsaAmount',
      'paOwnerDriver',
      'otherCess',
      'discountOnOd'
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
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: placeholder,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: readOnly
                    ? []
                    : [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                validator: (value) {
                  if (optionalFields.contains(key)) return null;

                  // Required validation
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter $label';
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> options,
      String? selected, Function(String?) onChanged) {
    String? keyName;
    const optionalDropdowns = [
      'LL to Paid Driver', 'IMT 23',
      'Geographical Extn.', 'Anti Theft',
      'No Claim Bonus (%)', 'LL to Paid Driver',
      'LL to Employee Other than paid Driver',
      'CNG/LPG Kits',
      'Restricted TPPD' // matches label or keyName
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

double _getOdRate(String zone, String age, int gvw) {
  if (zone == 'A') {
    if (gvw < 7500) {
      if (age == 'Upto 5 Years') return 3.0;
      if (age == '6-10 Years') return 3.5;
      return 4.0;
    } else if (gvw < 12000) {
      if (age == 'Upto 5 Years') return 3.5;
      if (age == '6-10 Years') return 4.0;
      return 4.5;
    } else {
      if (age == 'Upto 5 Years') return 4.0;
      if (age == '6-10 Years') return 4.5;
      return 5.0;
    }
  } else if (zone == 'B') {
    if (gvw < 7500) {
      if (age == 'Upto 5 Years') return 2.8;
      if (age == '6-10 Years') return 3.3;
      return 3.8;
    } else if (gvw < 12000) {
      if (age == 'Upto 5 Years') return 3.3;
      if (age == '6-10 Years') return 3.8;
      return 4.3;
    } else {
      if (age == 'Upto 5 Years') return 3.8;
      if (age == '6-10 Years') return 4.3;
      return 4.8;
    }
  }
  return 3.5; // Safe fallback
}

double _getTpRate(int gvw) {
  if (gvw <= 7500) return 16049;
  if (gvw <= 12000) return 27186;
  if (gvw <= 20000) return 35313;
  if (gvw <= 40000) return 43950;
  return 44242;
}
