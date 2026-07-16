import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notification_service.dart';

/// NotificationService のシングルトン Provider
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService.instance;
});
