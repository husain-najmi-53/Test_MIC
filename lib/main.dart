import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:motor_insurance_app/notification_services/flutter_local_notification_service.dart';
import 'package:motor_insurance_app/screens/auth/auth_service.dart';
import 'package:motor_insurance_app/screens/auth/single_device_check.dart';
import 'package:motor_insurance_app/screens/auth/subscribe_screen.dart';
import 'package:motor_insurance_app/screens/custom/drawer/app_features_screen.dart';
import 'package:motor_insurance_app/screens/custom/drawer/handbook_screen.dart';
import 'package:motor_insurance_app/screens/custom/drawer/rate_app_screen.dart';
import 'package:motor_insurance_app/screens/custom/drawer/share_app_screen.dart';
import 'package:motor_insurance_app/screens/custom/drawer/update_app_screen.dart';
import 'package:motor_insurance_app/screens/custom/drawer/whatsapp_us_screen.dart';
import 'package:motor_insurance_app/screens/custom/profile.dart';
import 'package:motor_insurance_app/screens/dashboard/claimCalculator/claimCalulator_Type.dart';
import 'package:motor_insurance_app/screens/dashboard/claimCalculator/odClaim_screen.dart';
import 'package:motor_insurance_app/screens/dashboard/claimCalculator/tpClaim_screen.dart';
import 'package:motor_insurance_app/screens/notification_screens/tipsNTricks_screen.dart';
import 'package:motor_insurance_app/screens/notification_screens/versionUpdate_screen.dart';
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
import 'package:timezone/data/latest.dart';
import 'notification_services/firebase_notification_service.dart';
import 'package:motor_insurance_app/screens/custom/setting_page.dart';
import 'package:motor_insurance_app/screens/auth/navigation_service.dart';

//final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseNotificationService.initialize();
  initializeTimeZones(); // since we are using timezone package to schedule
  final notificationService = FlutterLocalNotificationService();
  await notificationService.initNotification();

  if (Platform.isAndroid) {
    final androidPlugin = notificationService.notificationPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    //final granted = await androidPlugin?.requestNotificationsPermission();
    //print("Android Notification Permission Granted: $granted");
  }

  runApp(const MotorInsuranceApp());
}

class MotorInsuranceApp extends StatefulWidget {
  const MotorInsuranceApp({super.key});

  @override
  State<MotorInsuranceApp> createState() => _MotorInsuranceAppState();
}

class _MotorInsuranceAppState extends State<MotorInsuranceApp> {

  //Timer? timer;

  @override
  void initState() {
    super.initState();
    User? user  = FirebaseAuth.instance.currentUser;
    if(user!=null){
      SingleDeviceCheck().startChecking(context, user.uid);
      // VerifySingleDeviceLogin();
    }
    // Configure Firebase Messaging
    onOpenAppFirebaseMessage();
    //onOpenAppFirebaseMessageWithDialog(); //will implement later
    onFirebaseNotificationClicked();
    checkInitialMessage(); //This is when app is closed  and then clicked on message
  }

  // verifySingleDeviceLogin(){
  //   User? user = AuthService().getCurrentUser();
  //   if(user!=null){
  //     timer = Timer.periodic(
  //       Duration(seconds: 10),
  //           (_)=>SingleDeviceCheck().checkAndPromptDeviceIdandAction(context,user.uid),
  //     );
  //   }else{
  //     //Navigator.pushReplacementNamed(context, '/login');
  //   }

  // }

  @override
  void dispose(){
    //timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoInsure',
      debugShowCheckedModeBanner: false, // This removes the debug banner
      navigatorKey: navigatorKey, // attach it here
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
        '/TipsNTricks': (context) =>  TipsNTricksScreen(),
        '/VersionUpdate': (context) =>  VersionUpdateScreen(),

        //Custom Drawer Routes
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsPage(),
        '/appFeatures': (context) => const AppFeaturesScreen(),
        '/updateApp': (context) => const UpdateApplicationScreen(),
        '/rateApp': (context) => const RateApplicationScreen(),
        '/whatsappUs': (context) => const WhatsAppUsScreen(),
        '/handbook': (context) => const HandbookScreen(),
        '/shareApp': (context) => const ShareAppScreen(),

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

  void onOpenAppFirebaseMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //print("onMessage: $message");
      String payloadData = jsonEncode(message.data);
      if (message.notification != null) {
        FlutterLocalNotificationService().showNotification(
            id: 0,
            title: message.notification!.title!,
            body: message.notification!.body!,
            payload: payloadData
        );
      }
    });
  }

  void onOpenAppFirebaseMessageWithDialog() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //print("📩 onMessage: ${message.data}");

      if (message.notification != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: navigatorKey.currentContext!,
            builder: (context) => AlertDialog(
              title: Text(message.notification!.title ?? "No Title"),
              content: Text(message.notification!.body ?? "No Body"),
              actions: [
                TextButton(
                  onPressed: () {},
                  child: const Text("Next"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel"),
                ),
              ],
            ),
          );
        });
      }
    });
  }

  void onFirebaseNotificationClicked() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      //print("📲 Notification clicked! Data: ${message.data}");

      // Example: Navigate to a details page
      if (message.data.containsKey('route')) {
        navigatorKey.currentState?.pushNamed(
          message.data['route'],
          arguments: message.data,
        );
      } else {
        //print("onFirebaseNotificationClicked Imvoled and title: ${message.notification?.title ?? "No Title"} body ${message.notification?.body ?? "No Body"}");

      }
    });

  }

  void checkInitialMessage() async {
    // When the app is completely terminated and opened via notification
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      // print("🚀 App opened from terminated state via notification!");
      // print("Data: ${initialMessage.data}");

      // Example 1: Navigate to a specific route
      if (initialMessage.data.containsKey('route')) {
        navigatorKey.currentState?.pushNamed(
          initialMessage.data['route'],
          arguments: initialMessage.data,
        );
      }
      else {
        // print("checkInitailMessage Imvoled and title: ${initialMessage.notification?.title ?? "No Title"} body ${initialMessage.notification?.body ?? "No Body"}");

      }
    }
  }
}

// Foreground (onMessage) → Handle while app is open.
// Background (onMessageOpenedApp) → User taps notification, app comes to foreground.
// Terminated (getInitialMessage) → App was killed, user taps notification, app launches.