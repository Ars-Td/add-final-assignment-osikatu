import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/database/app_database.dart';
import '../../shared/database/database_provider.dart';
import 'goods_repository.dart';

/// GoodsRepository Provider
final goodsRepositoryProvider = Provider<GoodsRepository>((ref) {
  return GoodsRepository(ref.watch(databaseProvider));
});

// --- 表示モード ---
enum GoodsViewMode { list, grid }

final goodsViewModeProvider =
    StateProvider.family<GoodsViewMode, int>(
        (ref, oshiId) => GoodsViewMode.list);

// --- ソート ---
enum GoodsSort { newerFirst, olderFirst }

final goodsSortProvider =
    StateProvider.family<GoodsSort, int>(
        (ref, oshiId) => GoodsSort.newerFirst);

// --- 月フィルタ ---
class GoodsMonthFilter {
  final int? year;
  final int? month;
  const GoodsMonthFilter({this.year, this.month});
  bool get isActive => year != null && month != null;
}

final goodsMonthFilterProvider =
    StateProvider.family<GoodsMonthFilter, int>(
        (ref, oshiId) => const GoodsMonthFilter());

// --- カテゴリフィルタ ---
final goodsCategoryFilterProvider =
    StateProvider.family<String?, int>((ref, oshiId) => null);

// --- 期間フィルタ ---
class GoodsDateRangeFilter {
  final DateTime? from;
  final DateTime? to;
  const GoodsDateRangeFilter({this.from, this.to});
  bool get isActive => from != null || to != null;

  String? get fromStr => from == null
      ? null
      : '${from!.year}-${from!.month.toString().padLeft(2, '0')}-${from!.day.toString().padLeft(2, '0')}';

  String? get toStr => to == null
      ? null
      : '${to!.year}-${to!.month.toString().padLeft(2, '0')}-${to!.day.toString().padLeft(2, '0')}';
}

final goodsDateRangeFilterProvider =
    StateProvider.family<GoodsDateRangeFilter, int>(
        (ref, oshiId) => const GoodsDateRangeFilter());

/// 推しに紐づくグッズ一覧（ソート・フィルタ適用済み）
///
/// 優先順位: 期間フィルタ > 月フィルタ > カテゴリのみ > なし
/// カテゴリは常に他のフィルタと組み合わせ可能
final goodsListProvider =
    FutureProvider.family<List<Good>, int>((ref, oshiId) async {
  final repo = ref.watch(goodsRepositoryProvider);
  final sort = ref.watch(goodsSortProvider(oshiId));
  final monthFilter = ref.watch(goodsMonthFilterProvider(oshiId));
  final dateRange = ref.watch(goodsDateRangeFilterProvider(oshiId));
  final category = ref.watch(goodsCategoryFilterProvider(oshiId));

  List<Good> goods;

  // --- 期間フィルタ優先 ---
  if (dateRange.isActive) {
    final from = dateRange.fromStr ?? '0000-01-01';
    final to = dateRange.toStr ?? '9999-12-31';
    if (category != null) {
      goods = await repo.getGoodsByDateRangeAndCategory(
          oshiId, from, to, category);
    } else {
      goods = await repo.getGoodsByDateRange(oshiId, from, to);
    }
    if (sort == GoodsSort.newerFirst) {
      goods = goods.reversed.toList();
    }
  } else if (monthFilter.isActive && category != null) {
    // 月 + カテゴリ 複合フィルタ
    goods = await repo.getGoodsByMonthAndCategory(
        oshiId, monthFilter.year!, monthFilter.month!, category);
    if (sort == GoodsSort.newerFirst) {
      goods = goods.reversed.toList();
    }
  } else if (monthFilter.isActive) {
    // 月フィルタのみ
    goods = await repo.getGoodsByMonth(
        oshiId, monthFilter.year!, monthFilter.month!);
    if (sort == GoodsSort.newerFirst) {
      goods = goods.reversed.toList();
    }
  } else if (category != null) {
    // カテゴリフィルタのみ
    goods = await repo.getGoodsByCategory(oshiId, category);
    if (sort == GoodsSort.olderFirst) {
      goods = goods.reversed.toList();
    }
  } else {
    // フィルタなし
    goods = sort == GoodsSort.newerFirst
        ? await repo.getGoodsByOshi(oshiId)
        : (await repo.getGoodsByOshi(oshiId)).reversed.toList();
  }
  return goods;
});

/// グッズ単体取得
final goodsByIdProvider =
    FutureProvider.family<Good?, int>((ref, goodsId) {
  return ref.watch(goodsRepositoryProvider).getGoodsById(goodsId);
});
