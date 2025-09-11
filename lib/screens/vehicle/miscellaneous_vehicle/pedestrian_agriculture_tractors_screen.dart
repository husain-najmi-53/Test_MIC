import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motor_insurance_app/models/result_data.dart';
import 'package:motor_insurance_app/screens/vehicle/miscellaneous_vehicle/misc_result_screen.dart';


class AgricultureTractorFormScreen extends StatefulWidget {
  const AgricultureTractorFormScreen({super.key});

  @override
  State<AgricultureTractorFormScreen> createState() =>
      _AgricultureTractorFormScreenState();
}

class _AgricultureTractorFormScreenState
    extends State<AgricultureTractorFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> _controllers = {
      'idv': TextEditingController(),      
      'depreciation': TextEditingController(),  
      'currentIdv': TextEditingController(),       
      'yearOfManufacture': TextEditingController(), 
      'discountOnOd': TextEditingController(),     
      'loadingOnDiscountPremium': TextEditingController(),
      'cngLpgKitsExFitted': TextEditingController(),    
      // 'valueAddedServices': TextEditingController(),   
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
  String? _selectedLlEmployeePaidDriver;
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
  final List<String> _ageOptions = ['Upto 5 Years', '6-7 Years', 'Above 7 Years'];
  final List<String> _zoneOptions = ['A', 'B', 'C'];
  final List<String> _cngOptions = ['Yes', 'No'];
  final List<String> _ncbOptions = ['0%', '20%', '25%', '35%', '45%', '50%'];
  final List<String> _imt23Options = ['Yes', 'No'];
  final List<String> _llPaidDriverOptions = ['0', '50'];
  final List<String> _llEmployeePaidDriverOptions = ['0','50','100','150'];
  final List<String> _restrictedTppdOptions = ['Yes', 'No'];

  @override
  void initState() {
    super.initState();
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
    // double idv = double.tryParse(_controllers['idv']!.text) ?? 0.0;
    double currentIdv = double.tryParse(_controllers['currentIdv']!.text) ?? 0.0;
    String yearOfManufacture = _controllers['yearOfManufacture']!.text;
    String zone = _selectedZone ?? "A";
    //double selectedCNG = (_selectedCNG?.toLowerCase() == 'yes') ? 60.0 : 0.0;   // change the cng/ppg rate once confirmed from clinet
    double discountOnOd = double.tryParse(_controllers['discountOnOd']!.text) ?? 0.0;
    double paOwnerDriver = double.tryParse(_controllers['paOwnerDriver']!.text) ?? 0.0;
    double otherCess = double.tryParse(_controllers['otherCess']!.text) ?? 0.0;
    double cngKitExternal = double.tryParse(_controllers['cngLpgKitsExFitted']!.text) ?? 0.0;
    double ll2Passenger = double.tryParse(_controllers['ll2Passenger']!.text) ?? 0.0;
    double imt23Value = _selectedImt23 == 'Yes' ? 15.0 : 0.0; 
    double loadingOnDiscountPremium = double.tryParse(_controllers['loadingOnDiscountPremium']!.text) ?? 0.0;
    double llPaidDriver = double.tryParse(_selectedLlPaidDriver ?? "0") ?? 0.0;
    double llLEmployeeOther = double.tryParse(_selectedLlEmployeePaidDriver ?? "0") ?? 0.0;
    double llToPaidDriver =double.tryParse(_selectedLlPaidDriver ?? "0") ?? 0.0;
    double restrictedTppd = _selectedRestrictedTppd == 'Yes' ? 200.0 : 0.0;
    String selectedNCBText = _selectedNcb ?? "0%";
    double ncbPercentage = double.tryParse(selectedNCBText.replaceAll('%', '')) ?? 0.0;

    // Get base rate from function
    double vehicleBasicRate =
        _getOdRate(zone, _selectedAge ?? 'Upto 5 Years');

    // OD Calculations
      // 2. Basic for Vehicle
      double basicForVehicle = (currentIdv * vehicleBasicRate) / 100;
      
      // 3. CNG/LPG Kit (Externally Fitted)
    double cngLpgPremium = 0.0;
    if (_selectedCNG == 'Yes' && cngKitExternal > 0) {
      // cngLpgPremium = (cngKitExternal / 1000) * 60;
       cngLpgPremium = (cngKitExternal * 0.04); // 4% of the CNG/LPG kit value
    }

    // 4. IMT 23
    double imt23 = (basicForVehicle * imt23Value) / 100;

      // 5. Basic OD Premium
    // double basicOdPremium = basicForVehicle + cngLpgPremium + imt23; 
    double basicOdPremium = basicForVehicle + cngLpgPremium ;  // as per changes told by nitesh sir on 5/9/25
      

      
      // 6. Basic OD Premium Before Discount
      double odBeforeDiscount = basicOdPremium + imt23 ;
          
      
      // 7. Discount on OD Premium
      double discountOdPremium = odBeforeDiscount * discountOnOd/100;
      // double discountOdPremium = basicOdPremium * discountOnOd/100;

     double basicOdAfterDiscPremium = odBeforeDiscount - discountOdPremium;
     //print("--------------basicOdAfterDiscPremium :  ${basicOdAfterDiscPremium}--------");
      
      // 8. Loading on OD Premium
      double loadingOdPremium = (basicOdAfterDiscPremium * loadingOnDiscountPremium) / 100;

      
      // 9. Basic OD Before NCB
      double odBeforeNcb = basicOdAfterDiscPremium + loadingOdPremium;
      
      // 10. No Claim Bonus (NCB)
      double ncbAmount = (odBeforeNcb * ncbPercentage) / 100;
      
      // 11. Net Own Damage Premium
      double netOwnDamagePremium = odBeforeNcb - ncbAmount;
      double totalA = netOwnDamagePremium ;

    // TP Section
    double cngLpgRate = 60;   // change to actual IRDA rate
    double cngLpgKit = _selectedCNG == 'Yes'?cngLpgRate:0.0;
    double llToPassengerRate = 60.0;
    double llToPassenger = ll2Passenger * llToPassengerRate;
    double liabilityPremiumTP = _getTpRate();
    double totalB = liabilityPremiumTP +
      paOwnerDriver +
      llPaidDriver+
      cngLpgKit+
      llLEmployeeOther-
      restrictedTppd+
      llToPassenger;



    // Total Premium (C)
    double totalAB = totalA + totalB;
    double gst = totalAB * 0.18;
    double otherCessAmt = (otherCess * totalAB) / 100;
    double finalPremium = totalAB + gst + otherCessAmt;

    // Result Map
    Map<String, String> resultMap = {
      // Basic Details
      "IDV": currentIdv.toStringAsFixed(2),
      "Year of Manufacture": yearOfManufacture,
      "Zone": zone,

      // A - Own Damage Premium Package
      "Vehicle Basic Rate": vehicleBasicRate.toStringAsFixed(3),
      "Basic for Vehicle": basicForVehicle.toStringAsFixed(2),
      "CNG/LPG kit": cngLpgPremium.toStringAsFixed(2),
      "Basic OD Premium": basicOdPremium.toStringAsFixed(2),
      "IMT 23": imt23.toStringAsFixed(2),
      "Basic OD Before Discount": odBeforeDiscount.toStringAsFixed(2),
      "Discount on OD": discountOdPremium.toStringAsFixed(2),
      "Loading Discount Premium": loadingOdPremium.toStringAsFixed(2),
      "Basic OD Before NCB": odBeforeNcb.toStringAsFixed(2),
      "No Claim Bonus": ncbAmount.toStringAsFixed(2),
      "Net Own Damage Premium": totalA.toStringAsFixed(2),
      "Total A": totalA.toStringAsFixed(2),

      // B - Liability Premium
      "Basic Liability Premium": liabilityPremiumTP.toStringAsFixed(2),
      "Restricted TPPD": restrictedTppd.toStringAsFixed(2),
      "CNG/LPG Kit (TP)": cngLpgKit.toString(),
      "PA to Owner Driver": paOwnerDriver.toStringAsFixed(2),
      "LL to Paid Driver": llToPaidDriver.toStringAsFixed(2),
      "LL to Employee Other than Paid Driver": llLEmployeeOther.toStringAsFixed(2),
      "LL to Passenger":llToPassenger.toStringAsFixed(2),
      "Total B": totalB.toStringAsFixed(2),

      // C - Total Premium
      "Total Package Premium[A+B]": totalAB.toStringAsFixed(2),
      "GST @ 18% [Applied on OD and TP]": gst.toStringAsFixed(2),
      "Other CESS": otherCessAmt.toStringAsFixed(2),

      // Final Premium
      "Final Premium": finalPremium.toStringAsFixed(2),
    };

    // Pass data to result screen
    InsuranceResultData resultData = InsuranceResultData(
      vehicleType: "Pedestrian Controlled Agricultural Tractors",
      fieldData: resultMap,
      totalPremium: finalPremium,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MiscInsuranceResultScreen(resultData: resultData),
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
      _selectedDepreciation = null;
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
                'Pedestrian Controlled Agricultural Tractors',
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
                _buildTextField('yearOfManufacture', 'Year of Manufacture', 'Year of Manufacture'),
                _buildDropdownField('Zone', _zoneOptions, _selectedZone,
                    (val) => setState(() => _selectedZone = val)),
                _buildTextField('discountOnOd', 'Discount on OD Premium (%)','Discount on OD Premium (%)'),
                _buildTextField('loadingOnDiscountPremium', 'Loading on Discount Premium (%)','Loading on Discount Premium (%)'),
                _buildDropdownField('CNG/LPG kits', _cngOptions, _selectedCNG,
                    (val) => setState(() => _selectedCNG = val)),
                _buildTextField('cngLpgKitsExFitted', 'CNG/LPG kits (Externally Fitted)','CNG LPG kits (Externally Fitted)'),
                _buildDropdownField('IMT 23', _imt23Options, _selectedImt23,
                    (val) => setState(() => _selectedImt23 = val)),
                _buildDropdownField('No Claim Bonus', _ncbOptions, _selectedNcb,
                    (val) => setState(() => _selectedNcb = val)),
                _buildTextField('paOwnerDriver', 'PA to Owner Driver (₹)','PA to Owner Driver (₹)'),
                _buildDropdownField('LL to Paid Driver', _llPaidDriverOptions, _selectedLlPaidDriver,
                    (val) => setState(() => _selectedLlPaidDriver = val)),
                _buildDropdownField('LL to Employee other than Paid Driver', _llEmployeePaidDriverOptions, _selectedLlEmployeePaidDriver,
                    (val) => setState(() => _selectedLlEmployeePaidDriver = val)),
                _buildTextField('ll2Passenger', 'LL to Passenger (Number of Passenger)', 'LL to Passenger (Number of Passenger)'),
                _buildDropdownField('Restricted TPPD', _restrictedTppdOptions, _selectedRestrictedTppd,
                    (val) => setState(() => _selectedRestrictedTppd = val)),
                _buildTextField('otherCess', 'Other Cess (%)','Other Cess (%)'),
                
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
        // Optional dropdown fields
  const optionalFields=['otherCess','paOwnerDriver','cngLpgKitsExFitted','discountOnOd','loadingOnDiscountPremium','ll2Passenger'
  ];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(width: 180, child: Text(label, style: const TextStyle(fontSize: 16))),
          Expanded(
            child: TextFormField(
              onChanged: (val) {
                  if (key == 'idv') _updateCurrentIdv();
                },
              controller: _controllers[key],
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: placeholder,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
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
              return null; // Valid input
            }
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
      String label, List<String> options, String? selected, Function(String?) onChanged) {
        const optionalDropdowns = [
    'Restricted TPPD','LL to Employee other than Paid Driver','LL to Paid Driver',
    'No Claim Bonus','IMT 23','CNG/LPG kits' // matches label or keyName
  ];
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
              validator: (value) {
              // Skip validation if optional
              if (optionalDropdowns.contains(label)) {
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


double _getOdRate(String zone, String ageCategory) {
  if (zone == 'A') {
    if (ageCategory == 'Upto 5 Years') return 1.208;
    if (ageCategory == '6-7 Years') return 1.238;
    return 1.268; // 'Above 7 Years'
  } 
  else if (zone == 'B') {
    if (ageCategory == 'Upto 5 Years') return 1.202;
    if (ageCategory == '6-7 Years') return 1.232;
    return 1.262; // 'Above 7 Years'
  }
  else if (zone == 'C') {
    if (ageCategory == 'Upto 5 Years') return 1.190;
    if (ageCategory == '6-7 Years') return 1.220;
    return 1.250; // 'Above 7 Years'
  }

  // Safe fallback rate
  return 1.208; 
}


// double _getTpRate({bool isFiveYear = false}) {
//   if (isFiveYear) {
//     // Official IRDA 5-year bundled TP premium (example placeholder)
//     return 3200.0;
//   } else {
//     // Official IRDA 1-year TP premium (example placeholder)
//     return 650.0;
//   }
// }
double _getTpRate() {
  // As per IRDAI, Tractor 
  // or a similar commercial vehicle class. The rate is a fixed amount.
  // This is a representative rate and must be verified with the latest IRDAI circular.
  return 1645; // A fixed rate, for instance, based on vehicles up to 7500 kg GVW.
}