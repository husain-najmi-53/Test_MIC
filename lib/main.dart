import 'package:flutter/material.dart';
import 'package:motor_insurance_app/screens/vehicle/calculation_form_screen.dart';
import 'package:motor_insurance_app/screens/dashboard/home_screen.dart';
import 'package:motor_insurance_app/screens/auth/login_screen.dart';
import 'package:motor_insurance_app/screens/auth/splash_screen.dart';
import 'package:motor_insurance_app/screens/vehicle/vehicle_type_screen.dart';
import 'package:motor_insurance_app/screens/dashboard/idv_master.dart';
import 'package:motor_insurance_app/screens/dashboard/rtoZone_finder.dart';
import 'package:motor_insurance_app/screens/dashboard/cashlessGarage_list.dart';
import 'package:motor_insurance_app/screens/dashboard/companyDetail_list.dart';
import 'package:motor_insurance_app/screens/vehicle/miscellaneous_vehicle/ambulance_form.dart';
import 'package:motor_insurance_app/screens/vehicle/bike/twoWheeler1YearOD.dart';
import 'package:motor_insurance_app/screens/vehicle/bike/twoWheeler1YearOD1YearTP.dart';
import 'package:motor_insurance_app/screens/vehicle/bike/twoWheeler1YearOD5YearTP.dart';
import 'package:motor_insurance_app/screens/vehicle/bike/electricTwoWheeler1YearOD.dart';
import 'package:motor_insurance_app/screens/vehicle/bike/electricTwoWheeler1YearOD1YearTP.dart'; 
import 'package:motor_insurance_app/screens/vehicle/bike/electricTwoWheeler1YearOD5YearTP.dart';
import 'package:motor_insurance_app/screens/vehicle/bike/twoWheelerPassengerCarrying.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MotorInsuranceApp());
}

class MotorInsuranceApp extends StatelessWidget {
  const MotorInsuranceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motor Insurance Calculator',
      debugShowCheckedModeBanner: false, // This removes the debug banner

      theme: ThemeData(primarySwatch: Colors.indigo),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/vehicleType': (context) => const VehicleTypeScreen(),
        '/RtoZoneFinder': (context) => const RtoZoneFinder(),
        '/IdvMaster': (context) => const IdvMaster(),
        '/CompanyDetails': (context) => const CompanydetailList(),
        '/CashlessGarage': (context) => const CashlessgarageList(),
        '/calculationForm': (context) {
          final selectedType =
              ModalRoute.of(context)?.settings.arguments as String? ?? '';
          return CalculationFormScreen(selectedType: selectedType);
        },

        // Bike Routes
      '/twoWheeler1YearOD': (context) => const TwoWheeler1YearODFormScreen(),
      '/twoWheeler1YearOD1YearTP': (context) => const TwoWheeler1YearOD1YearTPFormScreen(),
      '/twoWheeler1YearOD5YearTP': (context) => const TwoWheeler1YearOD5YearTPFormScreen(),
      '/electricTwoWheeler1YearOD': (context) => const ElectricTwoWheeler1YODFormScreen(),
      '/electricTwoWheeler1YearOD1YearTP': (context) => const ElectricTwoWheeler1YearOD1YearTPFormScreen(),
      '/electricTwoWheeler1YearOD5YearTP': (context) => const ElectricTwoWheeler1YOD5YTPFormScreen(),
      '/twoWheelerPassengerCarrying': (context) => const TwoWheelerPassengerCarryingFormScreen(),

      // Car Routes
      // '/privateCar1YearOD': (context) => const CarFormScreen(),
      // '/privateCar1YearOD1YearTP': (context) => const CarFormScreen(),
      // '/privateCar1YearOD3YearsTP': (context) => const CarFormScreen(),
      // '/privateCarComplete': (context) => const CarFormScreen(),
      // '/electricPrivateCar1YearOD': (context) => const ElectricCarFormScreen(),
      // '/electricPrivateCar1YearOD1YearTP': (context) => const ElectricCarFormScreen(),
      // '/electricPrivateCar1YearOD3YearsTP': (context) => const ElectricCarFormScreen(),
      // '/electricPrivateCarComplete': (context) => const ElectricCarFormScreen(),

      // Goods Vehicle Routes
      // '/goodsCarryingVehicle': (context) => const TruckFormScreen(),
      // '/electricGoodsCarryingVehicle': (context) => const TruckFormScreen(),
      // '/threeWheelerGoodsCarrying': (context) => const TruckFormScreen(),
      // '/eRickshawGoodsCarrying': (context) => const TruckFormScreen(),

      // Passenger Vehicle Routes
      // '/threeWheelerPCVUpto6': (context) => const BusFormScreen(),
      // '/threeWheelerPCVMoreThan6': (context) => const BusFormScreen(),
      // '/taxiUpto6': (context) => const BusFormScreen(),
      // '/bus': (context) => const BusFormScreen(),
      // '/schoolBus': (context) => const BusFormScreen(),

      // Miscellaneous Routes
      '/ambulance': (context) => const AmbulanceFormScreen(),
      // '/trailer': (context) => const TruckFormScreen(),
      // '/hearses': (context) => const TruckFormScreen(),
      // '/agriculturalTractors': (context) => const TruckFormScreen(),
      // '/trailerAndOtherMisc': (context) => const TruckFormScreen(),
      // '/otherMiscVehicle': (context) => const TruckFormScreen(),
    },

    // Fallback if route doesn't exist
    // onUnknownRoute: (settings) {
    //   return MaterialPageRoute(
    //     builder: (context) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         const SnackBar(content: Text('Route not found')),
    //       );
    //       return const VehicleTypeScreen();
    //     },
    //   );
    // }
    );
  }
}
