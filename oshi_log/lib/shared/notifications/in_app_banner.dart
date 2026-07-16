import 'package:flutter/material.dart';

/// Web 環境（または任意の場面）で使う画面内バナー通知。
///
/// `ScaffoldMessenger.of(context).showSnackBar` をベースに、
/// アイコンとメッセージを表示する。
void showInAppBanner(
  BuildContext context, {
  required String message,
  IconData icon = Icons.notifications,
  Duration duration = const Duration(seconds: 4),
  Color? backgroundColor,
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      duration: duration,
      backgroundColor:
          backgroundColor ?? Theme.of(context).colorScheme.inverseSurface,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Row(
        children: [
          Icon(icon,
              color: Theme.of(context).colorScheme.onInverseSurface,
              size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onInverseSurface,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

/// 目標達成バナー（お祝い色）
void showGoalAchievedBanner(BuildContext context, String planName) {
  showInAppBanner(
    context,
    message: '🏆 「$planName」の目標達成おめでとうございます！',
    icon: Icons.celebration,
    backgroundColor: Colors.amber.shade700,
    duration: const Duration(seconds: 6),
  );
}

/// 誕生日バナー
void showBirthdayBanner(BuildContext context, String oshiName) {
  showInAppBanner(
    context,
    message: '🎉 今日は $oshiName の誕生日！おめでとうございます！',
    icon: Icons.cake,
    duration: const Duration(seconds: 5),
  );
}

/// 貯金リマインダーバナー
void showSavingReminderBanner(BuildContext context) {
  showInAppBanner(
    context,
    message: '💰 今日の貯金はお済みですか？',
    icon: Icons.savings,
  );
}

/// イベント前日バナー
void showEventReminderBanner(BuildContext context, String eventName) {
  showInAppBanner(
    context,
    message: '📅 明日は「$eventName」の日です！',
    icon: Icons.event,
  );
}
