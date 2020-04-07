import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationService {
  static Future<String> getPlayerId() async {
    final status = await OneSignal.shared.getPermissionSubscriptionState();
    final playerId = status.subscriptionStatus.userId;
    return playerId;
  }

  static void sendWelcomeNotification(
      {String playerId, String username}) async {
    var notification = OSCreateNotification(
      playerIds: [playerId],
      content: "We all at Zion are glad you are using the app",
      heading: "WELCOME ${username.toUpperCase()}",
      androidSmallIcon: 'ic_stat_one_signal_default',
      additionalData: <String, dynamic>{"screen": "/notificationpage"},
    );
    await OneSignal.shared.postNotification(notification);
  }
}
