import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oshi_log/features/settings/export_service.dart';
import 'package:oshi_log/shared/database/app_database.dart';

void main() {
  late AppDatabase db;
  late ExportService service;
  late int oshiId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    service = ExportService(db);

    oshiId = await db.into(db.oshis).insert(OshisCompanion.insert(
          name: 'テスト推し',
          coverColor: 0xFFE91E8C,
          category: 'アイドル',
          createdAt: DateTime.now().toIso8601String(),
        ));
  });

  tearDown(() async {
    await db.close();
  });

  group('ExportService', () {
    test('イベントCSVにヘッダー行が含まれる', () async {
      final csv = await service.exportEventsCsv();
      expect(csv, contains('推し名'));
      expect(csv, contains('イベント名'));
      expect(csv, contains('支出合計'));
    });

    test('イベントデータがCSVに含まれる', () async {
      await db.into(db.events).insert(EventsCompanion.insert(
            oshiId: oshiId,
            name: 'テストコンサート',
            date: '2026-07-15',
            category: 'コンサート',
            totalAmount: const Value(5000),
            createdAt: DateTime.now().toIso8601String(),
          ));

      final csv = await service.exportEventsCsv();
      expect(csv, contains('テスト推し'));
      expect(csv, contains('テストコンサート'));
      expect(csv, contains('5000'));
    });

    test('グッズCSVにヘッダー行が含まれる', () async {
      final csv = await service.exportGoodsCsv();
      expect(csv, contains('グッズ名'));
      expect(csv, contains('金額'));
      expect(csv, contains('数量'));
    });

    test('グッズデータがCSVに含まれる', () async {
      await db.into(db.goods).insert(GoodsCompanion.insert(
            oshiId: oshiId,
            name: 'テストCD',
            purchaseDate: '2026-07-10',
            category: 'CD',
            amount: 3000,
            quantity: const Value(2),
            createdAt: DateTime.now().toIso8601String(),
          ));

      final csv = await service.exportGoodsCsv();
      expect(csv, contains('テストCD'));
      expect(csv, contains('3000'));
    });

    test('貯金CSVにヘッダー行が含まれる', () async {
      final csv = await service.exportSavingsCsv();
      expect(csv, contains('プラン名'));
      expect(csv, contains('日付'));
    });

    test('全データJSONに必要なキーが含まれる', () async {
      final json = await service.exportAllJson();
      expect(json, contains('"oshis"'));
      expect(json, contains('"events"'));
      expect(json, contains('"goods"'));
      expect(json, contains('"savingPlans"'));
      expect(json, contains('"savingRecords"'));
      expect(json, contains('"exportedAt"'));
      expect(json, contains('"version"'));
    });

    test('全データJSONに推しデータが含まれる', () async {
      final json = await service.exportAllJson();
      expect(json, contains('テスト推し'));
    });
  });
}
