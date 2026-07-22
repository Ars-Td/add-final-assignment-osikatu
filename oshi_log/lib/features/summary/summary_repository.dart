import 'package:drift/drift.dart';

import '../../shared/database/app_database.dart';

/// 推しごとの支出合計
class OshiAmount {
  final int oshiId;
  final String oshiName;
  final int coverColor;
  final int amount;
  OshiAmount({
    required this.oshiId,
    required this.oshiName,
    required this.coverColor,
    required this.amount,
  });
}

/// カテゴリ別支出（月次サマリー用）
class CategoryAmount {
  final String label;   // 'イベント費' / 'グッズ費'
  final int amount;
  const CategoryAmount({required this.label, required this.amount});
}

class SummaryRepository {
  final AppDatabase _db;
  SummaryRepository(this._db);

  /// 指定月の全支出合計（イベント + グッズ）
  Future<int> getMonthlyTotal(int year, int month) async {
    final prefix = '$year-${month.toString().padLeft(2, '0')}';

    // イベント
    final events = await (_db.select(_db.events)
          ..where((t) => t.date.like('$prefix%')))
        .get();
    final eventTotal =
        events.fold<int>(0, (sum, e) => sum + e.totalAmount);

    // グッズ
    final goods = await (_db.select(_db.goods)
          ..where((t) => t.purchaseDate.like('$prefix%')))
        .get();
    final goodsTotal =
        goods.fold<int>(0, (sum, g) => sum + g.amount * g.quantity);

    return eventTotal + goodsTotal;
  }

  /// 指定月の推しごと支出一覧
  Future<List<OshiAmount>> getMonthlyByOshi(int year, int month) async {
    final prefix = '$year-${month.toString().padLeft(2, '0')}';
    final oshis = await (_db.select(_db.oshis)
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();

    final result = <OshiAmount>[];
    for (final oshi in oshis) {
      final events = await (_db.select(_db.events)
            ..where((t) =>
                t.oshiId.equals(oshi.id) & t.date.like('$prefix%')))
          .get();
      final goods = await (_db.select(_db.goods)
            ..where((t) =>
                t.oshiId.equals(oshi.id) &
                t.purchaseDate.like('$prefix%')))
          .get();

      final amount =
          events.fold<int>(0, (s, e) => s + e.totalAmount) +
              goods.fold<int>(0, (s, g) => s + g.amount * g.quantity);

      if (amount > 0) {
        result.add(OshiAmount(
          oshiId: oshi.id,
          oshiName: oshi.name,
          coverColor: oshi.coverColor,
          amount: amount,
        ));
      }
    }
    return result;
  }

  /// 年間の月別合計支出（インデックス0=1月〜11=12月）
  Future<List<int>> getYearlyMonthly(int year) async {
    final result = List<int>.filled(12, 0);
    for (int m = 1; m <= 12; m++) {
      result[m - 1] = await getMonthlyTotal(year, m);
    }
    return result;
  }

  /// 推しへの累計支出
  Future<int> getOshiTotal(int oshiId) async {
    final events = await (_db.select(_db.events)
          ..where((t) => t.oshiId.equals(oshiId)))
        .get();
    final goods = await (_db.select(_db.goods)
          ..where((t) => t.oshiId.equals(oshiId)))
        .get();
    return events.fold<int>(0, (s, e) => s + e.totalAmount) +
        goods.fold<int>(0, (s, g) => s + g.amount * g.quantity);
  }

  /// 推しの年間月別支出（インデックス0=1月〜11=12月）
  Future<List<int>> getOshiMonthly(int oshiId, int year) async {
    final result = List<int>.filled(12, 0);
    for (int m = 1; m <= 12; m++) {
      final prefix = '$year-${m.toString().padLeft(2, '0')}';
      final events = await (_db.select(_db.events)
            ..where((t) =>
                t.oshiId.equals(oshiId) & t.date.like('$prefix%')))
          .get();
      final goods = await (_db.select(_db.goods)
            ..where((t) =>
                t.oshiId.equals(oshiId) &
                t.purchaseDate.like('$prefix%')))
          .get();
      result[m - 1] =
          events.fold<int>(0, (s, e) => s + e.totalAmount) +
              goods.fold<int>(0, (s, g) => s + g.amount * g.quantity);
    }
    return result;
  }

  /// 推しのイベント参加回数
  Future<int> getOshiEventCount(int oshiId) async {
    final rows = await (_db.select(_db.events)
          ..where((t) => t.oshiId.equals(oshiId)))
        .get();
    return rows.length;
  }

  /// 推しのグッズ購入点数（数量合計）
  Future<int> getOshiGoodsCount(int oshiId) async {
    final rows = await (_db.select(_db.goods)
          ..where((t) => t.oshiId.equals(oshiId)))
        .get();
    return rows.fold<int>(0, (sum, g) => sum + g.quantity);
  }

  /// 指定月のカテゴリ別支出（イベント費・グッズ費）
  Future<List<CategoryAmount>> getMonthlyCategoryBreakdown(
      int year, int month) async {
    final prefix = '$year-${month.toString().padLeft(2, '0')}';

    final events = await (_db.select(_db.events)
          ..where((t) => t.date.like('$prefix%')))
        .get();
    final eventTotal =
        events.fold<int>(0, (sum, e) => sum + e.totalAmount);

    final goods = await (_db.select(_db.goods)
          ..where((t) => t.purchaseDate.like('$prefix%')))
        .get();
    final goodsTotal =
        goods.fold<int>(0, (sum, g) => sum + g.amount * g.quantity);

    return [
      CategoryAmount(label: 'イベント費', amount: eventTotal),
      CategoryAmount(label: 'グッズ費', amount: goodsTotal),
    ];
  }

  /// 全推し一覧（サマリー推しタブ用）
  Future<List<Oshi>> getAllOshis() =>
      (_db.select(_db.oshis)
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();
}
