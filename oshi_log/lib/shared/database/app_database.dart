import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Oshis,
    Events,
    EventExpenses,
    Goods,
    SavingPlans,
    SavingRecords,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // v1 → v2: events テーブルに photoPaths カラムを追加
            await m.addColumn(events, events.photoPaths);
          }
          // v2 → v3: 外部キー制約に onDelete CASCADE を追加
          // SQLite では外部キー制約の変更は CREATE TABLE のやり直しが必要だが、
          // 既存 DB では制約変更は DDL で反映されない。
          // 代わりに PRAGMA foreign_keys=ON で外部キーを有効化し、
          // アプリコード側でのカスケード削除を組み合わせる。
          if (from < 4) {
            // v3 → v4: goods テーブルに photoPaths カラムを追加
            await m.addColumn(goods, goods.photoPaths);
          }
          if (from < 5) {
            // v4 → v5: oshis テーブルに members カラムを追加（グループメンバー名 JSON）
            await m.addColumn(oshis, oshis.members);
          }
          if (from < 6) {
            // v5 → v6: oshis テーブルに icon_data カラムを追加（Web 用画像 BLOB）
            await m.addColumn(oshis, oshis.iconData);
          }
        },
        beforeOpen: (details) async {
          // 外部キー制約を有効化（SQLite はデフォルト OFF）
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

/// drift_flutter の driftDatabase() を使用。
/// - Web: WasmDatabase（IndexedDB/OPFS に永続化）
/// - iOS/Android: NativeDatabase（SQLite ファイル）
QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'oshi_log',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  );
}
