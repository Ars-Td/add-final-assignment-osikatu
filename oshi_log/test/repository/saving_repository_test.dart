import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oshi_log/features/oshi/oshi_repository.dart';
import 'package:oshi_log/features/saving/saving_repository.dart';
import 'package:oshi_log/shared/database/app_database.dart';

void main() {
  late AppDatabase db;
  late OshiRepository oshiRepo;
  late SavingRepository savingRepo;
  late int oshiId;
  late int planId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    oshiRepo = OshiRepository(db);
    savingRepo = SavingRepository(db);
    oshiId = await oshiRepo.insertOshi(OshisCompanion.insert(
      name: 'テスト推し',
      coverColor: 0xFFE91E8C,
      category: 'アイドル',
      createdAt: '2026-07-16T00:00:00.000Z',
    ));
    planId = await savingRepo.insertPlan(SavingPlansCompanion.insert(
      oshiId: oshiId,
      name: '誕生日貯金',
      startDate: '2026-07-01',
      dailyAmount: 100,
      createdAt: '2026-07-16T00:00:00.000Z',
    ));
  });

  tearDown(() async {
    await db.close();
  });

  group('SavingRepository', () {
    test('貯金記録を登録して取得できる', () async {
      await savingRepo.checkIn(SavingRecordsCompanion.insert(
        planId: planId,
        date: '2026-07-16',
        amount: 100,
        createdAt: '2026-07-16T00:00:00.000Z',
      ));

      final records = await savingRepo.getRecordsByPlan(planId);
      expect(records.length, 1);
      expect(records.first.amount, 100);
    });

    test('月ごとの合計貯金額を取得できる', () async {
      await savingRepo.checkIn(SavingRecordsCompanion.insert(
        planId: planId,
        date: '2026-07-10',
        amount: 100,
        createdAt: '2026-07-16T00:00:00.000Z',
      ));
      await savingRepo.checkIn(SavingRecordsCompanion.insert(
        planId: planId,
        date: '2026-07-11',
        amount: 200,
        createdAt: '2026-07-16T00:00:00.000Z',
      ));

      final total = await savingRepo.getMonthlyTotal(planId, 2026, 7);
      expect(total, 300);
    });

    test('連続貯金日数（ストリーク）を計算できる', () async {
      final today = DateTime(2026, 7, 16);
      await savingRepo.checkIn(SavingRecordsCompanion.insert(
        planId: planId,
        date: '2026-07-14',
        amount: 100,
        createdAt: '2026-07-16T00:00:00.000Z',
      ));
      await savingRepo.checkIn(SavingRecordsCompanion.insert(
        planId: planId,
        date: '2026-07-15',
        amount: 100,
        createdAt: '2026-07-16T00:00:00.000Z',
      ));
      await savingRepo.checkIn(SavingRecordsCompanion.insert(
        planId: planId,
        date: '2026-07-16',
        amount: 100,
        createdAt: '2026-07-16T00:00:00.000Z',
      ));

      final streak = await savingRepo.getStreak(planId, today);
      expect(streak, 3);
    });

    test('途中で途切れた場合ストリークがリセットされる', () async {
      final today = DateTime(2026, 7, 16);
      await savingRepo.checkIn(SavingRecordsCompanion.insert(
        planId: planId,
        date: '2026-07-14',
        amount: 100,
        createdAt: '2026-07-16T00:00:00.000Z',
      ));
      // 7/15はスキップ
      await savingRepo.checkIn(SavingRecordsCompanion.insert(
        planId: planId,
        date: '2026-07-16',
        amount: 100,
        createdAt: '2026-07-16T00:00:00.000Z',
      ));

      final streak = await savingRepo.getStreak(planId, today);
      expect(streak, 1);
    });

    test('累計貯金額を取得できる', () async {
      await savingRepo.checkIn(SavingRecordsCompanion.insert(
        planId: planId,
        date: '2026-07-10',
        amount: 100,
        createdAt: '2026-07-16T00:00:00.000Z',
      ));
      await savingRepo.checkIn(SavingRecordsCompanion.insert(
        planId: planId,
        date: '2026-07-11',
        amount: 200,
        createdAt: '2026-07-16T00:00:00.000Z',
      ));

      final total = await savingRepo.getTotalAmount(planId);
      expect(total, 300);
    });
  });
}
