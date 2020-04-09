import 'package:zion/service/notification_service.dart';
import 'package:zion/service/user_profile_service.dart';

class DependecyInjection {
  NotificationService service;
  UserProfileService userProfileService;

  DependecyInjection() {
    service = NotificationService();
    userProfileService = UserProfileService();
  }
}
