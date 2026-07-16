import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/settings/pages/settings_page.dart'
    show
        savingReminderEnabledProvider,
        savingReminderHourProvider,
        savingReminderMinuteProvider;
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

  // 貯金リマインダーが有効だった場合、起動時に再スケジュール
  if (reminderEnabled) {
    await NotificationService.instance
        .scheduleDailySavingReminder(reminderHour, reminderMinute);
  }

  runApp(
    ProviderScope(
      overrides: [
        themeModeProvider.overrideWith((ref) => themeMode),
        savingReminderEnabledProvider.overrideWith((ref) => reminderEnabled),
        savingReminderHourProvider.overrideWith((ref) => reminderHour),
        savingReminderMinuteProvider.overrideWith((ref) => reminderMinute),
      ],
      child: const OshiLogApp(),
    ),
  );
}

class OshiLogApp extends ConsumerWidget {
  const OshiLogApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

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
      routerConfig: router,
    );
  }
}
