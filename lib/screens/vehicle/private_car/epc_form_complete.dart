import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motor_insurance_app/models/result_data.dart';
import 'package:motor_insurance_app/screens/vehicle/private_car/pc_result_screen.dart';

class EPCFormComplete extends StatefulWidget {
  const EPCFormComplete({
    super.key,
  });

  @override
  State<EPCFormComplete> createState() => _EPCFormCompleteState();
}

class _EPCFormCompleteState extends State<EPCFormComplete> {
  final _formKey = GlobalKey<FormState>();

  // TextEditingControllers
  late Map<String, TextEditingController> _controllers;

  String? _selectedDepreciation;
  String? _selectedAge;
  String? _selectedZone;
  String? _selectedCngLpgKit;
  // String? _selectedGeoExt;
  // String? _selectedFiberGlassTank;
  // String? _selectedDrivingTutions;
  String? _selectedAntiTheft;
  String? _selectedHandicap;
  String? _selectedAAI;
  String? _selectedVoluntaryDeduct;
  String? _selectedNcb;
  String? _selectedLlPaidDriver;
  // String? _selectedRestrictedTppd;

  final List<String> _ageOptions = [
    'Upto 5 Years',
    '6-10 Years',
    'Above 10 Years'
  ];
  final List<String> _zoneOptions = ['A', 'B'];
  final List<String> _cngLpgKitOptions = ['Yes', 'No'];
  // final List<String> _geoExtOptions = ['0', '400'];
  // final List<String> _fiberGlassTankOptions = ['Yes', 'No'];
  // final List<String> _drivingTutionsOptions = ['Yes', 'No'];
  final List<String> _antiTheftOptions = ['Yes', 'No'];
  final List<String> _handicapOptions = ['Yes', 'No'];
  final List<String> _AAIOptions = ['Yes', 'No'];
  final List<String> _voluntaryDeductOptions = [
    '0',
    '2500',
    '5000',
    '7500',
    '15000',
  ];
  final List<String> _ncbOptions = ['0%', '20%', '25%', '35%', '45%', '50%'];
  final List<String> _llPaidDriverOptions = ['0', '50'];
  final List<String> _depreciationOptions = [
    '0%',
    '5%',
    '10%',
    '15%',
    '20%',
    '25%',
    '30%',
  ];

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
      'kwCapacity': TextEditingController(), //7
      'discountOnOd': TextEditingController(), //8
      'loading_on_discount_premium': TextEditingController(), //9
      'electricAccessories': TextEditingController(), //10
      'nonElectricAccessories': TextEditingController(), //11
      // 'CNG_LPG_kits': TextEditingController(), //12  dropdown
      'CNG_LPG_kits_Ex_fitted': TextEditingController(), //13
      'geographicalExt': TextEditingController(), //14  dropdown
      'fiberGlassTank': TextEditingController(), //15
      'drivingTutions': TextEditingController(), //16
      // 'antiTheft': TextEditingController(), //17
      // 'handicap': TextEditingController(), //18
      // 'AAI': TextEditingController(), //19
      // 'voluntaryDeductible': TextEditingController(), //20
      'noClaimBonus': TextEditingController(), //21
      'zeroDepreciation': TextEditingController(), //22
      'RSAaddons': TextEditingController(), //23
      'consumables': TextEditingController(), //24
      'tyreCover': TextEditingController(), //25
      'NCBprotection': TextEditingController(), //26
      'engineProtector': TextEditingController(), //27
      'returnToInvoice': TextEditingController(), //28
      'otherAddonCoverage': TextEditingController(), //29
      'ValueAddedServices': TextEditingController(), //30
      'paOwnerDriver': TextEditingController(), //31
      'llPaidDriver': TextEditingController(), //32
      'paUnnamedPassenger': TextEditingController(), //33
      'otherCess': TextEditingController(), //34
      // 'currentIdv': TextEditingController(),

      /*


    */
      //17
    };
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
      double kwCapacity =
          double.tryParse(_controllers['kwCapacity']!.text) ?? 0.0;
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
      double geographicalExt =
          double.tryParse(_controllers['geographicalExt']!.text) ?? 0.0; //
      double fiberGlassTank =
          double.tryParse(_controllers['fiberGlassTank']!.text) ?? 0.0; //
      double drivingTutions =
          double.tryParse(_controllers['drivingTutions']!.text) ?? 0.0; //

      double zeroDepreciation =
          double.tryParse(_controllers['zeroDepreciation']!.text) ?? 0.0;
      double RSAaddons =
          double.tryParse(_controllers['RSAaddons']!.text) ?? 0.0;
      double consumables =
          double.tryParse(_controllers['consumables']!.text) ?? 0.0;
      double tyreCover =
          double.tryParse(_controllers['tyreCover']!.text) ?? 0.0;
      double NCBprotection =
          double.tryParse(_controllers['NCBprotection']!.text) ?? 0.0;
      double engineProtector =
          double.tryParse(_controllers['engineProtector']!.text) ?? 0.0;
      double returnToInvoice =
          double.tryParse(_controllers['returnToInvoice']!.text) ?? 0.0;
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

      // int cc = int.tryParse(_controllers['cubicCapacity']?.text ?? "") ?? 1000;
      /*int age = (_selectedAge != null && _selectedAge != _ageOptions.last)
          ? int.tryParse(_selectedAge!) ?? 1
          : 6;*/
      String age = _selectedAge ?? 'Upto 5 Years';
      double vehicleBasicRate = getOdRate(
        vehicleAgeYears: age,
        zone: zone,
        cubicCapacity: 0,
        kiloWatt: kwCapacity,
        isElectric: true,
      ); // ODRate

      //values for these Variable
      double basicOD = currentIdv * vehicleBasicRate / 100;
      print(_controllers['currentIdv']!.text);
      print(basicOD);
      double antiTheftValue = _selectedAntiTheft != true
          ? double.parse((min(basicOD * 0.025, 500)).toStringAsFixed(2))
          : 0.0;
      print(antiTheftValue);
      double handicapValue = _selectedHandicap != true ? basicOD * 0.5 : 0.0; //
      print(handicapValue);
      double AAIValue = _selectedAAI != true
          ? double.parse((min(basicOD * 0.05, 200)).toStringAsFixed(2))
          : 0.0;
      print(AAIValue);
      double VoluntaryDeduct =
          double.tryParse(_selectedVoluntaryDeduct ?? "0") ?? 0.0; //

      // OD Calculations
      double basicForVehicle = currentIdv * vehicleBasicRate / 100;
      double discountAmount = (basicForVehicle * discountOnOd) / 100;
      double basicOdAfterDiscount = basicForVehicle - discountAmount;
      basicOdAfterDiscount +=
          (basicOdAfterDiscount * loading_on_discount_premium) / 100;
      double electricAccessoriesValue =
          electricAccessories == 0.0 ? 0.0 : (electricAccessories / 1000) * 40;
      double nonElectricAccessoriesValue = nonElectricAccessories == 0.0
          ? 0.0
          : (nonElectricAccessories / 1000) * 30;
      double accessoriesValue =
          electricAccessoriesValue + nonElectricAccessoriesValue;
      double cngLpgPremium = 0.0;
      if (_cngLpgKitOptions == 'Yes' && CNG_LPG_kits_Ex_fitted > 0) {
        cngLpgPremium = (CNG_LPG_kits_Ex_fitted / 1000) * 60;
      }
      double OptionalExtensions =
          geographicalExt + fiberGlassTank + drivingTutions;
      double TotalDiscounts =
          antiTheftValue + handicapValue + AAIValue + VoluntaryDeduct;
      double totalBasicPremium = (basicOdAfterDiscount +
              accessoriesValue +
              cngLpgPremium +
              OptionalExtensions) -
          TotalDiscounts;
      double ncbAmount = (ncbPercentage / 100) * totalBasicPremium.abs();
      double netOdPremium = totalBasicPremium - ncbAmount;
      double totalA = netOdPremium;

      //Add-ons
      double totalB = zeroDepreciation +
          RSAaddons +
          consumables +
          tyreCover +
          NCBprotection +
          engineProtector +
          returnToInvoice +
          otherAddonCoverage +
          ValueAddedServices;

      // TP Section
      double cngLpgRate = 60;   // change to actual IRDA rate
      double cngLpgKit = _cngLpgKitOptions == 'Yes'?cngLpgRate:0.0;
      int tp_years =
          findTPYear(int.tryParse(_controllers['tp']?.text.trim() ?? "") ?? 1);
      double liabilityPremiumTP = getThirdPartyPremium(
          cubicCapacity: 0,
          isElectric: true,
          batteryKwh: kwCapacity,
          years: tp_years);
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
        "Kilowatt": kwCapacity.toString(),

        // A - Own Damage Premium Package
        "Vehicle Basic Rate": vehicleBasicRate.toStringAsFixed(3),
        "Basic for Vehicle": basicForVehicle.toStringAsFixed(2),
        "Discount on OD Premium": discountAmount.toStringAsFixed(2),
        "Basic OD Premium after discount":
            basicOdAfterDiscount.toStringAsFixed(2),
        "Accessories Value": accessoriesValue.toStringAsFixed(2),
        "Optional Extensions(GeoExt+FiberGT+DrTutions)":
            OptionalExtensions.toStringAsFixed(2), //
        "Total Discounts(AntiTheft+Handicap+AAI+VoluntaryDeduct)":
            TotalDiscounts.toStringAsFixed(2), //
        "Total Basic Premium": totalBasicPremium.toStringAsFixed(2),
        "No Claim Bonus": ncbAmount.toStringAsFixed(2),
        "Net Own Damage Premium": netOdPremium.toStringAsFixed(2),
        "Total A": totalA.toStringAsFixed(2),

        // B - Add-ons
        "Zero Dep Premium": zeroDepreciation.toStringAsFixed(2),
        "RSA": RSAaddons.toStringAsFixed(2),
        "Consumables": consumables.toStringAsFixed(2),
        "Tyre Cover": tyreCover.toStringAsFixed(2),
        "NCB Protection": NCBprotection.toStringAsFixed(2),
        "Engine Protector": engineProtector.toStringAsFixed(2),
        "Return To Invoice": returnToInvoice.toStringAsFixed(2),
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
        vehicleType: "Electric Four Wheeler Complete",
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
    for (var controller in _controllers.values) {
      controller.clear();
    }
    setState(() {
      _selectedZone = null;
      _selectedAAI = null;
      _selectedAge = null;
      _selectedAntiTheft = null;
      _selectedCngLpgKit = null;
      _selectedDepreciation = null;
      _selectedHandicap = null;
      _selectedLlPaidDriver = null;
      _selectedNcb = null;
      _selectedVoluntaryDeduct = null;
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
                'Electric Private Car Complete',
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
                _buildTextField(
                    'kwCapacity', 'Kilowatt', true, "Enter Capacity"),
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
                _buildTextField('geographicalExt', 'Geographical Ext', true,
                    "Enter Value "),
                // _buildDropdownField('Geographical Ext', _geoExtOptions, _selectedGeoExt, (val) => setState(() => _selectedGeoExt = val)),
                _buildTextField(
                    'fiberGlassTank', 'Fiber Glass Tank', true, "Enter Value "),
                // _buildDropdownField('Fiber Glass Tank', _fiberGlassTankOptions, _selectedFiberGlassTank, (val) => setState(() => _selectedFiberGlassTank = val)),
                _buildTextField(
                    'drivingTutions', 'Driving Tutions', true, "Enter Value "),
                // _buildDropdownField('Driving Tutions', _drivingTutionsOptions, _selectedDrivingTutions, (val) => setState(() => _selectedDrivingTutions = val)),
                _buildDropdownField(
                    'Anti Theft',
                    _antiTheftOptions,
                    _selectedAntiTheft,
                    (val) => setState(() => _selectedAntiTheft = val)),
                _buildDropdownField(
                    'Handicap',
                    _handicapOptions,
                    _selectedHandicap,
                    (val) => setState(() => _selectedHandicap = val)),
                _buildDropdownField('AAI', _AAIOptions, _selectedAAI,
                    (val) => setState(() => _selectedAAI = val)),
                _buildDropdownField(
                    'Voluntary Deductible',
                    _voluntaryDeductOptions,
                    _selectedVoluntaryDeduct,
                    (val) => setState(() => _selectedVoluntaryDeduct = val)),
                _buildDropdownField('No Claim Bonus (%)', _ncbOptions,
                    _selectedNcb, (val) => setState(() => _selectedNcb = val)),
                _buildTextField('zeroDepreciation', 'Zero Depreciation (rate)',
                    true, "Enter 1 Yr Rate "),
                _buildTextField(
                    'RSAaddons',
                    'RSA/Additional for Addons(amount)',
                    true,
                    "Enter 1 Yr Amount "),
                _buildTextField('consumables', 'Consumables(rate)', true,
                    "Enter 1 Yr rate "),
                _buildTextField(
                    'tyreCover', 'Tyre Cover(rate)', true, "Enter 1 Yr rate "),
                _buildTextField('NCBprotection', 'NCB Protection(rate)', true,
                    "Enter 1 Yr rate "),
                _buildTextField('engineProtector', 'Engine Protector', true,
                    "Enter 1 Yr Rate "),
                _buildTextField('returnToInvoice', 'Return to Invoice(rate)',
                    true, "Enter 1 Yr Rate "),
                _buildTextField('otherAddonCoverage',
                    'Other Addon Coverage(rate)', true, "Enter 1 Yr Rate "),
                _buildTextField('ValueAddedServices',
                    'Value Added Service(amount)', true, "Enter 1 Yr Amount "),
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
            'Private Car Complete',
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
      'CNG_LPG_kits_Ex_fitted',
      'drivingTutions',
      'geographicalExt',
      'fiberGlassTank',
      'returnToInvoice',
      'engineProtector',
      'NCBprotection',
      'tyreCover',
      'consumables'
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
              //readOnly: key == 'od' || key == 'tp' ? true : false,
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
      'No Claim Bonus (%)', 'Voluntary Deductible', 'AAI', 'Handicap',
      'Anti Theft' // matches label or keyName
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
    if (i == 2 || i == 3) return 3;
    return 5;
  }
}

double getOdRate({
  required String vehicleAgeYears,
  required String zone, // "A" or "B"
  int? cubicCapacity, // For Petrol/Diesel
  double? kiloWatt, // For Electric Vehicle
  required bool isElectric,
}) {
  // Petrol/Diesel rate table (CC based)
  Map<String, Map<String, List<double>>> rateTableCC = {
    "A": {
      "<=1000": [3.127, 3.283, 3.362],
      "1001-1500": [3.283, 3.447, 3.529],
      ">1500": [3.440, 3.612, 3.698],
    },
    "B": {
      "<=1000": [3.039, 3.191, 3.267],
      "1001-1500": [3.191, 3.351, 3.430],
      ">1500": [3.343, 3.510, 3.594],
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
      "<=30": [3.039, 3.191, 3.267],
      "31-65": [3.191, 3.351, 3.430],
      ">65": [3.343, 3.510, 3.594],
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
  print("Years: ${years}, Kilowatt: ${batteryKwh}");
  // Fallback if CC missing
  int cc = (cubicCapacity == null || cubicCapacity <= 0) ? 1200 : cubicCapacity;

  // ---- IRDAI Rate Tables ----
  // All values are examples — replace with latest IRDAI rates before production

  // Petrol/Diesel/Hybrid/CNG cars
  const Map<int, Map<String, double>> fuelRates = {
    1: {"upto1000": 2094.0, "1001to1500": 3416.0, "above1500": 7897.0},
    3: {"upto1000": 6010.0, "1001to1500": 9841.0, "above1500": 22411.0},
    5: {"upto1000": 7896.0, "1001to1500": 12890.0, "above1500": 29340.0}
  };

  // Electric Vehicles (battery capacity in kWh)
  const Map<int, Map<String, double>> evRates = {
    1: {"upto30": 1780.0, "31to65": 2904.0, "above65": 6712.0},
    3: {"upto30": 5543.0, "31to65": 9044.0, "above65": 20907.0},
    5: {
      "upto30": 7500.0, // example placeholder
      "31to65": 12500.0, // example placeholder
      "above65": 28000.0 // example placeholder
    }
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
