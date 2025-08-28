import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TpclaimScreen extends StatefulWidget {
  const TpclaimScreen({Key? key}) : super(key: key);

  @override
  State<TpclaimScreen> createState() => _TpclaimScreenState();
}

class _TpclaimScreenState extends State<TpclaimScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  //----------------Tab1 -----------------------
  final GlobalKey<FormState> _injuryKey = GlobalKey<FormState>();
  TextEditingController ageController = TextEditingController();
  TextEditingController injuryGrossAnnualIncomeController =
      TextEditingController();
  TextEditingController injuryDisabilityPercentController =
      TextEditingController();
  TextEditingController extraExpenseController = TextEditingController();
  TextEditingController injurySpecialExpenseController =
      TextEditingController();
  // String? _selectedMarriedStatus;
  String? _selectedInjuryEmploymentType;
  String? _selectedInjuryJobType;
  double injuryCompensation = 0;
  double injuryLiabilityFault = 0;

  // List<String> marriedStatusOption = ["Married","Unmarried"];
  List<String> injuryEmploymentTypeOption = [
    "Salaried",
    "Self-Employed",
    "Student"
  ];
  List<String> injuryJobTypeOption = ["Permanent", "Contractual"];
  //-----------------***************--------------------
  //-----------------Tab2-----------------------
  final GlobalKey<FormState> _deathKey = GlobalKey<FormState>();
  TextEditingController deathAgeController = TextEditingController();
  TextEditingController grossAnnualIncomeController = TextEditingController();
  TextEditingController deathSpecialExpenseController = TextEditingController();
  String? _selectedDeathMarriedStatus;
  String? _selectedEmploymentType;
  String? _selectedJobType;
  String? _selectedDependentNumber;
  double deathCompensation = 0;
  double deathLiabilityFault = 0;

  List<String> deathMarriedStatusOption = ["Married", "Unmarried"];
  List<String> employmentTypeOption = ["Salaried", "Self-Employed", "Student"];
  List<String> jobTypeOption = ["Permanent", "Temporary"];
  List<String> dependentNumberOption = [
    "None",
    "1",
    "2",
    "3",
    "4",
    "5",
    " 6",
    "Above 6"
  ];

  bool isTab1 = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  updateTab(val) {
    //print(val);
    if (isTab1) {
      setState(() {
        isTab1 = false;
      });
    } else {
      setState(() {
        isTab1 = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('TP Claim Calculator',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade700,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        // color: Colors.red,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.indigo.shade100,
                //color: Colors.indigo.shade700,
                child: TabBar(
                    controller: tabController,
                    labelStyle: GoogleFonts.poppins(
                        color: Colors.indigo.shade800,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    indicatorColor: Colors.indigo.shade800,
                    indicatorSize: TabBarIndicatorSize.tab,
                    onTap: (index) {
                      print("Tapped tab index: $index");
                      updateTab(index);
                    },
                    tabs: [
                      Tab(
                        text: "INJURY",
                      ),
                      Tab(
                        text: "DEATH",
                      ),
                    ]),
              ),
              Container(
                  height: height + height * 0.2,
                  // color: Colors.red,
                  child: Stack(
                    fit: StackFit.loose,
                    children: [
                      Container(
                        height: height * 0.12,
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade100,
                          //color: Colors.indigo.shade700,
                        ),
                      ),
                      Positioned(
                          top: 15,
                          left: 20,
                          child: Container(
                            height: height + height * 0.15,
                            width: width * 0.9,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                // color: Colors.indigo.shade200,
                                // color: Colors.blue.shade200,
                                borderRadius: BorderRadius.circular(12),
                                // border: Border.fromBorderSide(BorderSide(color: Colors.indigo.shade700)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey
                                        .withOpacity(0.5), // Shadow color
                                    spreadRadius: 2, // Spread radius
                                    blurRadius: 7,
                                    offset: const Offset(0, 4),
                                  ),
                                ]),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 12),
                                child: TabBarView(
                                    controller: tabController,
                                    physics: NeverScrollableScrollPhysics(),
                                    children: [
                                      buildInjuryTab(height),
                                      buildDeathTab(height)
                                    ])),
                          ))
                    ],
                  )),
              SizedBox(
                height: height * 0.05,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDeathTab(double height) {
    return Form(
      key: _deathKey,
      child: Column(
        children: [
          _textFields(
            height: height,
            fieldName: 'Age of Injured Person',
            hint: 'Years',
            controller: deathAgeController,
            validator: (val) {
              if (val == null || val.isEmpty) {
                return "Please enter value";
              } else {
                return null;
              }
            },
          ),
          _Fields(
              height: height,
              fieldName: "Marital Status",
              fieldList: deathMarriedStatusOption,
              onChanged: (val) {
                setState(() {
                  _selectedDeathMarriedStatus = val;
                });
              },
              fieldValue: _selectedDeathMarriedStatus),
          _Fields(
              height: height,
              fieldName: "Employment Nature",
              fieldList: employmentTypeOption,
              onChanged: (val) {
                setState(() {
                  _selectedEmploymentType = val;
                });
              },
              fieldValue: _selectedEmploymentType),
          _selectedEmploymentType == "Student"
              ? SizedBox()
              : _Fields(
                  height: height,
                  fieldName: "Job Type",
                  fieldList: jobTypeOption,
                  onChanged: (val) {
                    setState(() {
                      _selectedJobType = val;
                    });
                  },
                  fieldValue: _selectedJobType),
          _selectedEmploymentType == "Student"
              ? SizedBox()
              : _textFields(
                  height: height,
                  fieldName: 'Gross Annual Income',
                  controller: grossAnnualIncomeController,
                  hint: 'Enter Amount (in INR)',
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Please enter value";
                    } else {
                      return null;
                    }
                  },
                ),
          _textFields(
            height: height,
            fieldName: 'Sum Special Damage (Medical, Transport etc)',
            controller: deathSpecialExpenseController,
            hint: 'Enter Amount (in INR)',
            validator: (val) {
              if (val == null || val.isEmpty) {
                return "Please enter value";
              } else {
                return null;
              }
            },
          ),
          _selectedEmploymentType == "Student"
              ? SizedBox()
              : _Fields(
                  height: height,
                  fieldName: "Number of Dependents",
                  fieldList: dependentNumberOption,
                  onChanged: (val) {
                    setState(() {
                      _selectedDependentNumber = val;
                    });
                  },
                  fieldValue: _selectedDependentNumber),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: ElevatedButton(
              onPressed: () {
                if (_deathKey.currentState!.validate() &&
                    _selectedDeathMarriedStatus != null &&
                    _selectedEmploymentType != null) {
                  if (_selectedEmploymentType != "Student" &&
                      _selectedDependentNumber == null &&
                      _selectedJobType == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please Select the required Field")));
                  } else {
                    setState(() {
                      deathCompensation = calculateDeathCompensation(
                        age: int.parse(deathAgeController.text.trim()),
                        maritalStatus: _selectedDeathMarriedStatus!,
                        numberOfDependents:
                            _selectedDependentNumber == "None" ||
                                    _selectedEmploymentType == "Student"
                                ? 0
                                : int.parse(_selectedDependentNumber!),
                        employmentNature: _selectedEmploymentType!,
                        jobType: _selectedEmploymentType == "Student"
                            ? "Temporary"
                            : _selectedJobType!,
                        grossAnnualIncome: _selectedEmploymentType == "Student"
                            ? 0
                            : 40000,
                      );
                      deathLiabilityFault = calculateFaultLiabilityDeath(
                          age: int.parse(deathAgeController.text.trim()),
                          maritalStatus: _selectedDeathMarriedStatus!,
                          numberOfDependents:
                              _selectedDependentNumber == "None" ||
                                      _selectedEmploymentType == "Student"
                                  ? 0
                                  : int.parse(_selectedDependentNumber!),
                          employmentNature: _selectedEmploymentType!,
                          jobType: _selectedEmploymentType == "Student"
                              ? "Temporary"
                              : _selectedJobType!,
                          grossAnnualIncome: _selectedEmploymentType == "Student"
                              ? 0
                              : 40000,
                          specialDamages: double.parse(
                              deathSpecialExpenseController.text.trim()));
                    });
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Please Select the required Field")));
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.indigo.shade700,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                "Calculate",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Text(
                "Structure Formula Compensation Available",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
              )),
          Container(
            height: 40,
            width: 180,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border.all(color: Colors.indigo.shade700),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(deathCompensation.toStringAsFixed(2)),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Text(
                "Fault Liability Compensation Payable",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
              )),
          Container(
            height: 40,
            width: 180,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border.all(color: Colors.indigo.shade700),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(deathLiabilityFault.toStringAsFixed(2)),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInjuryTab(double height) {
    return Form(
      key: _injuryKey,
      child: IntrinsicHeight(
        child: Column(
          children: [
            _textFields(
              height: height,
              fieldName: 'Age of Injured Person',
              hint: 'Years',
              controller: ageController,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "Please enter value";
                } else {
                  return null;
                }
              },
            ),
            // _Fields(height: height, fieldName: "Martial Status", fieldList: marriedStatusOption, onChanged: (val){setState(() {_selectedMarriedStatus=val;});}, fieldValue: _selectedMarriedStatus),
            _Fields(
                height: height,
                fieldName: "Employment Nature",
                fieldList: injuryEmploymentTypeOption,
                onChanged: (val) {
                  setState(() {
                    _selectedInjuryEmploymentType = val;
                  });
                },
                fieldValue: _selectedInjuryEmploymentType),
            _selectedInjuryEmploymentType == "Student"
                ? SizedBox()
                : _Fields(
                    height: height,
                    fieldName: "Job Type",
                    fieldList: injuryJobTypeOption,
                    onChanged: (val) {
                      setState(() {
                        _selectedInjuryJobType = val;
                      });
                    },
                    fieldValue: _selectedInjuryJobType),
            _textFields(
              height: height,
              fieldName: 'Disability Percent(%)',
              controller: injuryDisabilityPercentController,
              hint: 'Enter percent',
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "Please enter percent";
                } else {
                  return null;
                }
              },
            ),
            _selectedInjuryEmploymentType == "Student"
                ? SizedBox()
                : _textFields(
                    height: height,
                    fieldName: 'Gross Annual Income',
                    controller: injuryGrossAnnualIncomeController,
                    hint: 'Enter Amount (in INR)',
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Please enter value";
                      } else {
                        return null;
                      }
                    },
                  ),
            _textFields(
              height: height,
              fieldName:
                  'Sum of Extra Expense (Medical Expenses + Pain and Suffering + Loss of Amenities)',
              controller: extraExpenseController,
              hint: 'Enter Amount (in INR)',
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "Please enter value";
                } else {
                  return null;
                }
              },
            ),
            _textFields(
              height: height,
              fieldName:
                  'Sum Special Damage (Attendant, Transport, Diet, etc.)',
              controller: injurySpecialExpenseController,
              hint: 'Enter Amount (in INR)',
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "Please enter value";
                } else {
                  return null;
                }
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: ElevatedButton(
                onPressed: () {
                  if (_injuryKey.currentState!.validate() &&
                      _selectedInjuryEmploymentType != null) {
                    if (_selectedInjuryEmploymentType != "Student" &&
                        _selectedInjuryJobType == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Please Select the required Field")));
                    } else {
                      setState(() {
                        injuryCompensation = calculateInjuryCompensation(
                            age: int.parse(ageController.text.trim()),
                            employmentNature: _selectedInjuryEmploymentType!,
                            jobType: _selectedInjuryEmploymentType == "Student"
                                ? "Contractual"
                                : _selectedInjuryJobType!,
                            grossAnnualIncome: _selectedInjuryEmploymentType == "Student"
                                ? 0
                                : 40000,
                            disabilityPercent: double.parse(
                                injuryDisabilityPercentController.text.trim()),
                            extraExpenses: double.parse(
                                extraExpenseController.text.trim()));
                        injuryLiabilityFault = calculateFaultLiabilityInjury(
                            age: int.parse(ageController.text.trim()),
                            employmentNature: _selectedInjuryEmploymentType!,
                            jobType: _selectedInjuryEmploymentType == "Student"
                                ? "Contractual"
                                : _selectedInjuryJobType!,
                            grossAnnualIncome: _selectedInjuryEmploymentType == "Student"
                                ? 0
                                : 40000,
                            disabilityPercent: double.parse(
                                injuryDisabilityPercentController.text.trim()),
                            extraExpenses: double.parse(
                                extraExpenseController.text.trim()),
                            specialDamages: double.parse(
                                injurySpecialExpenseController.text.trim()));
                      });
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please Select the required Field")));
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.indigo.shade700,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  "Calculate",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Text(
                  "Structure Formula Compensation Avaiable",
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
                )),
            Container(
              height: 40,
              width: 180,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border.all(color: Colors.indigo.shade700),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(injuryCompensation.toStringAsFixed(2)),
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Text(
                  "Fault Liability Compensation Payable",
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
                )),
            Container(
              height: 40,
              width: 180,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border.all(color: Colors.indigo.shade700),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(injuryLiabilityFault.toStringAsFixed(2)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _Fields({
    required double height,
    required String fieldName,
    required List<String> fieldList,
    required String? fieldValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fieldName,
            style: GoogleFonts.poppins(
              color: Colors.indigo.shade700,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border.all(color: Colors.indigo.shade700),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: fieldValue,
              underline: const SizedBox(),
              isExpanded: true,
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(12),
              onChanged: onChanged,
              hint: Text(
                'Select ${fieldName}',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              items: fieldList
                  .map((element) => DropdownMenuItem(
                        value: element,
                        child: Text(element),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textFields({
    required double height,
    required String fieldName,
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fieldName,
            style: GoogleFonts.poppins(
              color: Colors.indigo.shade700,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
            style: GoogleFonts.poppins(fontSize: 14),
            validator: validator,
            decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.all(10),
                hintText: hint, // hide hint when filled
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Colors.indigo.shade700)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Colors.indigo.shade700)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Colors.indigo.shade700))),
          ),
        ],
      ),
    );
  }

  /// Get multiplier based on age (Sarla Verma Table)
  int getMultiplier(int age) {
    switch (age) {
      case <= 15:
        return 20;
      case <= 20:
        return 18;
      case <= 25:
        return 18;
      case <= 30:
        return 17;
      case <= 35:
        return 16;
      case <= 40:
        return 15;
      case <= 45:
        return 14;
      case <= 50:
        return 13;
      case <= 55:
        return 11;
      case <= 60:
        return 9;
      case <= 65:
        return 7;
      default:
        return 5; // Above 65
    }
  }

  /// Get future prospects percentage based on employment nature & job type
  double getFutureProspectsPercent(
      int age, String employmentNature, String jobType) {
    if (employmentNature == "Student") return 0.40;

    bool permanent = (employmentNature == "Salaried" && jobType == "Permanent");
    bool nonPermanent = (employmentNature == "Self-Employed" ||
        jobType == "Temporary" ||
        jobType == "Contractual");

    if (age < 40) return permanent ? 0.50 : 0.40;
    if (age <= 50) return permanent ? 0.30 : 0.25;
    if (age <= 60) return permanent ? 0.15 : 0.10;

    return 0.0;
  }

  // for Death case Deduction on basis of Martial Status
  double getDeductionPercent(String maritalStatus, int dependents) {
    if (maritalStatus.toLowerCase() == "Unmarried") return 0.50;

    return (dependents <= 3)
        ? (1 / 3) // 33.33%
        : (dependents <= 6)
            ? 0.25
            : 0.20;
  }

  /// Calculate Death Case Compensation (Accurate as per Sarla Verma & Pranay Sethi)
  double calculateDeathCompensation({
    required int age,
    required String maritalStatus, // "Married" or "Unmarried"
    required int numberOfDependents,
    required String employmentNature, // "Salaried", "Self-Employed", "Student"
    required String jobType, // "Permanent", "Temporary"
    required double grossAnnualIncome,
    double lossOfEstate = 15000,
    double funeralExpenses = 15000,
    double consortium = 40000,
  }) {
    int multiplier = getMultiplier(age);
    double futureProspectsPercent =
        getFutureProspectsPercent(age, employmentNature, jobType);

    // Step 1: Add future prospects
    double annualIncomeWithFuture =
        grossAnnualIncome * (1 + futureProspectsPercent);

    // Step 2: Deduct personal expenses
    double deductionPercent =
        getDeductionPercent(maritalStatus, numberOfDependents);
    double incomeAfterDeduction =
        annualIncomeWithFuture * (1 - deductionPercent);

    // Step 3: Apply multiplier for loss of dependency
    double lossOfDependency = incomeAfterDeduction * multiplier;

    // Step 4: Add conventional heads
    return lossOfDependency + lossOfEstate + funeralExpenses + consortium;
  }

  /// Calculate Injury Case Compensation
  double calculateInjuryCompensation({
    required int age,
    required String employmentNature, // Salaried/Self-Employed/Student
    required String jobType, // Permanent/Contractual
    required double grossAnnualIncome,
    required double
        disabilityPercent, // Functional disability to whole body (0–100)
    required double
        extraExpenses, // Sum of medicalExpenses + painAndSuffering +lossOfAmenities
  }) {
    int multiplier = getMultiplier(age);
    double futureProspectsPercent = getFutureProspectsPercent(
      age,
      employmentNature,
      jobType,
    );

    // Loss of earning capacity
    double annualIncomeWithFuture =
        grossAnnualIncome + (grossAnnualIncome * futureProspectsPercent);
    double lossOfEarningCapacity =
        annualIncomeWithFuture * (disabilityPercent / 100) * multiplier;

    // Total compensation
    double totalCompensation = lossOfEarningCapacity + extraExpenses;

    return totalCompensation;
  }

  double calculateFaultLiabilityDeath({
    required int age,
    required String maritalStatus, // "Married" / "Unmarried"
    required int numberOfDependents,
    required String
        employmentNature, // "Salaried" / "Self-Employed" / "Student"
    required String jobType, // "Permanent" / "Contractual"
    required double grossAnnualIncome, // actual income (no cap)
    double lossOfEstate = 15000,
    double funeralExpenses = 15000,
    double consortium = 40000,
    required double specialDamages, // medical bills, transport, etc.
  }) {
    int multiplier = getMultiplier(age);
    double futureProspectsPercent =
        getFutureProspectsPercent(age, employmentNature, jobType);

    // Step 1: Add future prospects to income (no cap)
    double annualIncomeWithFuture =
        grossAnnualIncome * (1 + futureProspectsPercent);

    // Step 2: Deduct personal expenses
    double deductionPercent =
        getDeductionPercent(maritalStatus, numberOfDependents);
    double incomeAfterDeduction =
        annualIncomeWithFuture * (1 - deductionPercent);

    // Step 3: Apply multiplier for Loss of Dependency
    double lossOfDependency = incomeAfterDeduction * multiplier;

    // Step 4: Add conventional heads + special damages
    return lossOfDependency +
        lossOfEstate +
        funeralExpenses +
        consortium +
        specialDamages;
  }

  double calculateFaultLiabilityInjury({
    required int age,
    required String
        employmentNature, // "Salaried" / "Self-Employed" / "Student"
    required String jobType, // "Permanent" / "Contractual"
    required double grossAnnualIncome,
    required double
        disabilityPercent, // functional disability to whole body (0–100)
    required double
        extraExpenses, // Sum of medicalExpenses + painAndSuffering +lossOfAmenities
    required double specialDamages, // attendant, transport, diet, etc.
  }) {
    int multiplier = getMultiplier(age);
    double futureProspectsPercent =
        getFutureProspectsPercent(age, employmentNature, jobType);

    // Step 1: Annual income with future prospects
    double annualIncomeWithFuture =
        grossAnnualIncome * (1 + futureProspectsPercent);

    // Step 2: Loss of earning capacity (disability applied)
    double lossOfEarningCapacity =
        annualIncomeWithFuture * (disabilityPercent / 100);

    // Step 3: Apply multiplier
    double futureLossOfEarnings = lossOfEarningCapacity * multiplier;

    // Step 4: Add medical bills + general damages
    return futureLossOfEarnings + extraExpenses + specialDamages;
  }
}
