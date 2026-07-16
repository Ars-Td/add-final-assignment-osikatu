import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oshi_log/features/event/event_repository.dart';
import 'package:oshi_log/features/oshi/oshi_repository.dart';
import 'package:oshi_log/shared/database/app_database.dart';

void main() {
  late AppDatabase db;
  late OshiRepository oshiRepo;
  late EventRepository eventRepo;
  late int oshiId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    oshiRepo = OshiRepository(db);
    eventRepo = EventRepository(db);
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

  group('EventRepository', () {
    test('イベントを登録して一覧取得できる', () async {
      await eventRepo.insertEvent(EventsCompanion.insert(
        oshiId: oshiId,
        name: 'テストコンサート',
        date: '2026-07-20',
        category: 'コンサート',
        createdAt: '2026-07-16T00:00:00.000Z',
      ));

      final list = await eventRepo.getEventsByOshi(oshiId);
      expect(list.length, 1);
      expect(list.first.name, 'テストコンサート');
    });

    test('月フィルタで取得できる', () async {
      await eventRepo.insertEvent(EventsCompanion.insert(
        oshiId: oshiId,
        name: '7月イベント',
        date: '2026-07-20',
        category: 'コンサート',
        createdAt: '2026-07-16T00:00:00.000Z',
      ));
      await eventRepo.insertEvent(EventsCompanion.insert(
        oshiId: oshiId,
        name: '8月イベント',
        date: '2026-08-10',
        category: '舞台',
        createdAt: '2026-07-16T00:00:00.000Z',
      ));

      final list = await eventRepo.getEventsByMonth(oshiId, 2026, 7);
      expect(list.length, 1);
      expect(list.first.name, '7月イベント');
    });

    test('推しごとの合計支出額を取得できる', () async {
      await eventRepo.insertEvent(EventsCompanion.insert(
        oshiId: oshiId,
        name: 'イベントA',
        date: '2026-07-20',
        category: 'コンサート',
        totalAmount: const Value(5000),
        createdAt: '2026-07-16T00:00:00.000Z',
      ));
      await eventRepo.insertEvent(EventsCompanion.insert(
        oshiId: oshiId,
        name: 'イベントB',
        date: '2026-07-25',
        category: '舞台',
        totalAmount: const Value(3000),
        createdAt: '2026-07-16T00:00:00.000Z',
      ));

      final total = await eventRepo.getTotalAmountByOshi(oshiId);
      expect(total, 8000);
    });

    test('イベントを削除できる', () async {
      final id = await eventRepo.insertEvent(EventsCompanion.insert(
        oshiId: oshiId,
        name: '削除対象',
        date: '2026-07-20',
        category: 'コンサート',
        createdAt: '2026-07-16T00:00:00.000Z',
      ));

      await eventRepo.deleteEvent(id);
      final list = await eventRepo.getEventsByOshi(oshiId);
      expect(list, isEmpty);
    });
  });
}
