import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oshi_log/features/oshi/oshi_repository.dart';
import 'package:oshi_log/shared/database/app_database.dart';

void main() {
  late AppDatabase db;
  late OshiRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = OshiRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('OshiRepository', () {
    test('推しを登録して一覧取得できる', () async {
      await repo.insertOshi(OshisCompanion.insert(
        name: 'テスト推し',
        coverColor: 0xFFE91E8C,
        category: 'アイドル',
        createdAt: '2026-07-16T00:00:00.000Z',
      ));

      final list = await repo.getAllOshis();
      expect(list.length, 1);
      expect(list.first.name, 'テスト推し');
    });

    test('推しを更新できる', () async {
      final id = await repo.insertOshi(OshisCompanion.insert(
        name: '更新前',
        coverColor: 0xFFE91E8C,
        category: 'アイドル',
        createdAt: '2026-07-16T00:00:00.000Z',
      ));

      await repo.updateOshi(OshisCompanion(
        id: Value(id),
        name: const Value('更新後'),
      ));

      final list = await repo.getAllOshis();
      expect(list.first.name, '更新後');
    });

    test('推しを削除できる', () async {
      final id = await repo.insertOshi(OshisCompanion.insert(
        name: '削除対象',
        coverColor: 0xFFE91E8C,
        category: 'アイドル',
        createdAt: '2026-07-16T00:00:00.000Z',
      ));

      await repo.deleteOshi(id);
      final list = await repo.getAllOshis();
      expect(list, isEmpty);
    });

    test('名前順で取得できる', () async {
      await repo.insertOshi(OshisCompanion.insert(
        name: 'Beta',
        coverColor: 0xFF000000,
        category: 'アイドル',
        createdAt: '2026-07-16T00:00:00.000Z',
      ));
      await repo.insertOshi(OshisCompanion.insert(
        name: 'Alpha',
        coverColor: 0xFF000000,
        category: 'アイドル',
        createdAt: '2026-07-16T00:01:00.000Z',
      ));

      final list = await repo.getOshisSortedByName();
      expect(list[0].name, 'Alpha');
      expect(list[1].name, 'Beta');
    });
  });
}
