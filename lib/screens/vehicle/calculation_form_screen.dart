import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculationFormScreen extends StatefulWidget {
  final String selectedType;

  const CalculationFormScreen({super.key, required this.selectedType});

  @override
  State<CalculationFormScreen> createState() => _CalculationFormScreenState();
}

class _CalculationFormScreenState extends State<CalculationFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // TextEditingControllers
  final _controllers = {
    'idv': TextEditingController(),
    'depreciation': TextEditingController(),
    'currentIdv': TextEditingController(),
    'vehicleAge': TextEditingController(),
    'yearOfManufacture': TextEditingController(),
    'cubicCapacity': TextEditingController(),
    'discountOnOd': TextEditingController(),
    'accessoriesValue': TextEditingController(),
    'noClaimBonus': TextEditingController(),
    'zeroDepreciation': TextEditingController(),
    'paOwnerDriver': TextEditingController(),
    'llPaidDriver': TextEditingController(),
    'paUnnamedPassenger': TextEditingController(),
    'restrictedTppd': TextEditingController(),
    'otherCess': TextEditingController(),
  };

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
🚗 Vehicle Type: ${widget.selectedType}
📊 IDV: ₹${_controllers['idv']!.text}
💸 Depreciation (%): ${_controllers['depreciation']!.text}
💰 Current IDV: ₹${_controllers['currentIdv']!.text}
🚗 Age of Vehicle: ${_controllers['vehicleAge']!.text} years
📅 Year of Manufacture: ${_controllers['yearOfManufacture']!.text}
🌍 Zone: ${_selectedZone ?? 'N/A'}
📦 Cubic Capacity: ${_controllers['cubicCapacity']!.text} cc
💵 Discount on OD premium (%): ${_controllers['discountOnOd']!.text}
💎 Accessories Value: ₹${_controllers['accessoriesValue']!.text}
🏆 No Claim Bonus (%): ${_controllers['noClaimBonus']!.text}
🛡️ Zero Depreciation: ${_controllers['zeroDepreciation']!.text}
👤 PA to Owner Driver: ₹${_controllers['paOwnerDriver']!.text}
👨‍🔧 LL to Paid Driver: ₹${_controllers['llPaidDriver']!.text}
🧑‍🤝‍🧑 PA to Unnamed Passenger: ₹${_controllers['paUnnamedPassenger']!.text}
🚫 Restricted TPPD: ₹${_controllers['restrictedTppd']!.text}
💰 Other Cess (%): ${_controllers['otherCess']!.text}
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
          child: ListView(
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
              _buildTextField('depreciation', 'Depreciation (%)', true),
              _buildTextField('currentIdv', 'Current IDV (₹)', true),
              _buildTextField('vehicleAge', 'Age of Vehicle (Years)', true),
              _buildTextField('yearOfManufacture', 'Year of Manufacture', true),
              _buildZoneDropdown(),
              _buildTextField('cubicCapacity', 'Cubic Capacity (cc)', true),
              _buildTextField(
                  'discountOnOd', 'Discount on OD Premium (%)', true),
              _buildTextField(
                  'accessoriesValue', 'Accessories Value (₹)', true),
              _buildTextField('noClaimBonus', 'No Claim Bonus (%)', true),
              _buildTextField('zeroDepreciation', 'Zero Depreciation', true),
              _buildTextField('paOwnerDriver', 'PA to Owner Driver (₹)', true),
              _buildTextField('llPaidDriver', 'LL to Paid Driver (₹)', true),
              _buildTextField(
                  'paUnnamedPassenger', 'PA to Unnamed Passenger (₹)', true),
              _buildTextField('restrictedTppd', 'Restricted TPPD (₹)', true),
              _buildTextField('otherCess', 'Other Cess (%)', true),
              const SizedBox(height: 80), // Extra space above the sticky button
            ],
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
          const Icon(Icons.two_wheeler_rounded,
              color: Color.fromARGB(255, 167, 13, 13)),
          const SizedBox(width: 8),
          Text(
            widget.selectedType,
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