import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motor_insurance_app/models/result_data.dart';
import 'package:motor_insurance_app/screens/vehicle/miscellaneous_vehicle/misc_result_screen.dart';
class TrailerFormScreen extends StatefulWidget {
  const TrailerFormScreen({super.key});

  @override
  State<TrailerFormScreen> createState() => _TrailerFormScreenState();
}

class _TrailerFormScreenState extends State<TrailerFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> _controllers = {
    'idv': TextEditingController(),
    'depreciation': TextEditingController(),
    'currentIdv': TextEditingController(),
    'noOfTrailers': TextEditingController(), 
    'yearOfManufacture': TextEditingController(),
    'discountOnOd': TextEditingController(),
    'loading_on_discount_premium': TextEditingController(),
    'CNG_LPG_kits_Ex_fitted': TextEditingController(),
    'paOwnerDriver': TextEditingController(),
    'otherCess': TextEditingController(),
  };


  String? _selectedDepreciation;
  String? _selectedTrailerTowedBy;
  String? _selectedZone;
  String? _selectedCNG;
  String? _selectedImt23;
  String? _selectedNcb;
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
  final List<String> _trailerTowedByOptions = ['Other Vehicle', 'Agriculture Tractors upto 6 HP'];
  final List<String> _zoneOptions = ['A', 'B'];
  final List<String> _cngOptions = ['Yes', 'No'];
  final List<String> _imt23Options = ['Yes', 'No'];
  final List<String> _ncbOptions =['0','20','25','35','45','50'];
  final List<String> _llPaidDriverOptions = ['0', '250'];
  final List<String> _llEmployeeOtherOptions = ['0', '250'];
  final List<String> _restrictedTppdOptions = ['Yes', 'No'];

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
    double currentIdv = double.tryParse(_controllers['currentIdv']!.text)?? 0.0;
    double noOfTrailers = double.tryParse(_controllers['noOfTrailers']!.text) ?? 0.0;
    // double selectIMT = double.tryParse(_selectedImt23 ?? "0") ?? 0.0;
    double selectIMT = (_selectedImt23?.toLowerCase() == 'yes') ? 15.0 : 0.0;
    double trailerTowedBy = double.tryParse(_selectedTrailerTowedBy ?? "0") ?? 0.0;
    // String yearOfManufacture = _controllers['yearOfManufacture']!.text;
    double yearOfManufacture = double.tryParse(_controllers['yearOfManufacture']!.text) ?? 0.0;
    String zone = _selectedZone ?? "A";
    double cngExternally = double.tryParse(_controllers['CNG_LPG_kits_Ex_fitted']!.text) ?? 0.0;
    double cngSelected = double.tryParse(_selectedCNG ?? "0") ?? 0.0;
    double discountOnOd = double.tryParse(_controllers['discountOnOd']!.text) ?? 0.0;
    double loadingOnDiscountPremium = double.tryParse(_controllers['loading_on_discount_premium']!.text) ?? 0.0;
    double paOwnerDriver = double.tryParse(_controllers['paOwnerDriver']!.text) ?? 0.0;
    double otherCess = double.tryParse(_controllers['otherCess']!.text) ?? 0.0;
    // double ll2Passenger = double.tryParse(_controllers['ll2Passenger']!.text) ?? 0.0;
    double llPaidDriver = double.tryParse(_selectedLlPaidDriver ?? "0") ?? 0.0;
    double llLEmployeeOther = double.tryParse(_selectedLlEmployeeOther ?? "0") ?? 0.0;
    double llToPaidDriver =double.tryParse(_selectedLlPaidDriver ?? "0") ?? 0.0;
    double restrictedTppd = double.tryParse(_selectedRestrictedTppd ?? "0")?? 0.0;
    String selectedNCBText = _selectedNcb ?? "0%";
    double ncbPercentage = double.tryParse(selectedNCBText.replaceAll('%', '')) ?? 0.0;

    // Get base rate from function
    double vehicleBasicRate = _getOdRate(
      _selectedZone!,
      _selectedTrailerTowedBy!,
       yearOfManufacture
    );


    // OD Calculations
  double basicOdPremium = (currentIdv * vehicleBasicRate) / 100;

// Discount amount on OD premium (percentage)
double discountOdPremium = (basicOdPremium * discountOnOd) / 100;

// Loading amount on OD premium (percentage)
double loadingOdPremium = (basicOdPremium * loadingOnDiscountPremium) / 100;

// IMT 23 loading (percentage)
double imt23Amount = (basicOdPremium * selectIMT) / 100;

// CNG/LPG kit premium (fixed amount), add only if selected
double cngPremium = cngSelected == 1 ? cngExternally : 0;

// OD premium before applying NCB
double odBeforeNcb = (basicOdPremium - discountOdPremium) + loadingOdPremium + imt23Amount + cngPremium;

// NCB amount (percentage discount)
double ncbAmount = (odBeforeNcb * ncbPercentage) / 100;

// Net OD premium after NCB
double totalA = odBeforeNcb - ncbAmount;


    // TP Section
    double liabilityPremiumTP = _getTpRate(trailerTowedBy.toString());
    double totalB = liabilityPremiumTP +
      restrictedTppd +
      cngSelected +
      paOwnerDriver +
      llPaidDriver +
      llLEmployeeOther;



    // Total Premium (C)
    double totalAB = totalA + totalB;
    double gst = totalAB * 0.18;
    otherCess = (otherCess * totalAB) / 100;
    double finalPremium = totalAB + gst + otherCess;

    // Result Map
    Map<String, String> resultMap = {
      // Basic Details
      "IDV": idv.toStringAsFixed(2),
      "no of Trailers (Attached)": noOfTrailers.toStringAsFixed(2),
      "Trailer Towed By": trailerTowedBy.toString(),
      "Year of Manufacture": yearOfManufacture.toString(),
      "Zone": zone,

      // A - Own Damage Premium Package
      // "Vehicle Basic Rate": vehicleBasicRate.toStringAsFixed(3),
      "Basic for Vehicle": basicOdPremium.toStringAsFixed(2),
      "IMT 23": imt23Amount.toStringAsFixed(2),
      "CNG/LPG kit (Externally Fitted)": cngExternally.toStringAsFixed(2),
      "Basic OD Premium Before discount": basicOdPremium.toStringAsFixed(2),
      "Discount on OD Premium": discountOdPremium.toStringAsFixed(2),
      "Loading on OD Premium": loadingOdPremium.toStringAsFixed(2),
      "Basic OD Before NCB": odBeforeNcb.toStringAsFixed(2),
      "No Claim Bonus": ncbAmount.toStringAsFixed(2),
      "Net Own Damage Premium": totalA.toStringAsFixed(2),
      "Total A": totalA.toStringAsFixed(2),

      // B - Liability Premium
      "Trailer Liability Premium (TP)": liabilityPremiumTP.toStringAsFixed(2),
      "Restricted TPPD": restrictedTppd.toStringAsFixed(2),
      "CNG/LPG Kit": _selectedCNG ?? 'No',
      "PA to Owner Driver": paOwnerDriver.toStringAsFixed(2),
      "LL to Paid Driver": llToPaidDriver.toStringAsFixed(2),
      "LL to Employee Other than Paid Driver": llLEmployeeOther.toStringAsFixed(2),
      // "LL to Passenger":ll2Passenger.toStringAsFixed(2),
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
      vehicleType:"Trailer",
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
                'Trailer',
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
                _buildTextField('noOfTrailers', 'No. of trailers (Attached)', 'Enter number of trailers'), 
                _buildDropdownField('Trailer towed by', _trailerTowedByOptions, _selectedTrailerTowedBy,
                    (val) => setState(() => _selectedTrailerTowedBy = val)),         
                _buildTextField('yearOfManufacture', 'Year of Manufacture','Enter Year Of MAnufacture'),
                _buildDropdownField('Zone', _zoneOptions, _selectedZone,
                    (val) => setState(() => _selectedZone = val)),
                _buildTextField('discountOnOd', 'Discount on OD Premium (%)','Enter Discount on OD Premium'),
                _buildTextField('loading_on_discount_premium', 'Loading on discount premium (%)', 'Enter Loading on discount premium'),
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
                _buildDropdownField('Restrcited TPPD', _restrictedTppdOptions, _selectedRestrictedTppd,
                    (val) => setState(() => _selectedRestrictedTppd = val)),
                _buildTextField('otherCess', 'Other Cess (%)','Other CESS(%)'),
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
            isExpanded: true,
            value: selected,
            items: options.map((item) => DropdownMenuItem(
              value: item,
              child: Text(
                item,
                overflow: label == 'Trailer towed by' ? TextOverflow.ellipsis : null,
                maxLines: 1,
              ),
            )).toList(),
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



double _getOdRate(String zone, String trailerTowedBy, double yearOfManufacture) {
  int currentYear = DateTime.now().year;
  double age = currentYear - yearOfManufacture;

  // Map numeric age to bracket
  String ageBracket;
  if (age <= 5) {
    ageBracket = 'Upto 5 Years';
  } else if (age <= 7) {
    ageBracket = '5-7 Years';
  } else {
    ageBracket = '> 7 Years';
  }

  if (trailerTowedBy == 'Agriculture Tractors upto 6 HP') {
    if (zone == 'A') {
      if (ageBracket == 'Upto 5 Years') return 1.208;
      if (ageBracket == '5-7 Years') return 1.238;
      return 1.268;
    } else if (zone == 'B') {
      if (ageBracket == 'Upto 5 Years') return 1.202;
      if (ageBracket == '5-7 Years') return 1.232;
      return 1.262;
    } else if (zone == 'C') {
      if (ageBracket == 'Upto 5 Years') return 1.190;
      if (ageBracket == '5-7 Years') return 1.220;
      return 1.250;
    }
  } 
  
  else if (trailerTowedBy == 'Other Vehicle') {
    if (zone == 'A') {
      if (ageBracket == 'Upto 5 Years') return 1.208;
      if (ageBracket == '5-7 Years') return 1.238;
      return 1.268;
    } else if (zone == 'B') {
      if (ageBracket == 'Upto 5 Years') return 1.202;
      if (ageBracket == '5-7 Years') return 1.232;
      return 1.262;
    } else if (zone == 'C') {
      if (ageBracket == 'Upto 5 Years') return 1.190;
      if (ageBracket == '5-7 Years') return 1.220;
      return 1.250;
    }
  }

  // Safe fallback
  return 0.50;
}





  // Get base rate
double _getTpRate(String trailerTowedBy) {
  switch (trailerTowedBy) {
    case 'Agriculture Tractors upto 6 HP':
      return 510.0;
    case 'Goods Carrier':
      return 1500.0;
    default:
      return 1000.0; // fallback
  }
}

