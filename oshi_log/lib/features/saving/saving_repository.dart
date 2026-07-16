import 'package:drift/drift.dart';
import 'package:oshi_log/shared/database/app_database.dart';

class SavingRepository {
  final AppDatabase _db;
  SavingRepository(this._db);

  // --- SavingPlans ---

  /// プランを登録し ID を返す
  Future<int> insertPlan(SavingPlansCompanion companion) =>
      _db.into(_db.savingPlans).insert(companion);

  /// 推しに紐づくプラン一覧
  Future<List<SavingPlan>> getPlansByOshi(int oshiId) =>
      (_db.select(_db.savingPlans)
            ..where((t) => t.oshiId.equals(oshiId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  /// プラン単体取得
  Future<SavingPlan?> getPlanById(int id) =>
      (_db.select(_db.savingPlans)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  /// プランを更新
  Future<bool> updatePlan(SavingPlansCompanion companion) =>
      _db.update(_db.savingPlans).replace(companion);

  /// プランを削除
  Future<int> deletePlan(int id) =>
      (_db.delete(_db.savingPlans)..where((t) => t.id.equals(id))).go();

  /// プランをウォッチ
  Stream<List<SavingPlan>> watchPlansByOshi(int oshiId) =>
      (_db.select(_db.savingPlans)
            ..where((t) => t.oshiId.equals(oshiId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  // --- SavingRecords ---

  /// 貯金記録を登録（チェックイン）
  Future<int> checkIn(SavingRecordsCompanion companion) =>
      _db.into(_db.savingRecords).insert(companion);

  /// プランの全記録を取得（日付昇順）
  Future<List<SavingRecord>> getRecordsByPlan(int planId) =>
      (_db.select(_db.savingRecords)
            ..where((t) => t.planId.equals(planId))
            ..orderBy([(t) => OrderingTerm.asc(t.date)]))
          .get();

  /// 月ごとの合計貯金額
  Future<int> getMonthlyTotal(int planId, int year, int month) async {
    final prefix = '$year-${month.toString().padLeft(2, '0')}';
    final rows = await (_db.select(_db.savingRecords)
          ..where(
              (t) => t.planId.equals(planId) & t.date.like('$prefix%')))
        .get();
    return rows.fold<int>(0, (sum, r) => sum + r.amount);
  }

  /// 累計貯金額
  Future<int> getTotalAmount(int planId) async {
    final rows = await (_db.select(_db.savingRecords)
          ..where((t) => t.planId.equals(planId)))
        .get();
    return rows.fold<int>(0, (sum, r) => sum + r.amount);
  }

  /// 連続貯金日数（ストリーク）を today 基準で計算
  Future<int> getStreak(int planId, DateTime today) async {
    final rows = await (_db.select(_db.savingRecords)
          ..where((t) => t.planId.equals(planId))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();

    final dates = rows.map((r) => r.date).toSet();
    int streak = 0;
    var current = DateTime(today.year, today.month, today.day);

    while (true) {
      final key =
          '${current.year}-${current.month.toString().padLeft(2, '0')}-${current.day.toString().padLeft(2, '0')}';
      if (dates.contains(key)) {
        streak++;
        current = current.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  /// 特定日に貯金済みか確認
  Future<bool> hasCheckedIn(int planId, String date) async {
    final row = await (_db.select(_db.savingRecords)
          ..where((t) => t.planId.equals(planId) & t.date.equals(date)))
        .getSingleOrNull();
    return row != null;
  }

  /// 記録をウォッチ
  Stream<List<SavingRecord>> watchRecordsByPlan(int planId) =>
      (_db.select(_db.savingRecords)
            ..where((t) => t.planId.equals(planId))
            ..orderBy([(t) => OrderingTerm.asc(t.date)]))
          .watch();
}
