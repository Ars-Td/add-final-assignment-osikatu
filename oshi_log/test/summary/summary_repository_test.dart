import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oshi_log/features/summary/summary_repository.dart';
import 'package:oshi_log/shared/database/app_database.dart';

void main() {
  late AppDatabase db;
  late SummaryRepository repo;
  late int oshiId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    repo = SummaryRepository(db);

    // テスト用の推しを登録
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

  group('SummaryRepository', () {
    test('データがないとき月次合計が0になる', () async {
      final total = await repo.getMonthlyTotal(2026, 7);
      expect(total, 0);
    });

    test('イベントの支出が月次合計に含まれる', () async {
      await db.into(db.events).insert(EventsCompanion.insert(
            oshiId: oshiId,
            name: 'テストイベント',
            date: '2026-07-15',
            category: 'コンサート',
            totalAmount: const Value(5000),
            createdAt: DateTime.now().toIso8601String(),
          ));

      final total = await repo.getMonthlyTotal(2026, 7);
      expect(total, 5000);
    });

    test('グッズの支出が月次合計に含まれる（数量考慮）', () async {
      await db.into(db.goods).insert(GoodsCompanion.insert(
            oshiId: oshiId,
            name: 'テストCD',
            purchaseDate: '2026-07-10',
            category: 'CD',
            amount: 3000,
            quantity: const Value(2),
            createdAt: DateTime.now().toIso8601String(),
          ));

      final total = await repo.getMonthlyTotal(2026, 7);
      expect(total, 6000); // 3000 × 2
    });

    test('イベントとグッズを合算して月次合計を返す', () async {
      await db.into(db.events).insert(EventsCompanion.insert(
            oshiId: oshiId,
            name: 'コンサート',
            date: '2026-07-20',
            category: 'コンサート',
            totalAmount: const Value(8000),
            createdAt: DateTime.now().toIso8601String(),
          ));
      await db.into(db.goods).insert(GoodsCompanion.insert(
            oshiId: oshiId,
            name: 'グッズ',
            purchaseDate: '2026-07-21',
            category: 'その他',
            amount: 2000,
            createdAt: DateTime.now().toIso8601String(),
          ));

      final total = await repo.getMonthlyTotal(2026, 7);
      expect(total, 10000);
    });

    test('別月のデータは月次合計に含まれない', () async {
      await db.into(db.events).insert(EventsCompanion.insert(
            oshiId: oshiId,
            name: '6月イベント',
            date: '2026-06-15',
            category: 'コンサート',
            totalAmount: const Value(5000),
            createdAt: DateTime.now().toIso8601String(),
          ));

      final total = await repo.getMonthlyTotal(2026, 7);
      expect(total, 0);
    });

    test('推しごとの月次内訳を取得できる', () async {
      await db.into(db.events).insert(EventsCompanion.insert(
            oshiId: oshiId,
            name: 'コンサート',
            date: '2026-07-15',
            category: 'コンサート',
            totalAmount: const Value(5000),
            createdAt: DateTime.now().toIso8601String(),
          ));

      final list = await repo.getMonthlyByOshi(2026, 7);
      expect(list.length, 1);
      expect(list.first.oshiName, 'テスト推し');
      expect(list.first.amount, 5000);
    });

    test('年間月別データを12要素で返す', () async {
      final monthly = await repo.getYearlyMonthly(2026);
      expect(monthly.length, 12);
    });

    test('カテゴリ別内訳でイベント費とグッズ費を分けて返す', () async {
      await db.into(db.events).insert(EventsCompanion.insert(
            oshiId: oshiId,
            name: 'コンサート',
            date: '2026-07-15',
            category: 'コンサート',
            totalAmount: const Value(5000),
            createdAt: DateTime.now().toIso8601String(),
          ));
      await db.into(db.goods).insert(GoodsCompanion.insert(
            oshiId: oshiId,
            name: 'グッズ',
            purchaseDate: '2026-07-10',
            category: 'CD',
            amount: 2000,
            createdAt: DateTime.now().toIso8601String(),
          ));

      final cats = await repo.getMonthlyCategoryBreakdown(2026, 7);
      expect(cats.length, 2);
      final event = cats.firstWhere((c) => c.label == 'イベント費');
      final goods = cats.firstWhere((c) => c.label == 'グッズ費');
      expect(event.amount, 5000);
      expect(goods.amount, 2000);
    });

    test('推しへの累計支出を取得できる', () async {
      await db.into(db.events).insert(EventsCompanion.insert(
            oshiId: oshiId,
            name: 'イベント1',
            date: '2026-01-01',
            category: 'コンサート',
            totalAmount: const Value(3000),
            createdAt: DateTime.now().toIso8601String(),
          ));
      await db.into(db.goods).insert(GoodsCompanion.insert(
            oshiId: oshiId,
            name: 'グッズ1',
            purchaseDate: '2026-03-01',
            category: 'CD',
            amount: 2000,
            createdAt: DateTime.now().toIso8601String(),
          ));

      final total = await repo.getOshiTotal(oshiId);
      expect(total, 5000);
    });
  });
}
