import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:motor_insurance_app/screens/pdf_gen_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/result_data.dart';
import '../models/quotation_data.dart';

class VehicleAgentFormScreen extends StatefulWidget {
  final InsuranceResultData insuranceResult;

  const VehicleAgentFormScreen({
    super.key,
    required this.insuranceResult,
  });

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
  void initState() {
    super.initState();
    _loadSavedData();
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('agent_form_data');
    if (savedData != null) {
      final data = json.decode(savedData);
      setState(() {
        // Only load agent-related fields
        final agentFields = ['agentName', 'agentEmail', 'agentContact'];
        for (var field in agentFields) {
          if (data[field] != null) {
            _controllers[field]?.text = data[field];
          }
        }
      });
    }
  }

  Future<void> _resetForm() async {
    _formKey.currentState?.reset();
    for (var controller in _controllers.values) {
      controller.clear();
    }
    setState(() {
      policyStartDate = null;
      policyEndDate = null;
    });

    // Clear saved data
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('agent_form_data');
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

  QuotationData? _validateAndCreateQuotation() {
    if (!_formKey.currentState!.validate()) {
      return null;
    }
    
    if (policyStartDate == null || policyEndDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both policy start and end dates'),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }

    if (policyEndDate!.isBefore(policyStartDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Policy end date cannot be before start date'),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }

    return QuotationData(
      insuranceResult: widget.insuranceResult,
      ownerName: _controllers['ownerName']!.text.trim(),
      make: _controllers['make']!.text.trim(),
      model: _controllers['model']!.text.trim(),
      registrationNumber: _controllers['registrationNumber']!.text.trim(),
      seatingCapacity: _controllers['seatingCapacity']!.text.trim(),
      otherCoverage: _controllers['otherCoverage']!.text.trim().isNotEmpty
          ? _controllers['otherCoverage']!.text.trim()
          : null,
      policyStartDate: policyStartDate!,
      policyEndDate: policyEndDate!,
      agentName: _controllers['agentName']!.text.trim(),
      agentEmail: _controllers['agentEmail']!.text.trim(),
      agentContact: _controllers['agentContact']!.text.trim(),
    );
  }

  Future<void> _saveQuotation() async {
    final quotation = _validateAndCreateQuotation();
    if (quotation == null) return;
    
    try {
      // Save only agent form data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final formData = {
        'agentName': _controllers['agentName']?.text,
        'agentEmail': _controllers['agentEmail']?.text,
        'agentContact': _controllers['agentContact']?.text,
      };
      await prefs.setString('agent_form_data', json.encode(formData));
      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Form data saved successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Show error message if save fails
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving form data: ${e.toString()}'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String? _validateField(String key, String value) {
    if (value.trim().isEmpty) {
      return 'This field is required';
    }
    
    switch (key) {
      case 'seatingCapacity':
        final number = int.tryParse(value);
        if (number == null) {
          return 'Please enter a valid number';
        }
        if (number <= 0) {
          return 'Seating capacity must be greater than 0';
        }
        break;
      case 'agentEmail':
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return 'Please enter a valid email';
        }
        break;
      case 'agentContact':
        final phoneRegex = RegExp(r'^\d{10}$');
        if (!phoneRegex.hasMatch(value)) {
          return 'Please enter a valid 10-digit contact number';
        }
        break;
      case 'registrationNumber':
        final regNoRegex = RegExp(r'^[A-Z]{2}[0-9]{2}[A-Z]{2}[0-9]{4}$');
        if (!regNoRegex.hasMatch(value)) {
          return 'Please enter a valid registration number (e.g., MH02AB1234)';
        }
        break;
    }
    return null;
  }

  Widget _buildTextField(String key, String label, String placeholder,
      {bool isOptional = false}) {
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
              validator: isOptional
                  ? null
                  : (value) => value == null ? 'Enter $label' : _validateField(key, value),
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
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Vehicle & Agent Information',
            style: TextStyle(color: Colors.white),
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
                        _buildTextField(
                            'otherCoverage',
                            'Other Coverage (Optional)',
                            'Enter other coverage if any',
                            isOptional: true),
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
                          'Producer Information',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo),
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                            'agentName', 'Producer Name', 'Enter Producer name'),
                        _buildTextField(
                            'agentEmail', 'Producer Email', 'Enter email'),
                        _buildTextField('agentContact', 'Producer Contact',
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
                  final quotation = _validateAndCreateQuotation();
                  if (quotation != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PdfSelectionScreen(finalData: quotation),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo[100],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  //'SHARE (PDF)',
                  'Next',
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
