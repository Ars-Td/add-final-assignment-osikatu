import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

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
  int get schemaVersion => 4;

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
        },
        beforeOpen: (details) async {
          // 外部キー制約を有効化（SQLite はデフォルト OFF）
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

QueryExecutor _openConnection() {
  if (kIsWeb) {
    // Web: インメモリ（本番では drift/wasm + IndexedDB を使用）
    return NativeDatabase.memory();
  }
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'oshi_log.db'));
    return NativeDatabase(file);
  });
}
