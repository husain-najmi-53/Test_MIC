import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';

class FlutterLocalNotificationService {
  final notificationPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialised = false;
  // bool get isIntialiised => _isInitialised;

  Future<void> initNotification() async {
    if (_isInitialised) return;

    const initsSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettingIos = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestSoundPermission: true,
        requestBadgePermission: true);

    const initSettings = InitializationSettings(android: initsSettingsAndroid, iOS: initSettingIos);

    await notificationPlugin.initialize(initSettings);
    _isInitialised = true;
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
            "daily_channel", "Daily_Notification",
            channelDescription: "Daily_notifactions_Channel",
            importance: Importance.max,
            priority: Priority.high),
        iOS: DarwinNotificationDetails());
  }

  Future<void> showNotification(
      {int id = 1, String? title, String? body,String? payload}) async {
    return notificationPlugin.show(id, title, body, notificationDetails());
  }

Future<void> scheduleNotification({
    required int id,
    String? title,
    String? body,
    Duration? duration,
  }) async {
    // Default: trigger after 5 seconds if no duration provided
    final scheduledDate = DateTime.now().add(duration ?? const Duration(seconds: 5));

    await notificationPlugin.zonedSchedule(
      id,
      title,
      body,
      TZDateTime.from(scheduledDate, local),
      notificationDetails(),
      payload: "Notification-payload",
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: null,
    );
  }

  void checkNotificationDetails()async{
    NotificationAppLaunchDetails ? details =await notificationPlugin.getNotificationAppLaunchDetails();
    if(details!=null){

      if(details.didNotificationLaunchApp){
        NotificationResponse? response = details.notificationResponse;

        if(response!=null){
          String? payload = response.payload;
          print(payload);
          //and here through payload message we can go to different pages and can do certain event using condition on payload message
        }
      }
    }
  }

}