import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motor_insurance_app/models/result_data.dart';
import 'package:motor_insurance_app/screens/vehicle/miscellaneous_vehicle/misc_result_screen.dart';
class HearsesFormScreen extends StatefulWidget {
  const HearsesFormScreen({super.key});

  @override
  State<HearsesFormScreen> createState() => _HearsesFormScreenState();
}

class _HearsesFormScreenState extends State<HearsesFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> _controllers = {
    'idv': TextEditingController(),
    'depreciation': TextEditingController(),
    'currentIdv': TextEditingController(),                              
    'yearOfManufacture': TextEditingController(),     
    'discountOnOd': TextEditingController(),          
    'loading_on_discount_premium': TextEditingController(), 
    'CNG_LPG_kits_Ex_fitted': TextEditingController(),
    'paOwnerDriver': TextEditingController(),
    'll2Passenger': TextEditingController(),
    'otherCess': TextEditingController(),
  };

  String? _selectedAge;
  String? _selectedDepreciation;
  String? _selectedZone;
  String? _selectedCNG;
  String? _selectedNcb;
  String? _selectedImt23;
  String? _selectedLlPaidDriver;
  String? _selectedLlEmployeeOther;
  String? _selectedRestrictedTppd;

    final List<String> _depreciationOptions = [
    '0%',
    '5%',
    '10%',
    '15%',
    '20%',
    '25%',
    '30%',
  ];
  final List<String> _ageOptions = ['Upto 5 Years', '6-10 Years', 'Above 10 Years'];
  final List<String> _zoneOptions = ['A', 'B'];
  final List<String> _cngOptions = ['Yes', 'No'];
  final List<String> _ncbOptions = ['0%', '20%', '25%', '35%', '45%', '50%'];
  final List<String> _imt23Options = ['Yes', 'No'];
  final List<String> _llPaidDriverOptions = ['0', '50'];
  final List<String> _llEmployeeOtherOptions = ['0', '50', '100', '150'];
  final List<String> _restrictedTppdOptions = ['Yes', 'No'];

  // void _updateCurrentIdv() {
  //   double idv = double.tryParse(_controllers['idv']!.text) ?? 0.0;
  //   double depreciation = 0.0;

  //   double currentIdv = idv - ((idv * depreciation) / 100);
  //   _controllers['currentIdv']!.text = currentIdv.toStringAsFixed(2);
  // }

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
    double ageOfVehicle = double.tryParse(_selectedAge ?? '0') ?? 0.0;
    String yearOfManufacture = _controllers['yearOfManufacture']!.text;
    String zone = _selectedZone ?? "A";
    double currentIdv = double.tryParse(_controllers['currentIdv']!.text) ?? 0.0;
    double discountOnOd = double.tryParse(_controllers['discountOnOd']!.text) ?? 0.0;
    double paOwnerDriver = double.tryParse(_controllers['paOwnerDriver']!.text) ?? 0.0;
    double otherCess = double.tryParse(_controllers['otherCess']!.text) ?? 0.0;
    double ll2Passenger = double.tryParse(_controllers['ll2Passenger']!.text) ?? 0.0;
    double CNG_LPG_kits_Ex_fitted = double.tryParse(_controllers['CNG_LPG_kits_Ex_fitted']!.text) ?? 0.0;
    double loadingOnDiscountPremium =double.tryParse(_controllers['loading_on_discount_premium']!.text) ?? 0.0;
    double llPaidDriver = double.tryParse(_selectedLlPaidDriver ?? "0") ?? 0.0;
    double llEmployeeOther = double.tryParse(_selectedLlEmployeeOther ?? "0") ?? 0.0;
    double llToPaidDriver =double.tryParse(_selectedLlPaidDriver ?? "0") ?? 0.0;
    double restrictedTppd = double.tryParse(_selectedRestrictedTppd ?? "0")?? 0.0;
    String selectedNCBText = _selectedNcb ?? "0%";
    double ncbPercentage = double.tryParse(selectedNCBText.replaceAll('%', '')) ?? 0.0;

    // Get base rate from function
    double vehicleBasicRate =
        _getOdRate(zone, ageOfVehicle);

    // OD Calculations
    double basicForVehicle = (currentIdv * vehicleBasicRate) / 100;
    double discountAmount = (basicForVehicle * discountOnOd) / 100;
    double basicOdPremium = currentIdv * vehicleBasicRate / 100;
    double discountOdPremium = (basicOdPremium * discountOnOd) / 100;
    double loadingOdPremium = (basicOdPremium * loadingOnDiscountPremium ) / 100;
    double odBeforeNcb = (basicOdPremium - discountOdPremium) + loadingOdPremium;
    double ncbAmount = (odBeforeNcb * ncbPercentage) / 100;
    double totalA = odBeforeNcb - ncbAmount;


    // TP Section
    double liabilityPremiumTP = _getTpRate();
    double totalB = liabilityPremiumTP +
      paOwnerDriver +
      llPaidDriver+
      llEmployeeOther+
      ll2Passenger;



    // Total Premium (C)
    double totalAB = totalA + totalB;
    double gst = totalAB * 0.18;
    otherCess = (otherCess * totalAB) / 100;
    double finalPremium = totalAB + gst + otherCess;

    // Result Map
    Map<String, String> resultMap = {
      // Basic Details
      "IDV": idv.toStringAsFixed(2),
      "Year of Manufacture": yearOfManufacture.toString(),
      "Zone": zone,

      // A - Own Damage Premium Package
      "Vehicle Basic Rate": vehicleBasicRate.toStringAsFixed(3),
      "Basic for Vehicle": basicForVehicle.toStringAsFixed(2),
      "CNG/LPG kit (Externally Fitted)": CNG_LPG_kits_Ex_fitted.toStringAsFixed(2),
      "IMT23": _selectedImt23 ?? 'No',
      "Basic OD Before Discount": basicOdPremium.toStringAsFixed(2),
      "Discount on OD Premium": discountAmount.toStringAsFixed(2),
      "Loading on OD Premium": loadingOdPremium.toStringAsFixed(2),
      "Basic OD Premium": basicOdPremium.toStringAsFixed(2),
      "No Claim Bonus": ncbAmount.toStringAsFixed(2),
      "Net Own Damage Premium": totalA.toStringAsFixed(2),
      "Total A": totalA.toStringAsFixed(2),

      // B - Liability Premium
      "Basic Liability Premium (TP)": liabilityPremiumTP.toStringAsFixed(2),
      "Restricted TPPD": restrictedTppd.toStringAsFixed(2),
      "CNG/LPG Kit": _selectedCNG ?? 'No',
      "PA to Owner Driver": paOwnerDriver.toStringAsFixed(2),
      "LL to Paid Driver": llToPaidDriver.toStringAsFixed(2),
      "LL to Employee/Other": llEmployeeOther.toStringAsFixed(2),
      "LL to Passenger":ll2Passenger.toStringAsFixed(2),
      "Total B": totalB.toStringAsFixed(2),

      // C - Total Premium
      "Total Package Premium[A+B]": totalAB.toStringAsFixed(2),
      "GST @ 18%": gst.toStringAsFixed(2),
      "Other CESS": otherCess.toStringAsFixed(2),

      // Final Premium
      "Final Premium": finalPremium.toStringAsFixed(2),
    };

    // Pass data to result screen
    InsuranceResultData resultData = InsuranceResultData(
      vehicleType: "Hearses",
      fieldData: resultMap,
      totalPremium: finalPremium,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MiscInsuranceResultScreen(resultData: resultData),
      ),
    );
  }}

  void _resetForm() {
    _formKey.currentState?.reset();
    for (var controller in _controllers.values) {
      controller.clear();
    }
    setState(() {
      _selectedAge = null;
      _selectedZone = null;
      _selectedNcb = null;
      _selectedImt23 = null;
      _selectedLlPaidDriver = null;
      _selectedRestrictedTppd = null;
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
              // SizedBox(width: 8),
              Text(
                'Hearses (Dead Body Carry Vehicle)',
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
                _buildTextField('idv', 'IDV (₹)', 'IDV'),        
                _buildDropdownField(
                  'Depreciation (%)',
                  _depreciationOptions,
                  _selectedDepreciation,
                  (val) {
                    setState(() {
                      _selectedDepreciation = val;
                      _updateCurrentIdv(); // <-- Add this
                    });
                  },
                ),        
                _buildReadOnlyField(
                    'currentIdv', 'Current IDV (₹)'), // Read-only field  
                _buildDropdownField('Age of Vehicle', _ageOptions, _selectedAge,
                    (val) => setState(() => _selectedAge = val)),
                _buildTextField('yearOfManufacture', 'Year of Manufacture','Year of manufacture'),             
                _buildDropdownField('Zone', _zoneOptions, _selectedZone,
                    (val) => setState(() => _selectedZone = val)),                                                           
                _buildTextField('discountOnOd', 'Discount on OD Premium (%)','Discount on OD Premium'),   
                _buildTextField('loading_on_discount_premium', 'Loading on discount premium (%)','Loading on discount premium'),
                _buildDropdownField('CNG/LPG kits', _cngOptions, _selectedCNG,
                    (val) => setState(() => _selectedCNG = val)),                         
                _buildTextField('CNG_LPG_kits_Ex_fitted', 'CNG/LPG kits (externally fitted)','CNG LPG kits (externally fitted)'), 
                _buildDropdownField('IMT 23', _imt23Options, _selectedImt23,
                    (val) => setState(() => _selectedImt23 = val)),
                _buildDropdownField('No Claim Bonus(%)', _ncbOptions, _selectedNcb,
                    (val) => setState(() => _selectedNcb = val)),                  
                _buildTextField('paOwnerDriver', 'PA to Owner Driver (₹)','PA to Owner Driver'),            
                _buildDropdownField('LL to Paid Driver', _llPaidDriverOptions, _selectedLlPaidDriver,
                    (val) => setState(() => _selectedLlPaidDriver = val)),              
                _buildDropdownField('LL to Employee (Other Than Paid Driver)', _llEmployeeOtherOptions, _selectedLlEmployeeOther,
                    (val) => setState(() => _selectedLlEmployeeOther = val)),
                _buildTextField('ll2Passenger', 'LL to passenger (Number of passenger)', 'LL to passenger (Number of passenger)'),
                 _buildDropdownField('Restrcited TPPD', _restrictedTppdOptions, _selectedRestrictedTppd,
                    (val) => setState(() => _selectedRestrictedTppd = val)),
                _buildTextField('otherCess', 'Other Cess (%)', 'Other Cess (%)'),
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
          SizedBox(width: 180, child: Text(label, style: const TextStyle(fontSize: 16))),
          Expanded(
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
      String label, List<String> options, String? selected, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(width: 180, child: Text(label, style: const TextStyle(fontSize: 16))),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: selected,
              items: options.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
              onChanged: onChanged,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              validator: (value) => value == null ? 'Select $label' : null,
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


double _getOdRate(String zone, double age) {
  // These rates are for demonstration purposes, based on typical industry standards.
  // You should verify and use the actual rates from your insurance provider.
  if (zone == 'A') { // Metropolitan areas like Delhi, Mumbai
    if (age <= 5) {
      return 1.208; 
    } else if (age <= 7) {
      return 1.238; 
    } else {
      return 1.268; // (Above 7 yrs)
    }
  } else if (zone == 'B') { // Rest of India
    if (age <= 5) {
      return 1.202;
    } else if (age <= 7) {
      return 1.232; 
    } else {
      return 1.262; // (Above 7 yrs)
    } 
  }else if (zone == 'C') { // Rural areas
      if (age <= 5) {
        return 1.190;
      } else if (age <= 7) {
        return 1.220;
      } else {
        return 1.250; // (Above 7 yrs)
      }
    }
  return 2.5; // Safe fallback rate
}


double _getTpRate() {
  // As per IRDAI, Hearses fall under the "Public Service Vehicles" category
  // or a similar commercial vehicle class. The rate is a fixed amount.
  // This is a representative rate and must be verified with the latest IRDAI circular.
  return 1645; // A fixed rate, for instance, based on vehicles up to 7500 kg GVW.
}