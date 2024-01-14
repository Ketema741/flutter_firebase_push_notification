import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notifications/main.dart';

Future<void> handleMessage(RemoteMessage? message) async {
  if (message == null) {
    return;
  }

  navigatorKey.currentState?.pushNamed(
    "/notifications",
    arguments: message,
  );
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  // function to initialize the notification
  Future<void> initNotifications() async {
    // request permission from user (will prompt user)
    await _firebaseMessaging.requestPermission();

    // fetch the FCM token for this device
    final fCMToken = await _firebaseMessaging.getToken();

    // print the toen (normally you would send this to your server)
    // ignore: avoid_print
    print("Token: $fCMToken");
    FirebaseMessaging.onBackgroundMessage(handleMessage);

    // initialze further settings for push notification
    initPushNotifications();
  }

  Future initPushNotifications() async {
    // handle notification if the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    // attach event listers for when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
