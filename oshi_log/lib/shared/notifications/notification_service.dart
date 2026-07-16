import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// 通知サービス（シングルトン）
///
/// - ネイティブ（iOS / Android）: flutter_local_notifications でシステム通知
/// - Web: kIsWeb == true のため初期化はスキップ（画面内バナーで代替）
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// アプリ起動時に一度だけ呼ぶ
  Future<void> initialize() async {
    if (kIsWeb) return;
    if (_initialized) return;

    // タイムゾーンデータを初期化
    tz_data.initializeTimeZones();
    final tzName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(tzName));

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);
    _initialized = true;
  }

  /// 通知許可を要求（Android 13+）
  Future<bool> requestPermission() async {
    if (kIsWeb) return false;
    final android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }
    return true;
  }

  // ---------------------------------------------------------------------------
  // 通知チャンネル設定
  // ---------------------------------------------------------------------------

  static const _androidDetails = AndroidNotificationDetails(
    'oshi_log_channel',
    '推しログ通知',
    channelDescription: '推しログからのお知らせ',
    importance: Importance.high,
    priority: Priority.high,
  );
  static const _details = NotificationDetails(android: _androidDetails);

  // ---------------------------------------------------------------------------
  // 即時通知
  // ---------------------------------------------------------------------------

  /// 推しの誕生日通知
  Future<void> showBirthdayNotification(String oshiName) async {
    if (kIsWeb) return;
    await _plugin.show(
      1,
      '🎉 今日は $oshiName の誕生日！',
      'おめでとうございます！推しへの想いを記録しましょう',
      _details,
    );
  }

  /// 貯金目標達成通知
  Future<void> showGoalAchieved(String planName) async {
    if (kIsWeb) return;
    await _plugin.show(
      2,
      '🏆 目標達成！',
      '「$planName」の目標金額に到達しました！',
      _details,
    );
  }

  /// イベント前日通知
  Future<void> showEventReminder(String eventName) async {
    if (kIsWeb) return;
    await _plugin.show(
      3,
      '📅 明日はイベントの日！',
      '「$eventName」は明日です。準備はできていますか？',
      _details,
    );
  }

  /// 貯金リマインダー（即時）
  Future<void> showSavingReminder() async {
    if (kIsWeb) return;
    await _plugin.show(
      4,
      '💰 今日の貯金はお済みですか？',
      '推しのために、今日も少し積み立てましょう！',
      _details,
    );
  }

  // ---------------------------------------------------------------------------
  // スケジュール通知
  // ---------------------------------------------------------------------------

  /// 毎日指定時刻に貯金リマインダーをスケジュール（ネイティブのみ）
  ///
  /// [hour] / [minute] はローカルタイムで指定。
  Future<void> scheduleDailySavingReminder(int hour, int minute) async {
    if (kIsWeb) return;
    if (!_initialized) await initialize();

    // 既存のリマインダーをキャンセルしてから再スケジュール
    await _plugin.cancel(10);

    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    // 今日の指定時刻が既に過ぎていれば翌日にする
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      10,
      '💰 今日の貯金はお済みですか？',
      '推しのために、今日も少し積み立てましょう！',
      scheduled,
      _details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // 毎日繰り返し
    );
  }

  /// 貯金リマインダーのスケジュールをキャンセル
  Future<void> cancelSavingReminder() async {
    if (kIsWeb) return;
    await _plugin.cancel(10);
  }

  /// 全通知をキャンセル
  Future<void> cancelAll() async {
    if (kIsWeb) return;
    await _plugin.cancelAll();
  }
}
