import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/database/database_provider.dart';
import 'summary_repository.dart';

/// SummaryRepository Provider
final summaryRepositoryProvider = Provider<SummaryRepository>((ref) {
  return SummaryRepository(ref.watch(databaseProvider));
});

// --- 選択中の年月 ---
final selectedYearProvider =
    StateProvider<int>((ref) => DateTime.now().year);
final selectedMonthProvider =
    StateProvider<int>((ref) => DateTime.now().month);

// --- 月次 ---

/// 選択月の全支出合計
final monthlyTotalProvider = FutureProvider<int>((ref) {
  final repo = ref.watch(summaryRepositoryProvider);
  final year = ref.watch(selectedYearProvider);
  final month = ref.watch(selectedMonthProvider);
  return repo.getMonthlyTotal(year, month);
});

/// 選択月の推しごと支出内訳
final monthlyByOshiProvider =
    FutureProvider<List<OshiAmount>>((ref) {
  final repo = ref.watch(summaryRepositoryProvider);
  final year = ref.watch(selectedYearProvider);
  final month = ref.watch(selectedMonthProvider);
  return repo.getMonthlyByOshi(year, month);
});

// --- 年次 ---

/// 年間の月別支出（12要素のリスト）
final yearlyMonthlyProvider =
    FutureProvider<List<int>>((ref) {
  final repo = ref.watch(summaryRepositoryProvider);
  final year = ref.watch(selectedYearProvider);
  return repo.getYearlyMonthly(year);
});
