import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/database/app_database.dart';
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

// --- 推しごとサマリー ---

/// 選択中の推し ID（null = 未選択）
final selectedOshiIdProvider = StateProvider<int?>((ref) => null);

/// 全推し一覧（推しタブのドロップダウン用）
final allOshisForSummaryProvider = FutureProvider<List<Oshi>>((ref) {
  return ref.watch(summaryRepositoryProvider).getAllOshis();
});

/// 選択中の推しへの累計支出
final oshiTotalProvider = FutureProvider<int?>((ref) async {
  final id = ref.watch(selectedOshiIdProvider);
  if (id == null) return null;
  return ref.watch(summaryRepositoryProvider).getOshiTotal(id);
});

/// 選択中の推しの年間月別支出
final oshiMonthlyProvider = FutureProvider<List<int>?>((ref) async {
  final id = ref.watch(selectedOshiIdProvider);
  final year = ref.watch(selectedYearProvider);
  if (id == null) return null;
  return ref.watch(summaryRepositoryProvider).getOshiMonthly(id, year);
});

/// 選択中の推しのイベント参加回数
final oshiEventCountProvider = FutureProvider<int?>((ref) async {
  final id = ref.watch(selectedOshiIdProvider);
  if (id == null) return null;
  return ref.watch(summaryRepositoryProvider).getOshiEventCount(id);
});

/// 選択中の推しのグッズ購入点数
final oshiGoodsCountProvider = FutureProvider<int?>((ref) async {
  final id = ref.watch(selectedOshiIdProvider);
  if (id == null) return null;
  return ref.watch(summaryRepositoryProvider).getOshiGoodsCount(id);
});
