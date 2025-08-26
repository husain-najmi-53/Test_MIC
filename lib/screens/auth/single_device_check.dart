
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:motor_insurance_app/screens/auth/auth_service.dart';
import 'package:uuid/uuid.dart';
import 'package:motor_insurance_app/screens/auth/navigation_service.dart';

class SingleDeviceCheck{

  /*Future<String?> getCurrentDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // Use androidInfo.androidId as unique device ID
      return androidInfo.id.toString();
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      // Use iosInfo.identifierForVendor as device ID
      return iosInfo.identifierForVendor;
    }
    return null;
  }*/

  Timer? _timer;

  static final _storage = FlutterSecureStorage();
  static const _keyDeviceId = "device_id";


  /// Start periodic checking
  void startChecking(BuildContext context, String uid) {
    // cancel any running timer
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 60), (_) {
      checkAndPromptDeviceIdandAction(context, uid);
    });
  }

  /// Stop checking
  void stopChecking() {
    _timer?.cancel();
    _timer = null;
  }

  /// Get or generate a persistent unique device ID
  static Future<String> getCurrentDeviceId() async {
    // 1. Check if already stored
    String? storedId = await _storage.read(key: _keyDeviceId);

    if (storedId != null) {
      return storedId; // ✅ Reuse existing ID
    }

    // 2. Generate new UUID
    String newId = const Uuid().v4();

    // 3. Save securely
    await _storage.write(key: _keyDeviceId, value: newId);

    return newId;
  }

  Future<String?> fetchDeviceIdFromFirebase(String uid) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists) {
      return userDoc['deviceId'];
    } else {
      return null;
    }
  }

  void checkAndPromptDeviceId(BuildContext context, String uid) async {
    String? firebaseDeviceId = await fetchDeviceIdFromFirebase(uid);
    String? currentDeviceId = await getCurrentDeviceId();
    print("---------firebaseDeviceId : ${firebaseDeviceId}-----------");
    print("---------currentDeviceId : ${currentDeviceId}-----------");

    if (firebaseDeviceId != null && firebaseDeviceId != currentDeviceId) {
      print("***********Device Miss Matched  *********");
      String? Token = await FirebaseMessaging.instance.getToken();
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => AlertDialog(
          title: Text("Device Mismatch"),
          content: Text(
            "You are logged in on a different device. Do you want to logout on other device or update the device ID?",
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(navigatorKey.currentContext!).pop();
                navigatorKey.currentState?.pushReplacementNamed('/login');
              },
            ),
            TextButton(
              child: Text("Logout"),
              onPressed: () async {

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .update({
                  'deviceId': currentDeviceId,
                  'token':Token
                });
                Navigator.of(navigatorKey.currentContext!).pop();
                //start Checking again
                startChecking(context,uid);
                // Optionally show success Snackbar
                ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
                  SnackBar(content: Text("Logout Succesfully Done")),
                );
              },
            ),
          ],
        ),
      );
      ;
    }else{
      print("***********Device Matched  *********");
    }
  }

  Future<void> checkAndPromptDeviceIdandAction(
      BuildContext context, String uid) async {
    String? firebaseDeviceId = await fetchDeviceIdFromFirebase(uid);
    String? currentDeviceId = await getCurrentDeviceId();

    if (firebaseDeviceId != null && firebaseDeviceId != currentDeviceId) {
      print("*********** Single Device Mismatch *********");

      await AuthService().signOut();

      // stop the timer so it won’t keep firing
      stopChecking();

      // Navigate once
      navigatorKey.currentState?.pushReplacementNamed('/login');
    } else {
      print("*********** Single Device Matched *********");
    }
  }

}

Future<void> signOutUser() async {
  try {


    // Sign out from Firebase
    await FirebaseAuth.instance.signOut();

    // Now check
    final user = FirebaseAuth.instance.currentUser;
    print("User after signout: $user"); // should be null
  } catch (e) {
    print("Signout error: $e");
  }
}