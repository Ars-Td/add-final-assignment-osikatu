import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

// 条件付きインポート:
//   Web → download_web.dart (downloadFile でブラウザダウンロード)
//   ネイティブ → share_native.dart (share_plus で OS Share シート)
import 'share_native.dart'
    if (dart.library.js_interop) 'download_web.dart';

import '../../shared/database/app_database.dart';

/// データエクスポートサービス
class ExportService {
  final AppDatabase _db;
  ExportService(this._db);

  // ---------------------------------------------------------------------------
  // CSV 生成
  // ---------------------------------------------------------------------------

  /// イベント履歴 CSV
  Future<String> exportEventsCsv() async {
    final oshis = await _db.select(_db.oshis).get();
    final oshiMap = {for (final o in oshis) o.id: o.name};

    final events = await (_db.select(_db.events)
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();

    final rows = <List<dynamic>>[
      ['推し名', 'イベント名', '日付', '会場', 'カテゴリ', '支出合計（円）', 'メモ'],
    ];
    for (final e in events) {
      rows.add([
        oshiMap[e.oshiId] ?? '',
        e.name,
        e.date,
        e.venue ?? '',
        e.category,
        e.totalAmount,
        e.memo ?? '',
      ]);
    }
    return const ListToCsvConverter().convert(rows);
  }

  /// グッズ履歴 CSV
  Future<String> exportGoodsCsv() async {
    final oshis = await _db.select(_db.oshis).get();
    final oshiMap = {for (final o in oshis) o.id: o.name};

    final goods = await (_db.select(_db.goods)
          ..orderBy([(t) => OrderingTerm.asc(t.purchaseDate)]))
        .get();

    final rows = <List<dynamic>>[
      ['推し名', 'グッズ名', '購入日', 'カテゴリ', '金額（円）', '数量', '合計（円）', '購入場所', 'メモ'],
    ];
    for (final g in goods) {
      rows.add([
        oshiMap[g.oshiId] ?? '',
        g.name,
        g.purchaseDate,
        g.category,
        g.amount,
        g.quantity,
        g.amount * g.quantity,
        g.shop ?? '',
        g.memo ?? '',
      ]);
    }
    return const ListToCsvConverter().convert(rows);
  }

  /// 貯金記録 CSV
  Future<String> exportSavingsCsv() async {
    final oshis = await _db.select(_db.oshis).get();
    final oshiMap = {for (final o in oshis) o.id: o.name};

    final plans = await _db.select(_db.savingPlans).get();
    final planMap = {for (final p in plans) p.id: p};

    final records = await (_db.select(_db.savingRecords)
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();

    final rows = <List<dynamic>>[
      ['推し名', 'プラン名', '日付', '金額（円）'],
    ];
    for (final r in records) {
      final plan = planMap[r.planId];
      rows.add([
        plan != null ? (oshiMap[plan.oshiId] ?? '') : '',
        plan?.name ?? '',
        r.date,
        r.amount,
      ]);
    }
    return const ListToCsvConverter().convert(rows);
  }

  // ---------------------------------------------------------------------------
  // JSON 生成（全データバックアップ）
  // ---------------------------------------------------------------------------

  Future<String> exportAllJson() async {
    final oshis = await _db.select(_db.oshis).get();
    final events = await _db.select(_db.events).get();
    final eventExpenses = await _db.select(_db.eventExpenses).get();
    final goods = await _db.select(_db.goods).get();
    final savingPlans = await _db.select(_db.savingPlans).get();
    final savingRecords = await _db.select(_db.savingRecords).get();

    final data = {
      'exportedAt': DateTime.now().toIso8601String(),
      'version': '1.0.0',
      'oshis': oshis
          .map((o) => {
                'id': o.id,
                'name': o.name,
                'iconPath': o.iconPath,
                'category': o.category,
                'coverColor': o.coverColor,
                'birthday': o.birthday,
                'memo': o.memo,
                'isGroup': o.isGroup,
                'members': o.members,
                'createdAt': o.createdAt,
                'lastViewedAt': o.lastViewedAt,
              })
          .toList(),
      'events': events
          .map((e) => {
                'id': e.id,
                'oshiId': e.oshiId,
                'name': e.name,
                'date': e.date,
                'venue': e.venue,
                'category': e.category,
                'totalAmount': e.totalAmount,
                'memo': e.memo,
                'photoPaths': e.photoPaths,
                'createdAt': e.createdAt,
              })
          .toList(),
      'eventExpenses': eventExpenses
          .map((e) => {
                'id': e.id,
                'eventId': e.eventId,
                'label': e.label,
                'amount': e.amount,
              })
          .toList(),
      'goods': goods
          .map((g) => {
                'id': g.id,
                'oshiId': g.oshiId,
                'name': g.name,
                'purchaseDate': g.purchaseDate,
                'category': g.category,
                'amount': g.amount,
                'quantity': g.quantity,
                'shop': g.shop,
                'imagePath': g.imagePath,
                'photoPaths': g.photoPaths,
                'memo': g.memo,
                'createdAt': g.createdAt,
              })
          .toList(),
      'savingPlans': savingPlans
          .map((p) => {
                'id': p.id,
                'oshiId': p.oshiId,
                'name': p.name,
                'startDate': p.startDate,
                'goalDate': p.goalDate,
                'goalAmount': p.goalAmount,
                'dailyAmount': p.dailyAmount,
                'createdAt': p.createdAt,
              })
          .toList(),
      'savingRecords': savingRecords
          .map((r) => {
                'id': r.id,
                'planId': r.planId,
                'date': r.date,
                'amount': r.amount,
                'createdAt': r.createdAt,
              })
          .toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  // ---------------------------------------------------------------------------
  // ダウンロード / 共有
  // ---------------------------------------------------------------------------

  /// ファイルをダウンロード（Web）または OS Share シートで共有（ネイティブ）
  ///
  /// - Web: `download_web.dart` の `downloadFile` でブラウザダウンロード
  /// - iOS / Android: `share_native.dart` の `shareFile` で OS Share シートを表示
  static Future<void> downloadOrCopy(
    BuildContext context, {
    required String content,
    required String filename,
    required String mimeType,
  }) async {
    final bytes = utf8.encode(content);
    if (kIsWeb) {
      // Web: ブラウザのダウンロードダイアログ
      downloadFile(bytes, filename, mimeType);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$filename をダウンロードしました')),
        );
      }
    } else {
      // ネイティブ: OS Share シート
      await shareFile(bytes, filename, mimeType);
    }
  }
}
