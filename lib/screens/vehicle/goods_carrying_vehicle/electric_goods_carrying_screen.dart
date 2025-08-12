import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motor_insurance_app/screens/vehicle/goods_carrying_vehicle/gcv_result_screen.dart';import 'package:motor_insurance_app/models/result_data.dart';

class ElectricGoodsCarryingScreen extends StatefulWidget {
  const ElectricGoodsCarryingScreen({super.key});

  @override
  State<ElectricGoodsCarryingScreen> createState() =>
      _ElectricGoodsCarryingScreenState();
}

class _ElectricGoodsCarryingScreenState
    extends State<ElectricGoodsCarryingScreen> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> _controllers = {
    'lastYearIdv': TextEditingController(),
    'idv': TextEditingController(),
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
  String? _selectedDepreciation;

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
    // Auto-update Current IDV whenever Last Year IDV changes
    _controllers['lastYearIdv']!.addListener(_updateCurrentIdv);
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateCurrentIdv() {
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
    double rsaAmount = double.tryParse(_controllers['rsaAmount']!.text) ?? 0.0;
    double paOwnerDriver =
        double.tryParse(_controllers['paOwnerDriver']!.text) ?? 0.0;
    double otherCess = double.tryParse(_controllers['otherCess']!.text) ?? 0.0;
    double ncb =
        double.tryParse((_selectedNcb ?? '0%').replaceAll('%', '')) ?? 0.0;

    // Optional Add-ons
    double geoExtAmt = _selectedGeographicalExtn == '0' ? 0.0 : 50;
    double imt23Amt = _selectedImt23 == 'Yes' ? 200.0 : 0.0;
    double antiTheftAmt = _selectedAntiTheft == 'Yes' ? -200.0 : 0.0;
    double restrictedTppdAmt = _selectedRestrictedTppd == 'Yes' ? -100.0 : 0.0;
    double llPaidDriverAmt =
        double.tryParse(_selectedLlPaidDriver ?? '0') ?? 0.0;
    double llOtherEmpAmt =
        double.tryParse(_selectedLlOtherEmployee ?? '0') ?? 0.0;
    double cngTpAmt = _selectedCngLpgKit == 'Yes' ? 60.0 : 0.0;

    // --- OD Calculation (A) ---
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

    // --- Add-on Coverage (B) ---
    double totalB = zeroDep + rsaAmount;

    // --- TP Calculation (C) ---
    double basicTp = 12000.0;
    double totalC = basicTp +
        restrictedTppdAmt +
        cngTpAmt +
        geoExtAmt +
        paOwnerDriver +
        llPaidDriverAmt +
        llOtherEmpAmt;

    // --- Final ---
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
      vehicleType: "Electric Goods Carrying",
      fieldData: resultMap,
      totalPremium: finalPremium,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GcvInsuranceResultScreen(resultData: resultData),
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
      _selectedCngLpgKit = null;
      _selectedImt23 = null;
      _selectedGeographicalExtn = null;
      _selectedAntiTheft = null;
      _selectedNcb = null;
      _selectedLlPaidDriver = null;
      _selectedLlOtherEmployee = null;
      _selectedRestrictedTppd = null;
      _selectedDepreciation = null;
      _controllers['idv']!.text = '';
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
                'Electric goods Carrying Vehicle',
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
                    'lastYearIdv', 'Last Year IDV (₹)', 'Enter Last Year IDV'),
                _buildDropdownField(
                    'Depreciation', _depreciationOptions, _selectedDepreciation,
                    (val) {
                  setState(() {
                    _selectedDepreciation = val;
                    _updateCurrentIdv();
                  });
                }),
                _buildTextField('idv', 'Current IDV (₹)', '',
                    enabled: false), // readonly current IDV
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
                // const SizedBox(height: 80),
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
      {bool enabled = true}) {
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
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: placeholder,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
              ],
              validator: (value) =>
                  (value == null || value.trim().isEmpty) && enabled
                      ? 'Enter $label'
                      : null,
              // enabled: enabled,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> options,
      String? selected, Function(String?) onChanged,
      {String placeholder = 'Select Option'}) {
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
              hint: Text(placeholder),
            ),
          ),
        ],
      ),
    );
  }
}

// IRDA OD rate table for Electric Goods Carrying Vehicle

double _getOdRate(String zone, String age, int gvw) {
  // IRDAI OD Rates for Goods Carrying Vehicles - Public/Private (Approx 2024–25)
  // GVW slabs: < 7500 kg, 7501–12000 kg, > 12000 kg

  if (zone == 'A') {
    if (gvw <= 7500) {
      if (age == 'Upto 5 Years') return 3.038; // %
      if (age == '6 to 7 Years') return 3.180;
      return 3.320; // Above 7 Years
    } else if (gvw <= 12000) {
      if (age == 'Upto 5 Years') return 3.156;
      if (age == '6 to 7 Years') return 3.300;
      return 3.442;
    } else {
      if (age == 'Upto 5 Years') return 3.274;
      if (age == '6 to 7 Years') return 3.420;
      return 3.564;
    }
  } else if (zone == 'B') {
    if (gvw <= 7500) {
      if (age == 'Upto 5 Years') return 2.903;
      if (age == '6 to 7 Years') return 3.045;
      return 3.187;
    } else if (gvw <= 12000) {
      if (age == 'Upto 5 Years') return 3.021;
      if (age == '6 to 7 Years') return 3.165;
      return 3.307;
    } else {
      if (age == 'Upto 5 Years') return 3.139;
      if (age == '6 to 7 Years') return 3.285;
      return 3.427;
    }
  }

  return 3.0; // fallback
}
