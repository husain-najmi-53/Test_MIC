import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/result_data.dart';
import '../models/quotation_data.dart';

class VehicleAgentFormScreen extends StatefulWidget {
  final InsuranceResultData insuranceResult;

  const VehicleAgentFormScreen({
    Key? key,
    required this.insuranceResult,
  }) : super(key: key);

  @override
  State<VehicleAgentFormScreen> createState() => _VehicleAgentFormScreenState();
}

class _VehicleAgentFormScreenState extends State<VehicleAgentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'ownerName': TextEditingController(),
    'make': TextEditingController(),
    'model': TextEditingController(),
    'registrationNumber': TextEditingController(),
    'seatingCapacity': TextEditingController(),
    'otherCoverage': TextEditingController(),
    'agentName': TextEditingController(),
    'agentEmail': TextEditingController(),
    'agentContact': TextEditingController(),
  };

  DateTime? policyStartDate;
  DateTime? policyEndDate;

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          policyStartDate = picked;
        } else {
          policyEndDate = picked;
        }
      });
    }
  }

  void _saveQuotation() {
    if (_formKey.currentState!.validate()) {
      final quotation = QuotationData(
        insuranceResult: widget.insuranceResult,
        ownerName: _controllers['ownerName']!.text.trim(),
        make: _controllers['make']!.text.trim(),
        model: _controllers['model']!.text.trim(),
        registrationNumber: _controllers['registrationNumber']!.text.trim(),
        seatingCapacity: _controllers['seatingCapacity']!.text.trim(),
        otherCoverage: _controllers['otherCoverage']!.text.trim(),
        policyStartDate: policyStartDate!,
        policyEndDate: policyEndDate!,
        agentName: _controllers['agentName']!.text.trim(),
        agentEmail: _controllers['agentEmail']!.text.trim(),
        agentContact: _controllers['agentContact']!.text.trim(),
      );
      print('Quotation saved: ${jsonEncode(quotation)}');
    }
  }

  Widget _buildTextField(String key, String label, String placeholder) {
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
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: placeholder,
              ),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Enter $label' : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(String label, bool isStartDate) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
            width: 180,
            child: Text(label, style: const TextStyle(fontSize: 16)),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _pickDate(isStart: isStartDate),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: TextEditingController(
                    text: isStartDate
                        ? policyStartDate == null
                            ? ''
                            : "${policyStartDate!.day}/${policyStartDate!.month}/${policyStartDate!.year}"
                        : policyEndDate == null
                            ? ''
                            : "${policyEndDate!.day}/${policyEndDate!.month}/${policyEndDate!.year}",
                  ),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Select date',
                    suffixIcon:
                        Icon(Icons.calendar_today, color: Colors.indigo[700]),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Select $label'
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[700],
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 8),
            Text(
              'Vehicle & Agent Information',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Vehicle Information Card
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Vehicle Information',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo),
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                            'ownerName', 'Owner Name', 'Enter owner name'),
                        _buildTextField('make', 'Make', 'Enter make'),
                        _buildTextField('model', 'Model', 'Enter model'),
                        _buildTextField('registrationNumber',
                            'Registration Number', 'Enter registration number'),
                        _buildTextField('seatingCapacity', 'Seating Capacity',
                            'Enter seating capacity'),
                        _buildTextField('otherCoverage', 'Other Coverage',
                            'Enter other coverage'),
                        _buildDateField('Policy Start Date', true),
                        _buildDateField('Policy End Date', false),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Agent Information Card
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Agent Information',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo),
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                            'agentName', 'Agent Name', 'Enter agent name'),
                        _buildTextField(
                            'agentEmail', 'Agent Email', 'Enter email'),
                        _buildTextField('agentContact', 'Agent Contact',
                            'Enter contact number'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _saveQuotation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo[700],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'SAVE',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("PDF generation is not implemented yet"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo[100],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'SHARE (PDF)',
                  style: TextStyle(color: Colors.indigo[700], fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
