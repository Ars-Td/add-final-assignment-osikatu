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
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // v1 → v2: events テーブルに photoPaths カラムを追加
            await m.addColumn(events, events.photoPaths);
          }
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
