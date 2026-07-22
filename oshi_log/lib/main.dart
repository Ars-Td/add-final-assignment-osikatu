import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/event/event_repository.dart';
import 'features/oshi/oshi_repository.dart';
import 'features/settings/pages/settings_page.dart'
    show
        birthdayNotifEnabledProvider,
        eventReminderEnabledProvider,
        fontScaleProvider,
        savingReminderEnabledProvider,
        savingReminderHourProvider,
        savingReminderMinuteProvider;
import 'shared/database/app_database.dart';
import 'shared/notifications/notification_service.dart';
import 'shared/router/app_router.dart';
import 'shared/services/preferences_service.dart';

/// テーマモード（ライト / ダーク / システム）
final themeModeProvider =
    StateProvider<ThemeMode>((ref) => ThemeMode.system);

/// アプリ全体のシードカラー
const _seedColor = Color(0xFFE91E8C);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.initialize();

  // SharedPreferences から設定を読み込む
  final prefs = PreferencesService.instance;
  final reminderEnabled = await prefs.getReminderEnabled();
  final reminderHour = await prefs.getReminderHour();
  final reminderMinute = await prefs.getReminderMinute();
  final themeModeIndex = await prefs.getThemeMode();
  final themeMode = ThemeMode.values[themeModeIndex.clamp(0, 2)];
  final fontScale = await prefs.getFontScale();
  final birthdayNotifEnabled = await prefs.getBirthdayNotifEnabled();
  final eventReminderEnabled = await prefs.getEventReminderEnabled();

  // 貯金リマインダーが有効だった場合、起動時に再スケジュール
  if (reminderEnabled) {
    await NotificationService.instance
        .scheduleDailySavingReminder(reminderHour, reminderMinute);
  }

  // ネイティブのみ: 誕生日通知・イベント前日通知を起動時に再スケジュール
  if (!kIsWeb) {
    await _scheduleAllNotifications(
      birthdayEnabled: birthdayNotifEnabled,
      eventEnabled: eventReminderEnabled,
    );
  }

  runApp(
    ProviderScope(
      overrides: [
        themeModeProvider.overrideWith((ref) => themeMode),
        fontScaleProvider.overrideWith((ref) => fontScale),
        savingReminderEnabledProvider.overrideWith((ref) => reminderEnabled),
        savingReminderHourProvider.overrideWith((ref) => reminderHour),
        savingReminderMinuteProvider.overrideWith((ref) => reminderMinute),
        birthdayNotifEnabledProvider.overrideWith((ref) => birthdayNotifEnabled),
        eventReminderEnabledProvider.overrideWith((ref) => eventReminderEnabled),
      ],
      child: const OshiLogApp(),
    ),
  );
}

/// 起動時に誕生日通知・イベント前日通知を全件再スケジュールする。
///
/// DB を直接開いてデータを取得し、通知を登録する。
/// ProviderScope 外で呼ぶため、AppDatabase を独立して生成する。
Future<void> _scheduleAllNotifications(
    {required bool birthdayEnabled,
    required bool eventEnabled}) async {
  final db = AppDatabase();
  try {
    final notif = NotificationService.instance;
    final oshiRepo = OshiRepository(db);
    final eventRepo = EventRepository(db);

    // 誕生日通知（設定が有効な場合のみ）
    if (birthdayEnabled) {
      final oshisWithBirthday = await oshiRepo.getOshisWithBirthday();
      for (final oshi in oshisWithBirthday) {
        final birthday = DateTime.tryParse(oshi.birthday!);
        if (birthday != null) {
          await notif.scheduleBirthdayNotification(
              oshi.id, oshi.name, birthday);
        }
      }
    }

    // イベント前日通知（設定が有効な場合のみ・今日以降のイベントのみ）
    if (eventEnabled) {
      final today = DateTime.now();
      final todayStr =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      final upcomingEvents =
          await eventRepo.getUpcomingEvents(from: todayStr);
      for (final event in upcomingEvents) {
        final eventDate = DateTime.tryParse(event.date);
        if (eventDate != null) {
          await notif.scheduleEventReminder(
              event.id, event.name, eventDate);
        }
      }
    }
  } finally {
    await db.close();
  }
}

class OshiLogApp extends ConsumerWidget {
  const OshiLogApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final fontScale = ref.watch(fontScaleProvider);

    return MaterialApp.router(
      title: '推しログ',
      themeMode: themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      // フォントスケールを全画面に適用
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(fontScale),
          ),
          child: child!,
        );
      },
      routerConfig: router,
    );
  }
}
