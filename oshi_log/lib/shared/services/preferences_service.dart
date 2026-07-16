import 'package:shared_preferences/shared_preferences.dart';

/// アプリ設定の永続化サービス。
/// SharedPreferences をラップして型安全なアクセスを提供する。
class PreferencesService {
  PreferencesService._();
  static final PreferencesService instance = PreferencesService._();

  static const _kReminderEnabled = 'saving_reminder_enabled';
  static const _kReminderHour = 'saving_reminder_hour';
  static const _kReminderMinute = 'saving_reminder_minute';
  static const _kThemeMode = 'theme_mode'; // 0=system, 1=light, 2=dark

  // ---------------------------------------------------------------------------
  // 貯金リマインダー設定
  // ---------------------------------------------------------------------------

  Future<bool> getReminderEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kReminderEnabled) ?? false;
  }

  Future<void> setReminderEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kReminderEnabled, value);
  }

  Future<int> getReminderHour() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kReminderHour) ?? 20;
  }

  Future<void> setReminderHour(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kReminderHour, value);
  }

  Future<int> getReminderMinute() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kReminderMinute) ?? 0;
  }

  Future<void> setReminderMinute(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kReminderMinute, value);
  }

  // ---------------------------------------------------------------------------
  // テーマモード
  // ---------------------------------------------------------------------------

  Future<int> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kThemeMode) ?? 0; // 0=system
  }

  Future<void> setThemeMode(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kThemeMode, value);
  }
}
