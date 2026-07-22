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
  static const _kFontScale = 'font_scale'; // double: 0.85 / 1.0 / 1.15 / 1.3
  static const _kBirthdayNotifEnabled = 'birthday_notif_enabled';
  static const _kEventReminderEnabled = 'event_reminder_enabled';

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

  // ---------------------------------------------------------------------------
  // フォントスケール
  // ---------------------------------------------------------------------------

  /// フォントスケールを取得（デフォルト: 1.0）
  Future<double> getFontScale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_kFontScale) ?? 1.0;
  }

  /// フォントスケールを保存
  Future<void> setFontScale(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kFontScale, value);
  }

  // ---------------------------------------------------------------------------
  // 誕生日通知設定
  // ---------------------------------------------------------------------------

  Future<bool> getBirthdayNotifEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kBirthdayNotifEnabled) ?? true;
  }

  Future<void> setBirthdayNotifEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kBirthdayNotifEnabled, value);
  }

  // ---------------------------------------------------------------------------
  // イベント前日通知設定
  // ---------------------------------------------------------------------------

  Future<bool> getEventReminderEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kEventReminderEnabled) ?? true;
  }

  Future<void> setEventReminderEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kEventReminderEnabled, value);
  }
}
