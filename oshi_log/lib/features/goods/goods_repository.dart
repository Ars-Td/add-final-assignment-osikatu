import 'package:drift/drift.dart';
import 'package:oshi_log/shared/database/app_database.dart';

class GoodsRepository {
  final AppDatabase _db;
  GoodsRepository(this._db);

  /// グッズを登録し ID を返す
  Future<int> insertGoods(GoodsCompanion companion) =>
      _db.into(_db.goods).insert(companion);

  /// 推しに紐づくグッズ一覧（新しい順）
  Future<List<Good>> getGoodsByOshi(int oshiId) =>
      (_db.select(_db.goods)
            ..where((t) => t.oshiId.equals(oshiId))
            ..orderBy([(t) => OrderingTerm.desc(t.purchaseDate)]))
          .get();

  /// カテゴリフィルタ
  Future<List<Good>> getGoodsByCategory(int oshiId, String category) =>
      (_db.select(_db.goods)
            ..where(
                (t) => t.oshiId.equals(oshiId) & t.category.equals(category))
            ..orderBy([(t) => OrderingTerm.desc(t.purchaseDate)]))
          .get();

  /// 月フィルタ
  Future<List<Good>> getGoodsByMonth(int oshiId, int year, int month) {
    final prefix = '$year-${month.toString().padLeft(2, '0')}';
    return (_db.select(_db.goods)
          ..where((t) =>
              t.oshiId.equals(oshiId) & t.purchaseDate.like('$prefix%'))
          ..orderBy([(t) => OrderingTerm.asc(t.purchaseDate)]))
        .get();
  }

  /// 月 + カテゴリ 複合フィルタ
  Future<List<Good>> getGoodsByMonthAndCategory(
      int oshiId, int year, int month, String category) {
    final prefix = '$year-${month.toString().padLeft(2, '0')}';
    return (_db.select(_db.goods)
          ..where((t) =>
              t.oshiId.equals(oshiId) &
              t.purchaseDate.like('$prefix%') &
              t.category.equals(category))
          ..orderBy([(t) => OrderingTerm.asc(t.purchaseDate)]))
        .get();
  }

  /// 期間フィルタ（from〜to の YYYY-MM-DD 文字列で範囲指定）
  Future<List<Good>> getGoodsByDateRange(
      int oshiId, String fromDate, String toDate) {
    return (_db.select(_db.goods)
          ..where((t) =>
              t.oshiId.equals(oshiId) &
              t.purchaseDate.isBiggerOrEqualValue(fromDate) &
              t.purchaseDate.isSmallerOrEqualValue(toDate))
          ..orderBy([(t) => OrderingTerm.asc(t.purchaseDate)]))
        .get();
  }

  /// 期間 + カテゴリ 複合フィルタ
  Future<List<Good>> getGoodsByDateRangeAndCategory(
      int oshiId, String fromDate, String toDate, String category) {
    return (_db.select(_db.goods)
          ..where((t) =>
              t.oshiId.equals(oshiId) &
              t.purchaseDate.isBiggerOrEqualValue(fromDate) &
              t.purchaseDate.isSmallerOrEqualValue(toDate) &
              t.category.equals(category))
          ..orderBy([(t) => OrderingTerm.asc(t.purchaseDate)]))
        .get();
  }

  /// グッズ単体取得
  Future<Good?> getGoodsById(int id) =>
      (_db.select(_db.goods)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  /// グッズを更新
  Future<bool> updateGoods(GoodsCompanion companion) =>
      _db.update(_db.goods).replace(companion);

  /// グッズを削除
  Future<int> deleteGoods(int id) =>
      (_db.delete(_db.goods)..where((t) => t.id.equals(id))).go();

  /// 推しごとの合計グッズ支出
  Future<int> getTotalAmountByOshi(int oshiId) async {
    final rows = await (_db.select(_db.goods)
          ..where((t) => t.oshiId.equals(oshiId)))
        .get();
    return rows.fold<int>(0, (sum, g) => sum + g.amount * g.quantity);
  }

  /// 月別グッズ支出合計
  Future<int> getTotalAmountByMonth(int oshiId, int year, int month) async {
    final prefix = '$year-${month.toString().padLeft(2, '0')}';
    final rows = await (_db.select(_db.goods)
          ..where((t) =>
              t.oshiId.equals(oshiId) & t.purchaseDate.like('$prefix%')))
        .get();
    return rows.fold<int>(0, (sum, g) => sum + g.amount * g.quantity);
  }

  /// グッズをウォッチ
  Stream<List<Good>> watchGoodsByOshi(int oshiId) =>
      (_db.select(_db.goods)
            ..where((t) => t.oshiId.equals(oshiId))
            ..orderBy([(t) => OrderingTerm.desc(t.purchaseDate)]))
          .watch();
}
