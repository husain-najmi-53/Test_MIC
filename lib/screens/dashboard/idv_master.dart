import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IdvMaster extends StatefulWidget {
  const IdvMaster({Key? key}) : super(key: key);

  @override
  State<IdvMaster> createState() => _IdvMasterState();
}

class _IdvMasterState extends State<IdvMaster> {
  List<String> vTypes = ["VehicleType1", "VehicleType2", "VehicleType3"];
  List<String> mTypes = ["MakeType1", "MakeType2", "MakeType3"];
  List<String> mdTypes = ["ModelType1", "ModelType2", "ModelType3"];
  List<String> vrTypes = ["VarientType1", "VarientType2", "VarientType3"];
  List<String> yearList = ["2000", "2010", "2015"];

  String? selectedVehicleType;
  String? selectedMakeType;
  String? selectedModelType;
  String? selectedVarientType;
  String? selectedYear;
  String? calculatedIdv = "";

  @override
  void initState() {
    super.initState();
    myMethod();
  }

  void myMethod() {
    selectedVehicleType = vTypes.first;
    selectedMakeType = mTypes.first;
    selectedModelType = mdTypes.first;
    selectedVarientType = vrTypes.first;
    selectedYear = yearList.first;
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
                    }),
                  ),
                  _idvFields(
                    height: height,
                    fieldName: 'Make',
                    fieldValue: selectedMakeType,
                    fieldList: mTypes,
                    onChanged: (val) => setState(() {
                      selectedMakeType = val;
                    }),
                  ),
                  _idvFields(
                    height: height,
                    fieldName: 'Model',
                    fieldValue: selectedModelType,
                    fieldList: mdTypes,
                    onChanged: (val) => setState(() {
                      selectedModelType = val;
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
                  _idvFields(
                    height: height,
                    fieldName: 'Year of Manufacture',
                    fieldValue: selectedYear,
                    fieldList: yearList,
                    onChanged: (val) => setState(() {
                      selectedYear = val;
                    }),
                  ),
                  SizedBox(height: height * 0.02),
                  SizedBox(
                    width: width * 0.6,
                    child: ElevatedButton(
                      onPressed: () {},
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
                  _buildReceiptCard(width, fontSize),
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
              value: fieldValue ?? fieldList.first,
              underline: const SizedBox(),
              isExpanded: true,
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(12),
              onChanged: onChanged,
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
            _buildDetailTile("Body Type", "ERICKAHAW", Icons.directions_car),
            _buildDetailTile("CC/GVW/Watt", "1", Icons.speed),
            _buildDetailTile("Fuel Type", "Electric", Icons.local_gas_station),
            _buildDetailTile("Seating Capacity", "4", Icons.event_seat),
            _buildDetailTile("Ex-Showroom Price", "₹1,40,000.00", Icons.attach_money),

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
                    "₹1,80,300.00",
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
}
