import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oshi_log/features/goods/goods_repository.dart';
import 'package:oshi_log/features/oshi/oshi_repository.dart';
import 'package:oshi_log/shared/database/app_database.dart';

void main() {
  late AppDatabase db;
  late OshiRepository oshiRepo;
  late GoodsRepository goodsRepo;
  late int oshiId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    oshiRepo = OshiRepository(db);
    goodsRepo = GoodsRepository(db);
    oshiId = await oshiRepo.insertOshi(OshisCompanion.insert(
      name: 'テスト推し',
      coverColor: 0xFFE91E8C,
      category: 'アイドル',
      createdAt: '2026-07-16T00:00:00.000Z',
    ));
  });

  tearDown(() async {
    await db.close();
  });

  group('GoodsRepository', () {
    test('グッズを登録して一覧取得できる', () async {
      await goodsRepo.insertGoods(GoodsCompanion.insert(
        oshiId: oshiId,
        name: 'テストCD',
        purchaseDate: '2026-07-16',
        category: 'CD',
        amount: 3000,
        createdAt: '2026-07-16T00:00:00.000Z',
      ));

      final list = await goodsRepo.getGoodsByOshi(oshiId);
      expect(list.length, 1);
      expect(list.first.name, 'テストCD');
    });

    test('カテゴリフィルタで取得できる', () async {
      await goodsRepo.insertGoods(GoodsCompanion.insert(
        oshiId: oshiId,
        name: 'CD作品',
        purchaseDate: '2026-07-16',
        category: 'CD',
        amount: 3000,
        createdAt: '2026-07-16T00:00:00.000Z',
      ));
      await goodsRepo.insertGoods(GoodsCompanion.insert(
        oshiId: oshiId,
        name: 'Tシャツ',
        purchaseDate: '2026-07-16',
        category: 'アパレル',
        amount: 5000,
        createdAt: '2026-07-16T00:00:00.000Z',
      ));

      final list = await goodsRepo.getGoodsByCategory(oshiId, 'CD');
      expect(list.length, 1);
      expect(list.first.name, 'CD作品');
    });

    test('月 + カテゴリ 複合フィルタで両条件を満たすグッズのみ取得できる', () async {
      // 7月 CD
      await goodsRepo.insertGoods(GoodsCompanion.insert(
        oshiId: oshiId,
        name: '7月CD',
        purchaseDate: '2026-07-10',
        category: 'CD',
        amount: 3000,
        createdAt: '2026-07-10T00:00:00.000Z',
      ));
      // 8月 CD（月が異なる → 除外）
      await goodsRepo.insertGoods(GoodsCompanion.insert(
        oshiId: oshiId,
        name: '8月CD',
        purchaseDate: '2026-08-01',
        category: 'CD',
        amount: 3000,
        createdAt: '2026-08-01T00:00:00.000Z',
      ));
      // 7月 アパレル（カテゴリが異なる → 除外）
      await goodsRepo.insertGoods(GoodsCompanion.insert(
        oshiId: oshiId,
        name: '7月アパレル',
        purchaseDate: '2026-07-20',
        category: 'アパレル',
        amount: 5000,
        createdAt: '2026-07-20T00:00:00.000Z',
      ));

      final list = await goodsRepo.getGoodsByMonthAndCategory(
          oshiId, 2026, 7, 'CD');
      expect(list.length, 1);
      expect(list.first.name, '7月CD');
    });

    test('グッズの合計支出を取得できる', () async {
      await goodsRepo.insertGoods(GoodsCompanion.insert(
        oshiId: oshiId,
        name: 'グッズA',
        purchaseDate: '2026-07-16',
        category: 'CD',
        amount: 3000,
        createdAt: '2026-07-16T00:00:00.000Z',
      ));
      await goodsRepo.insertGoods(GoodsCompanion.insert(
        oshiId: oshiId,
        name: 'グッズB',
        purchaseDate: '2026-07-16',
        category: 'アパレル',
        amount: 5000,
        createdAt: '2026-07-16T00:00:00.000Z',
      ));

      final total = await goodsRepo.getTotalAmountByOshi(oshiId);
      expect(total, 8000);
    });
  });
}
