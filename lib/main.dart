import 'package:flutter/material.dart';
import 'package:motor_insurance_app/screens/auth/subscribe_screen.dart';
import 'package:motor_insurance_app/screens/dashboard/claimCalculator/claimCalulator_Type.dart';
import 'package:motor_insurance_app/screens/dashboard/claimCalculator/odClaim_screen.dart';
import 'package:motor_insurance_app/screens/dashboard/claimCalculator/tpClaim_screen.dart';
import 'package:motor_insurance_app/screens/vehicle/calculation_form_screen.dart';
import 'package:motor_insurance_app/screens/dashboard/home_screen.dart';
import 'package:motor_insurance_app/screens/auth/login_screen.dart';
import 'package:motor_insurance_app/screens/auth/splash_screen.dart';
import 'package:motor_insurance_app/screens/vehicle/goods_carrying_vehicle/electric_goods_carrying_screen.dart';
import 'package:motor_insurance_app/screens/vehicle/goods_carrying_vehicle/erickshaw_goods_carrying.dart';
import 'package:motor_insurance_app/screens/vehicle/goods_carrying_vehicle/goods_Carrying_vehicle.dart';
import 'package:motor_insurance_app/screens/vehicle/goods_carrying_vehicle/three_wheeler_goods_carrying.dart';
import 'package:motor_insurance_app/screens/vehicle/miscellaneous_vehicle/hearses_screen.dart';
import 'package:motor_insurance_app/screens/vehicle/miscellaneous_vehicle/other_misc_screen.dart';
import 'package:motor_insurance_app/screens/vehicle/miscellaneous_vehicle/pedestrian_agriculture_tractors_screen.dart';
import 'package:motor_insurance_app/screens/vehicle/miscellaneous_vehicle/trailer_and_other_misc_screen.dart';
import 'package:motor_insurance_app/screens/vehicle/miscellaneous_vehicle/trailer_screen.dart';
import 'package:motor_insurance_app/screens/vehicle/private_car/epc_form_1yod.dart';
import 'package:motor_insurance_app/screens/vehicle/private_car/epc_form_1yod_1tp.dart';
import 'package:motor_insurance_app/screens/vehicle/private_car/epc_form_1yod_3tp.dart';
import 'package:motor_insurance_app/screens/vehicle/private_car/epc_form_complete.dart';
import 'package:motor_insurance_app/screens/vehicle/private_car/pc_form_1yod.dart';
import 'package:motor_insurance_app/screens/vehicle/private_car/pc_form_1yod_1ytp.dart';
import 'package:motor_insurance_app/screens/vehicle/private_car/pc_form_1yod_3ytp.dart';
import 'package:motor_insurance_app/screens/vehicle/private_car/pc_form_complete.dart';
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
import 'package:motor_insurance_app/screens/vehicle/passenger_carrying_vehicle/three_wheeler_pcv_upto6_passenger.dart';
import 'package:motor_insurance_app/screens/vehicle/passenger_carrying_vehicle/taxi_form_screen.dart';
import 'package:motor_insurance_app/screens/vehicle/passenger_carrying_vehicle/three_wheeler_pcv_form_screen.dart';
import 'package:motor_insurance_app/screens/vehicle/passenger_carrying_vehicle/school_bus_form_screen.dart';
import 'package:motor_insurance_app/screens/vehicle/passenger_carrying_vehicle/bus_upto_6_form_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:motor_insurance_app/screens/auth/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MotorInsuranceApp());
}

class MotorInsuranceApp extends StatelessWidget {
  const MotorInsuranceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Insurance Calculator (Motor)',
      debugShowCheckedModeBanner: false, // This removes the debug banner

      theme: ThemeData(primarySwatch: Colors.indigo),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/subscribe': (context) => SubscribeScreen(),
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
        '/twoWheeler1YearOD1YearTP': (context) =>
            const TwoWheeler1YearOD1YearTPFormScreen(),
        '/twoWheeler1YearOD5YearTP': (context) =>
            const TwoWheeler1YearOD5YearTPFormScreen(),
        '/electricTwoWheeler1YearOD': (context) =>
            const ElectricTwoWheeler1YODFormScreen(),
        '/electricTwoWheeler1YearOD1YearTP': (context) =>
            const ElectricTwoWheeler1YearOD1YearTPFormScreen(),
        '/electricTwoWheeler1YearOD5YearTP': (context) =>
            const ElectricTwoWheeler1YOD5YTPFormScreen(),
        '/twoWheelerPassengerCarrying': (context) =>
            const TwoWheelerPassengerCarryingFormScreen(),

        // Car Routes
        '/privateCar1YearOD': (context) => const PCForm1YOD(),
        '/privateCar1YearOD1YearTP': (context) => const PCForm1YOD1TP(),
        '/privateCar1YearOD3YearsTP': (context) => const PCForm1YOD3TP(),
        '/privateCarComplete': (context) => const PCFormComplete(),
        '/electricPrivateCar1YearOD': (context) => const EPCForm1YOD(),
        '/electricPrivateCar1YearOD1YearTP': (context) =>
            const EPCForm1YOD1TP(),
        '/electricPrivateCar1YearOD3YearsTP': (context) =>
            const EPCForm1YOD3TP(),
        '/electricPrivateCarComplete': (context) => const EPCFormComplete(),

        // Goods Vehicle Routes
        '/goodsCarryingVehicle': (context) =>
            const GoodsCarryingVehicleScreen(),
        '/electricGoodsCarryingVehicle': (context) =>
            const ElectricGoodsCarryingScreen(),
        '/threeWheelerGoodsCarrying': (context) =>
            const ThreeWheelerGoodsScreen(),
        '/eRickshawGoodsCarrying': (context) => const ERickshawGoodsScreen(),

        // Passenger Vehicle Routes
        '/threeWheelerPCVUpto6': (context) =>
            const ThreeWheelerPCV_upto6Passenger(),
        '/threeWheelerPCVMoreThan6': (context) =>
            const ThreeWheelerPCVFormScreen(),
        '/busUpto6': (context) => const BusUpto6FormScreen(),
        '/taxiUpto6': (context) => const TaxiFormScreen(),
        '/schoolBus': (context) => const SchoolBusFormScreen(),

        // Miscellaneous Routes
        '/ambulance': (context) => const AmbulanceFormScreen(),
        '/trailer': (context) => const TrailerFormScreen(),
        '/hearses': (context) => const HearsesFormScreen(),
        '/agriculturalTractors': (context) =>
            const AgricultureTractorFormScreen(),
        '/trailerAndOtherMisc': (context) => const TrailerAndOtherFormScreen(),
        '/otherMiscVehicle': (context) => const OtherMiscFormScreen(),

        '/ClaimcalulatorType': (context) => const ClaimcalulatorType(),
        '/TpclaimScreen': (context) => const TpclaimScreen(),
        '/OdclaimScreen': (context) => const OdclaimScreen(),
      },
    );
  }
}
