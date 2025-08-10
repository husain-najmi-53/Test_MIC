import 'result_data.dart';

class QuotationData {
  final InsuranceResultData insuranceResult;

  // Vehicle info
  final String ownerName;
  final String make;
  final String model;
  final String registrationNumber;
  final String seatingCapacity;
  final String? otherCoverage;  // Optional field
  final DateTime policyStartDate;
  final DateTime policyEndDate;

  // Agent info
  final String agentName;
  final String agentEmail;
  final String agentContact;

  QuotationData({
    required this.insuranceResult,
    required this.ownerName,
    required this.make,
    required this.model,
    required this.registrationNumber,
    required this.seatingCapacity,
    this.otherCoverage,  // Made optional
    required this.policyStartDate,
    required this.policyEndDate,
    required this.agentName,
    required this.agentEmail,
    required this.agentContact,
  });
}
