import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../database/app_database.dart';
import 'in_app_banner.dart';

/// Web 環境での起動時バナー通知サービス。
///
/// ネイティブでは `NotificationService` がシステム通知を担うが、
/// Web ではスケジュール通知が使えないため、アプリ起動直後に
/// 以下を DB から確認してバナーを表示する。
///
/// - 今日が誕生日の推しがいる場合 → 誕生日バナー
/// - 明日がイベント日のイベントがある場合 → 前日リマインドバナー
/// - 今日まだチェックインしていない貯金プランがある場合 → 貯金リマインダーバナー
///
/// 1 セッションにつき 1 回のみ表示する（`_shown` フラグで管理）。
class WebBannerService {
  WebBannerService._();
  static final WebBannerService instance = WebBannerService._();

  bool _shown = false;

  /// アプリ起動後に一度だけ呼び出す。
  ///
  /// [context] は `ScaffoldMessenger` が利用できる画面の context。
  /// [db] は既に開いている `AppDatabase` インスタンス。
  Future<void> showStartupBanners(
      BuildContext context, AppDatabase db) async {
    // Web 以外は何もしない（ネイティブは NotificationService が担当）
    if (!kIsWeb) return;
    // 1 セッション 1 回のみ
    if (_shown) return;
    _shown = true;

    final today = DateTime.now();
    final todayStr = _dateStr(today);
    final todayMD = _monthDay(today);
    final tomorrowStr = _dateStr(today.add(const Duration(days: 1)));

    // --- 誕生日チェック ---
    final oshis = await (db.select(db.oshis)
          ..where((t) => t.birthday.isNotNull()))
        .get();

    for (final oshi in oshis) {
      if (!context.mounted) return;
      final bdMD = _parseBirthdayMonthDay(oshi.birthday!);
      if (bdMD == null) continue;
      if (bdMD == todayMD) {
        // 少し間を置いてから表示（画面描画完了後）
        await Future.delayed(const Duration(milliseconds: 600));
        if (context.mounted) {
          showBirthdayBanner(context, oshi.name);
        }
        // 複数の誕生日があれば少し間を空けて順番に表示
        await Future.delayed(const Duration(seconds: 3));
      }
    }

    // --- イベント前日チェック ---
    final tomorrowEvents = await (db.select(db.events)
          ..where((t) => t.date.equals(tomorrowStr)))
        .get();

    for (final event in tomorrowEvents) {
      if (!context.mounted) return;
      await Future.delayed(const Duration(milliseconds: 400));
      if (context.mounted) {
        showEventReminderBanner(context, event.name);
      }
      await Future.delayed(const Duration(seconds: 3));
    }

    // --- 貯金リマインダーチェック ---
    // 今日まだチェックインしていない貯金プランが 1 件以上あれば表示
    if (!context.mounted) return;
    final allPlans = await db.select(db.savingPlans).get();
    bool hasUncheckedPlan = false;
    for (final plan in allPlans) {
      final records = await (db.select(db.savingRecords)
            ..where((t) => t.planId.equals(plan.id))
            ..where((t) => t.date.equals(todayStr)))
          .get();
      if (records.isEmpty) {
        hasUncheckedPlan = true;
        break;
      }
    }
    if (hasUncheckedPlan && context.mounted) {
      await Future.delayed(const Duration(milliseconds: 400));
      if (context.mounted) {
        showSavingReminderBanner(context);
      }
    }
  }

  /// "MM-DD" 形式の文字列を返す（年を除いた月日比較用）
  String _monthDay(DateTime dt) =>
      '${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  /// "YYYY-MM-DD" 形式の文字列を返す
  String _dateStr(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  /// DB の birthday 文字列から "MM-DD" 形式を取り出す。
  /// "--MM-DD" 形式と "YYYY-MM-DD" / ISO 8601 形式の両方に対応。
  String? _parseBirthdayMonthDay(String s) {
    // "--MM-DD" 形式
    final noYear = RegExp(r'^--(\d{2})-(\d{2})$');
    final m = noYear.firstMatch(s);
    if (m != null) return '${m.group(1)}-${m.group(2)}';
    // "YYYY-MM-DD" / ISO 8601 形式（後方互換）
    final dt = DateTime.tryParse(s);
    if (dt != null) return _monthDay(dt);
    return null;
  }
}
