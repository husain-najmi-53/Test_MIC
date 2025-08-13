import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motor_insurance_app/models/idv_data.dart';

class IdvMaster extends StatefulWidget {
  const IdvMaster({Key? key}) : super(key: key);

  @override
  State<IdvMaster> createState() => _IdvMasterState();
}

class _IdvMasterState extends State<IdvMaster> {
  final ScrollController _scrollController = ScrollController();
  bool _showLastContainer = false;
  Map<String, dynamic> vehiclesData=VehicleData().vehiclesData;
  DateTime now = DateTime.now();
  List<String> vTypes = ['Bike','Private Car','Goods Carrying Vehicle','Passenger Carrying Vehicle','Miscellaneous Vehicle'];
  List<String> mTypes = ['--Select Make--'];
  List<String> yearList = ['--Select Year--'];
  List<String> mdTypes = ['--Select Model--'];
  List<String> vrTypes = ['--Select Varient--'];
  List<String> monthList = ["January", "Febuary", "March","April","May","June","July","August","September","October","November","December"];
  List<String> currentYearMonth =[];


  Map<String, dynamic> vehiclesResult={};
  double? idv;

  String? selectedVehicleType;
  String? selectedMakeType;
  String? selectedModelType;
  String? selectedVarientType;
  String? selectedMonth;
  String? selectedYear;

  void _showAndScroll() {
    setState(() {
      _showLastContainer = true;  //through this bool value we are refreshing page
    });

    // Wait for the UI to update before scrolling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
  }

  UpdateCurrentYearMonth(List<String> months){
    if(int.parse(selectedYear!)==now.year){
      for(int i=0;i<now.month;i++){
        currentYearMonth.add(months[i]);
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double fontSize = width < 360 ? 14 : 16; // Adaptive font size

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade700,
        iconTheme: const IconThemeData(color: Colors.white),

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        title: Text(
          "IDV Master",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0.03),
                  _idvFields(
                    height: height,
                    fieldName: 'Vehicle Type',
                    fieldValue: selectedVehicleType,
                    fieldList: vTypes,
                    onChanged: (val) => setState(() {
                      selectedVehicleType = val;
                      mTypes = vehiclesData[selectedVehicleType].keys.toList();
                      selectedMakeType=null;
                      selectedYear=null;
                      selectedModelType=null;
                      selectedVarientType=null;
                    }),
                  ),
                  _idvFields(
                    height: height,
                    fieldName: 'Make',
                    fieldValue: selectedMakeType,
                    fieldList: mTypes,
                    onChanged: (val) => setState(() {
                      selectedMakeType = val;
                      // mdTypes = vehiclesData[selectedVehicleType][selectedMakeType].keys.toList();
                      yearList = vehiclesData[selectedVehicleType][selectedMakeType].keys.toList();
                      selectedYear=null;
                      selectedModelType=null;
                      selectedVarientType=null;
                    }),
                  ),
                  _idvFields(
                    height: height,
                    fieldName: 'Year of Manufacture',
                    fieldValue: selectedYear,
                    fieldList: yearList,
                    onChanged: (val) => setState(() {
                      currentYearMonth=[];
                      selectedYear = val;
                      mdTypes = vehiclesData[selectedVehicleType][selectedMakeType][selectedYear].keys.toList();
                      selectedModelType=null;
                      selectedVarientType=null;
                      UpdateCurrentYearMonth(monthList);
                    }),
                  ),
                  _idvFields(
                    height: height,
                    fieldName: 'Month',
                    fieldValue: selectedMonth,
                    fieldList: selectedYear != null && int.parse(selectedYear!)==now.year? currentYearMonth:monthList,
                    onChanged: (val) => setState(() {
                      selectedMonth = val;

                    }),
                  ),
                  _idvFields(
                    height: height,
                    fieldName: 'Model',
                    fieldValue: selectedModelType,
                    fieldList: mdTypes,
                    onChanged: (val) => setState(() {
                      selectedModelType = val;
                      vrTypes = vehiclesData[selectedVehicleType][selectedMakeType][selectedYear][selectedModelType].keys.toList();
                      selectedVarientType=null;
                    }),
                  ),
                  _idvFields(
                    height: height,
                    fieldName: 'Variant',
                    fieldValue: selectedVarientType,
                    fieldList: vrTypes,
                    onChanged: (val) => setState(() {
                      selectedVarientType = val;
                    }),
                  ),
                  SizedBox(height: height * 0.02),
                  SizedBox(
                    width: width * 0.6,
                    child: ElevatedButton(
                      onPressed: () {
                        validate();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        "Get IDV",
                        style: GoogleFonts.poppins(
                          color: Colors.white,

                          fontSize: fontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.04),

                  /// ✅ Professional Responsive Receipt
                  vehiclesResult.isNotEmpty?  _buildReceiptCard(width, fontSize):const SizedBox(),
                ],
              ),
            ),
          );
        },
      ),
    );



  }

  /// ✅ Dropdown Field
  Widget _idvFields({
    required double height,
    required String fieldName,
    required List<String> fieldList,
    String? fieldValue,
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
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: fieldValue,
              underline: const SizedBox(),
              isExpanded: true,
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(12),
              onChanged: onChanged,
              hint: Text('Select ${fieldName}'),
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

  /// ✅ Responsive Receipt Card
  Widget _buildReceiptCard(double width, double fontSize) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Colors.indigo.withOpacity(0.4),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.receipt_long, color: Colors.indigo.shade300, size: 28),
                const SizedBox(width: 10),
                Text(
                  "IDV Receipt",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize + 4,
                    color: Colors.indigo.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: Colors.grey.shade300, thickness: 1),
            const SizedBox(height: 8),

            /// Details
            /* _buildDetailTile("Body Type", "ERICKAHAW", Icons.directions_car),
            _buildDetailTile("CC/GVW/Watt", "1", Icons.speed),
            _buildDetailTile("Fuel Type", "Electric", Icons.local_gas_station),
            _buildDetailTile("Seating Capacity", "4", Icons.event_seat),
            _buildDetailTile("Ex-Showroom Price", "₹1,40,000.00", Icons.attach_money),*/

            _buildDetailTile("Body Type", vehiclesResult['bodyType'], Icons.directions_car) ,
            _buildDetailTile("CC/GVW/Watt", vehiclesResult['watt']==null? vehiclesResult['cc'].toString():vehiclesResult['watt'].toString(), Icons.speed),
            _buildDetailTile("Fuel Type", vehiclesResult['fuelType'], Icons.local_gas_station),
            _buildDetailTile("Seating Capacity", vehiclesResult['seating'].toString(), Icons.event_seat),
            _buildDetailTile("Ex-Showroom Price", vehiclesResult['exShowroom'].toString(), Icons.attach_money),

            const SizedBox(height: 15),

            /// IDV Amount Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.shade100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Current IDV",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize + 4,
                      color: Colors.indigo.shade700,
                    ),
                  ),
                  Text(
                    idv.toString(),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize + 2,
                      color: Colors.indigo.shade900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Receipt Detail Tile
  Widget _buildDetailTile(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.indigo.shade300, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  validate() {
    if(selectedVehicleType!=null && selectedMakeType!=null && selectedModelType!=null && selectedVarientType!=null && selectedMonth!=null&&selectedYear!=null &&
        selectedVehicleType!.isNotEmpty && selectedMakeType!.isNotEmpty && selectedModelType!.isNotEmpty && selectedVarientType!.isNotEmpty&&selectedYear!.isNotEmpty&&selectedMonth!.isNotEmpty){

      //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Success")));
      setState(() {
        vehiclesResult = vehiclesData[selectedVehicleType][selectedMakeType][selectedYear][selectedModelType][selectedVarientType];
      });
      calculate();
      _showAndScroll();

    }else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fields Can't be Empty")));
    }

  }

  void calculate() {
    DateTime now = DateTime.now();
    //int currentMonth = now.month;
    //int currentYear = now.year;
    int vehicleMonths = monthList.indexOf(selectedMonth!)+1;
    DateTime previousDate = DateTime(int.parse(selectedYear!), vehicleMonths);
    int monthDif = monthDifference(previousDate, now);
    int yearDif = getYearDifference(vehicleMonths, int.parse(selectedYear!));

    if(yearDif<=1){
      if(monthDif<=6){
        double depAmount =  vehiclesResult['exShowroom']*5/100.toInt();
        idv = vehiclesResult['exShowroom']-depAmount;
        setState(() {idv;});
      }else{
        double depAmount =  vehiclesResult['exShowroom']*15/100.toInt();
        idv = vehiclesResult['exShowroom']-depAmount;
        setState(() {idv;});
      }
    }

    if(yearDif>1 && yearDif<=2){
      double depAmount =  vehiclesResult['exShowroom']*20/100;
      idv = vehiclesResult['exShowroom']-depAmount;
      setState(() {idv;});
    }
    if(yearDif>2 && yearDif<=3){
      double depAmount =  vehiclesResult['exShowroom']*30/100;
      idv = vehiclesResult['exShowroom']-depAmount;
      setState(() {idv;});
    }
    if(yearDif>3 && yearDif<=4){
      double depAmount =  vehiclesResult['exShowroom']*40/100;
      idv = vehiclesResult['exShowroom']-depAmount;
      setState(() {idv;});
    }
    if(yearDif>4 && yearDif<=5){
      double depAmount =  vehiclesResult['exShowroom']*50/100;
      idv = vehiclesResult['exShowroom']-depAmount;
      setState(() {idv;});
    }

    if(yearDif>5){
      setState(() {
        idv = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Contact with Agent to Evaluate IDV of Vehicle Above 5 Years "),duration: Duration(seconds: 3),));
    }


  }

  int monthDifference(DateTime start, DateTime end) {
    return (end.year - start.year) * 12 + (end.month - start.month);
  }
  int getYearDifference(int previousMonth, int previousYear) {
    DateTime now = DateTime.now();
    DateTime previousDate = DateTime(previousYear, previousMonth);

    int yearDiff = now.year - previousDate.year;

    // Adjust if the current month is earlier than the previous month
    if (now.month < previousDate.month) {
      yearDiff -= 1;
    }

    return yearDiff;
  }


}
