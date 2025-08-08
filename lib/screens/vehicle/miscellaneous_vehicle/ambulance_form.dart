import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmbulanceFormScreen extends StatefulWidget {

  const AmbulanceFormScreen({super.key, });

  @override
  State<AmbulanceFormScreen> createState() => _AmbulanceFormScreenState();
}

class _AmbulanceFormScreenState extends State<AmbulanceFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // TextEditingControllers
  late Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllers = {
      'idv': TextEditingController(),               //1
      // 'depreciation': TextEditingController(),
      'vehicleAge': TextEditingController(),       //2
      'yearOfManufacture': TextEditingController(), //3
      'discountOnOd': TextEditingController(),     //5
      'loading_on_discount_premium': TextEditingController(),//6
      'CNG_LPG_kits': TextEditingController(),//7
      'CNG_LPG_kits_Ex_fitted': TextEditingController(),//8
      'Imt23': TextEditingController(),//9
      'noClaimBonus': TextEditingController(),     //10
      'ValueAddedServices': TextEditingController(),     //11
      'paOwnerDriver': TextEditingController(),    //12
      'llPaidDriver': TextEditingController(),     //13
      'll2EmpOtherThanPaidDriver': TextEditingController(),     //14
      'll2Passenger': TextEditingController(),     //15
      'restrictedTppd': TextEditingController(),   //16
      'otherCess': TextEditingController(),        //17
      // 'currentIdv': TextEditingController(),

      /*'cubicCapacity': TextEditingController(),
    'accessoriesValue': TextEditingController(),
    'zeroDepreciation': TextEditingController(),
    'paUnnamedPassenger': TextEditingController(),*/
      //17
    };
  }


  String? _selectedZone;

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
🚗 Vehicle Type: Ambulance
📊 IDV: ₹${_controllers['idv']!.text}
🚗 Age of Vehicle: ${_controllers['vehicleAge']!.text} years
📅 Year of Manufacture: ${_controllers['yearOfManufacture']!.text}
🌍 Zone: ${_selectedZone ?? 'N/A'}
💵 Discount on OD premium (%): ${_controllers['discountOnOd']!.text}
💵 Loading on Discount premium (%): ${_controllers['loading_on_discount_premium']!.text}
💎 CNG/LPG kits: ₹${_controllers['CNG_LPG_kits']!.text}
💎 CNG/LPG kits(externally fitted): ₹${_controllers['CNG_LPG_kits_Ex_fitted']!.text}
📦 IMT 23: ₹${_controllers['Imt23']!.text}
🏆 No Claim Bonus (%): ${_controllers['noClaimBonus']!.text}
🏆 Value added services(Amount) (%): ${_controllers['ValueAddedServices']!.text}
👤 PA to Owner Driver: ₹${_controllers['paOwnerDriver']!.text}
👨‍🔧 LL to Paid Driver: ₹${_controllers['llPaidDriver']!.text}
🛡️ LL to employee other than Paid driver: ${_controllers['ll2EmpOtherThanPaidDriver']!.text}
🛡️ LL to passenger (Number of passenger): ${_controllers['ll2Passenger']!.text}
🚫 Restricted TPPD: ₹${_controllers['restrictedTppd']!.text}
💰 Other Cess (%): ${_controllers['otherCess']!.text}
''';
    /*💸 Depreciation (%): ${_controllers['depreciation']!.text}
    💰 Current IDV: ₹${_controllers['currentIdv']!.text}
    🧑‍🤝‍🧑 PA to Unnamed Passenger: ₹${_controllers['paUnnamedPassenger']!.text}
    📦 Cubic Capacity: ${_controllers['cubicCapacity']!.text} cc*/
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
      _selectedZone = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(
        //   '${widget.selectedType}',
        //   style: const TextStyle(color: Colors.white),
        // ),
        backgroundColor: Colors.indigo.shade700,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.white), // Set the back icon color to white
          onPressed: () {
            Navigator.pop(context); // Handle back navigation
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
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
                _buildStickyNote(),
                const SizedBox(height: 8),
                const Divider(
                  color: Colors.grey, // Color of the line
                  thickness: 1.5, // Thickness of the line
                  indent: 20, // Space from the start (left side)
                  endIndent: 20, // Space from the end (right side)
                ),
                const SizedBox(height: 20),
                _buildTextField('idv', 'IDV (₹)', true),
                // _buildTextField('depreciation', 'Depreciation (%)', true),
                // _buildTextField('currentIdv', 'Current IDV (₹)', true),
                _buildTextField('vehicleAge', 'Age of Vehicle (Years)', true),
                _buildTextField('yearOfManufacture', 'Year of Manufacture', true),
                _buildZoneDropdown(),
                // _buildTextField('cubicCapacity', 'Cubic Capacity (cc)', true),
                _buildTextField('discountOnOd', 'Discount on OD Premium (%)', true),
                _buildTextField('loading_on_discount_premium', 'Loading on discount premium (%)', true),
                _buildTextField('CNG_LPG_kits', 'CNG/LPG kits', true),
                _buildTextField('CNG_LPG_kits_Ex_fitted', 'CNG/LPG kits (externally fitted)', true),
                _buildTextField('Imt23', 'IMT 23', true),
                _buildTextField('noClaimBonus', 'No Claim Bonus (%)', true),
                _buildTextField('ValueAddedServices', 'Value added services(Amount)', true),
                _buildTextField('paOwnerDriver', 'PA to Owner Driver (₹)', true),
                _buildTextField('llPaidDriver', 'LL to Paid Driver (₹)', true),
                _buildTextField('ll2EmpOtherThanPaidDriver', 'LL to employee other than Paid driver', true),
                _buildTextField('ll2Passenger', 'LL to passenger (Number of passenger)', true),
                _buildTextField('restrictedTppd', 'Restricted TPPD (₹)', true),
                _buildTextField('otherCess', 'Other Cess (%)', true),
                // _buildTextField('accessoriesValue', 'Accessories Value (₹)', true),
                // _buildTextField('zeroDepreciation', 'Zero Depreciation', true),
                // _buildTextField('paUnnamedPassenger', 'PA to Unnamed Passenger (₹)', true),
                const SizedBox(height: 80), // Extra space above the sticky button
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
          CircleAvatar(radius:20,child: Image.asset('assets/ambulance_icon.png')),
          const SizedBox(width: 8),
          Text(
            'Ambulance',
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

  Widget _buildTextField(String key, String label, bool isNumeric) {
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
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              keyboardType:
              isNumeric ? TextInputType.number : TextInputType.text,
              inputFormatters: isNumeric
                  ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
                  : null,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter $label';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoneDropdown() {
    const zones = ['A', 'B', 'C'];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Left-aligned label
          const SizedBox(
            width: 180, // Space for the label
            child: Text(
              'Zone',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.left,
            ),
          ),
          // Right-aligned dropdown
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              value: _selectedZone,
              items: zones
                  .map((zone) => DropdownMenuItem(
                value: zone,
                child: Text(zone),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedZone = value;
                });
              },
              validator: (value) =>
              value == null ? 'Please select a Zone' : null,
            ),
          ),
        ],
      ),
    );
  }
}
