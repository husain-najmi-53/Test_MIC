import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TwoWheelerPassengerCarryingFormScreen extends StatefulWidget {
  const TwoWheelerPassengerCarryingFormScreen({super.key});

  @override
  State<TwoWheelerPassengerCarryingFormScreen> createState() =>
      _TwoWheelerPassengerCarryingFormScreenState();
}

class _TwoWheelerPassengerCarryingFormScreenState
    extends State<TwoWheelerPassengerCarryingFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> _controllers = {
    'idv': TextEditingController(),
    'depreciation': TextEditingController(),
    'yearOfManufacture': TextEditingController(),
    'cubicCapacity': TextEditingController(),
    'numberOfPassengers': TextEditingController(),
    'discountOnOd': TextEditingController(),
    'accessoriesValue': TextEditingController(),
    'cngLpgKit': TextEditingController(),
    'externalCngLpgKit': TextEditingController(),
    'paOwnerDriver': TextEditingController(),
    'otherCess': TextEditingController(),
  };

  String? _selectedAge;
  String? _selectedZone;
  String? _selectedNcb;
  String? _selectedImt23;
  String? _selectedLlPaidDriver;
  String? _selectedRestrictedTppd;

  final List<String> _ageOptions = ['Upto 5 Years', '6-10 Years', 'Above 10 Years'];
  final List<String> _zoneOptions = ['A', 'B'];
  final List<String> _ncbOptions = ['0%', '20%', '25%', '35%', '45%', '50%'];
  final List<String> _imt23Options = ['Yes', 'No'];
  final List<String> _llPaidDriverOptions = ['0', '50'];
  final List<String> _restrictedTppdOptions = ['Yes', 'No'];

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final summary = '''
🏍️ Vehicle Type: Two Wheeler Passenger Carrying
📊 IDV: ₹${_controllers['idv']!.text}
📉 Depreciation: ${_controllers['depreciation']!.text}%
🕒 Age: $_selectedAge
📅 Year of Manufacture: ${_controllers['yearOfManufacture']!.text}
🌍 Zone: $_selectedZone
🛢️ Cubic Capacity: ${_controllers['cubicCapacity']!.text} cc
👥 No. of Passengers: ${_controllers['numberOfPassengers']!.text}
🏷️ Discount on OD Premium: ${_controllers['discountOnOd']!.text}%
🧾 IMT 23: $_selectedImt23
🔧 Accessories Value: ₹${_controllers['accessoriesValue']!.text}
⛽ CNG/LPG Kits: ₹${_controllers['cngLpgKit']!.text}
🔌 Externally Fitted CNG/LPG: ₹${_controllers['externalCngLpgKit']!.text}
🚫 No Claim Bonus: $_selectedNcb
👤 PA to Owner Driver: ₹${_controllers['paOwnerDriver']!.text}
👨‍🔧 LL to Paid Driver: $_selectedLlPaidDriver
⚠️ Restricted TPPD: $_selectedRestrictedTppd
💰 Other Cess: ${_controllers['otherCess']!.text}%
''';

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Form Submitted'),
          content: SingleChildScrollView(child: Text(summary)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
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
              //Icon(Icons.people, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Two Wheeler Passenger Carrying',
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
                _buildTextField('idv', 'IDV (₹)', 'Enter IDV'),
                _buildTextField('depreciation', 'Depreciation (%)', 'Enter Depreciation'),
                _buildDropdownField('Age of Vehicle', _ageOptions, _selectedAge,
                    (val) => setState(() => _selectedAge = val)),
                _buildTextField('yearOfManufacture', 'Year of Manufacture', 'Enter Year'),
                _buildDropdownField('Zone', _zoneOptions, _selectedZone,
                    (val) => setState(() => _selectedZone = val)),
                _buildTextField('cubicCapacity', 'Cubic Capacity (cc)', 'Enter Capacity'),
                _buildTextField('numberOfPassengers', 'No. of Passengers', 'Enter Number'),
                _buildTextField('discountOnOd', 'Discount on OD Premium (%)', 'Enter Discount'),
                _buildDropdownField('IMT 23', _imt23Options, _selectedImt23,
                    (val) => setState(() => _selectedImt23 = val)),
                _buildTextField('accessoriesValue', 'Accessories Value (₹)', 'Enter Accessories Value'),
                _buildTextField('cngLpgKit', 'CNG/LPG Kits (₹)', 'Enter Kit Value'),
                _buildTextField('externalCngLpgKit', 'Externally Fitted CNG/LPG (₹)', 'Enter Kit Value'),
                _buildDropdownField('No Claim Bonus (%)', _ncbOptions, _selectedNcb,
                    (val) => setState(() => _selectedNcb = val)),
                _buildTextField('paOwnerDriver', 'PA to Owner Driver (₹)', 'Enter Amount'),
                _buildDropdownField('LL to Paid Driver', _llPaidDriverOptions, _selectedLlPaidDriver,
                    (val) => setState(() => _selectedLlPaidDriver = val)),
                _buildDropdownField('Restricted TPPD', _restrictedTppdOptions, _selectedRestrictedTppd,
                    (val) => setState(() => _selectedRestrictedTppd = val)),
                _buildTextField('otherCess', 'Other Cess (%)', 'Enter Cess %'),
                //const SizedBox(height: 80),
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
