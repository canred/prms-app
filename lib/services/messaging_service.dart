import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  late final FirebaseMessaging _firebaseMessaging;

  PushNotificationService() {
    _firebaseMessaging = FirebaseMessaging.instance;
  }

  Future<void> init() async {
    // 請求權限（iOS）
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      // 取得 APNS Token（僅限 iOS）
      String? apnsToken = await _firebaseMessaging.getAPNSToken();
      print("APNS Token: $apnsToken");

      // 取得 FCM Token
      String? token = await _firebaseMessaging.getToken();
      print("FCM Token: $token");

      // 收到消息時處理
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print(
          'Received a message in foreground: \\${message.notification?.title}',
        );
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('App opened from notification: \\${message.notification?.title}');
      });
    }
  }
}
