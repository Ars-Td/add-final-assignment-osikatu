import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/database/app_database.dart';
import '../../shared/database/database_provider.dart';
import 'saving_repository.dart';

/// SavingRepository Provider
final savingRepositoryProvider = Provider<SavingRepository>((ref) {
  return SavingRepository(ref.watch(databaseProvider));
});

/// 推しに紐づくプラン一覧
final planListProvider =
    FutureProvider.family<List<SavingPlan>, int>((ref, oshiId) {
  return ref.watch(savingRepositoryProvider).getPlansByOshi(oshiId);
});

/// プラン単体
final planByIdProvider =
    FutureProvider.family<SavingPlan?, int>((ref, planId) {
  return ref.watch(savingRepositoryProvider).getPlanById(planId);
});

/// プランの全貯金記録
final recordsProvider =
    FutureProvider.family<List<SavingRecord>, int>((ref, planId) {
  return ref.watch(savingRepositoryProvider).getRecordsByPlan(planId);
});

/// 累計貯金額
final totalAmountProvider =
    FutureProvider.family<int, int>((ref, planId) {
  return ref.watch(savingRepositoryProvider).getTotalAmount(planId);
});

/// 連続貯金日数（ストリーク）
final streakProvider =
    FutureProvider.family<int, int>((ref, planId) {
  return ref
      .watch(savingRepositoryProvider)
      .getStreak(planId, DateTime.now());
});
