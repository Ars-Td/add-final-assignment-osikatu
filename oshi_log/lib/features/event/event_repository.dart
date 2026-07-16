import 'package:drift/drift.dart';
import 'package:oshi_log/shared/database/app_database.dart';

class EventRepository {
  final AppDatabase _db;
  EventRepository(this._db);

  /// イベントを登録し ID を返す
  Future<int> insertEvent(EventsCompanion companion) =>
      _db.into(_db.events).insert(companion);

  /// 推しに紐づくイベント一覧（新しい順）
  Future<List<Event>> getEventsByOshi(int oshiId) =>
      (_db.select(_db.events)
            ..where((t) => t.oshiId.equals(oshiId))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  /// 月フィルタ（YYYY-MM プレフィックスで絞り込み）
  Future<List<Event>> getEventsByMonth(int oshiId, int year, int month) {
    final prefix =
        '$year-${month.toString().padLeft(2, '0')}';
    return (_db.select(_db.events)
          ..where(
              (t) => t.oshiId.equals(oshiId) & t.date.like('$prefix%'))
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();
  }

  /// イベント単体取得
  Future<Event?> getEventById(int id) =>
      (_db.select(_db.events)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  /// イベントを更新
  Future<bool> updateEvent(EventsCompanion companion) =>
      _db.update(_db.events).replace(companion);

  /// イベントを削除
  Future<int> deleteEvent(int id) =>
      (_db.delete(_db.events)..where((t) => t.id.equals(id))).go();

  /// 推しごとの合計支出額
  Future<int> getTotalAmountByOshi(int oshiId) async {
    final query = _db.select(_db.events)
      ..where((t) => t.oshiId.equals(oshiId));
    final rows = await query.get();
    return rows.fold<int>(0, (sum, e) => sum + e.totalAmount);
  }

  /// 月別の全推し合計支出（サマリー用）
  Future<int> getTotalAmountByMonth(int year, int month) async {
    final prefix = '$year-${month.toString().padLeft(2, '0')}';
    final rows = await (_db.select(_db.events)
          ..where((t) => t.date.like('$prefix%')))
        .get();
    return rows.fold<int>(0, (sum, e) => sum + e.totalAmount);
  }

  /// イベントをウォッチ
  Stream<List<Event>> watchEventsByOshi(int oshiId) =>
      (_db.select(_db.events)
            ..where((t) => t.oshiId.equals(oshiId))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .watch();

  // --- EventExpenses ---

  /// 支出内訳を登録
  Future<int> insertExpense(EventExpensesCompanion companion) =>
      _db.into(_db.eventExpenses).insert(companion);

  /// イベントの支出内訳一覧
  Future<List<EventExpense>> getExpensesByEvent(int eventId) =>
      (_db.select(_db.eventExpenses)
            ..where((t) => t.eventId.equals(eventId)))
          .get();

  /// イベントの支出内訳を全削除（編集時に洗い替え）
  Future<int> deleteExpensesByEvent(int eventId) =>
      (_db.delete(_db.eventExpenses)
            ..where((t) => t.eventId.equals(eventId)))
          .go();
}
