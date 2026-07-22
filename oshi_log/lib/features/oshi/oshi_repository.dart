import 'package:drift/drift.dart';
import 'package:oshi_log/shared/database/app_database.dart';

class OshiRepository {
  final AppDatabase _db;
  OshiRepository(this._db);

  /// 推しを登録し、生成された ID を返す
  Future<int> insertOshi(OshisCompanion companion) =>
      _db.into(_db.oshis).insert(companion);

  /// 全推しを登録順で取得
  Future<List<Oshi>> getAllOshis() =>
      (_db.select(_db.oshis)..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

  /// 名前順で取得
  Future<List<Oshi>> getOshisSortedByName() =>
      (_db.select(_db.oshis)..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .get();

  /// 最近閲覧順で取得
  Future<List<Oshi>> getOshisSortedByLastViewed() =>
      (_db.select(_db.oshis)
            ..orderBy([
              (t) => OrderingTerm(
                    expression: t.lastViewedAt,
                    mode: OrderingMode.desc,
                    nulls: NullsOrder.last,
                  )
            ]))
          .get();

  /// ID で単体取得
  Future<Oshi?> getOshiById(int id) =>
      (_db.select(_db.oshis)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// 推しを更新（部分更新対応）
  Future<int> updateOshi(OshisCompanion companion) =>
      (_db.update(_db.oshis)..where((t) => t.id.equals(companion.id.value)))
          .write(companion);

  /// lastViewedAt を更新
  Future<void> touchLastViewed(int id) async {
    await (_db.update(_db.oshis)..where((t) => t.id.equals(id))).write(
      OshisCompanion(
        lastViewedAt: Value(DateTime.now().toIso8601String()),
      ),
    );
  }

  /// 推しを削除（関連データをカスケード削除）
  ///
  /// - 新規 DB (v3+): PRAGMA foreign_keys=ON + ON DELETE CASCADE で自動削除
  /// - 既存 DB (v1/v2): アプリコードで関連データを手動削除してから推しを削除
  Future<int> deleteOshi(int id) async {
    return _db.transaction(() async {
      // 1. イベントの支出内訳を削除
      final eventIds = await (_db.select(_db.events)
            ..where((t) => t.oshiId.equals(id)))
          .map((e) => e.id)
          .get();
      for (final eid in eventIds) {
        await (_db.delete(_db.eventExpenses)
              ..where((t) => t.eventId.equals(eid)))
            .go();
      }
      // 2. イベントを削除
      await (_db.delete(_db.events)..where((t) => t.oshiId.equals(id))).go();

      // 3. グッズを削除
      await (_db.delete(_db.goods)..where((t) => t.oshiId.equals(id))).go();

      // 4. 貯金プランと記録を削除
      final planIds = await (_db.select(_db.savingPlans)
            ..where((t) => t.oshiId.equals(id)))
          .map((p) => p.id)
          .get();
      for (final pid in planIds) {
        await (_db.delete(_db.savingRecords)
              ..where((t) => t.planId.equals(pid)))
            .go();
      }
      await (_db.delete(_db.savingPlans)
            ..where((t) => t.oshiId.equals(id)))
          .go();

      // 5. 推しを削除
      return (_db.delete(_db.oshis)..where((t) => t.id.equals(id))).go();
    });
  }

  /// 誕生日が設定されている推しを全件取得
  Future<List<Oshi>> getOshisWithBirthday() =>
      (_db.select(_db.oshis)
            ..where((t) => t.birthday.isNotNull())
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

  /// 推し一覧をウォッチ（リアクティブ）
  Stream<List<Oshi>> watchAllOshis() =>
      (_db.select(_db.oshis)..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .watch();
}
