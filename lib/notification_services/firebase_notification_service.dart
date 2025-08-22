import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> backgroundHandler(RemoteMessage message)async{
  print("message Received ${message.notification!.title}");
}

class FirebaseNotificationService{

  static Future<void> initialize()async{

    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();
    if(settings.authorizationStatus == AuthorizationStatus.authorized){

      String? Token = await FirebaseMessaging.instance.getToken();

      if(Token!=null){
        print("token : ${Token}");
      }

      FirebaseMessaging.onBackgroundMessage(backgroundHandler);

      print("Notification initailized");
    }
  }


}