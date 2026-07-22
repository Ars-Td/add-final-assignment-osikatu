import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/database/app_database.dart';
import '../../../shared/utils/format_utils.dart';
import '../../../shared/utils/photo_utils.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/oshi_icon.dart';
import '../goods_providers.dart';

/// グッズカテゴリ一覧
const _kCategories = [
  'CD',
  'Blu-ray',
  '写真集',
  'アパレル',
  'アクセサリー',
  '雑貨',
  'その他',
];

/// OshiDetailPage のグッズタブ
class GoodsListTab extends ConsumerWidget {
  final int oshiId;
  const GoodsListTab({super.key, required this.oshiId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goodsAsync = ref.watch(goodsListProvider(oshiId));
    final viewMode = ref.watch(goodsViewModeProvider(oshiId));
    final filter = ref.watch(goodsMonthFilterProvider(oshiId));
    final dateRange = ref.watch(goodsDateRangeFilterProvider(oshiId));
    final category = ref.watch(goodsCategoryFilterProvider(oshiId));

    return Column(
      children: [
        _GoodsToolbar(oshiId: oshiId),
        Expanded(
          child: goodsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('エラー: $e')),
            data: (goodsList) {
              if (goodsList.isEmpty) {
                final hasFilter =
                    filter.isActive || dateRange.isActive || category != null;
                return EmptyStateView(
                  icon: Icons.shopping_bag_outlined,
                  message: hasFilter
                      ? '条件に一致するグッズがありません'
                      : 'グッズはまだありません',
                  actionLabel: hasFilter ? null : 'グッズを追加',
                  onAction: hasFilter
                      ? null
                      : () => context.push('/oshi/$oshiId/goods/new'),
                );
              }

              return Stack(
                children: [
                  viewMode == GoodsViewMode.grid
                      ? _GoodsGridView(oshiId: oshiId, goodsList: goodsList)
                      : _GoodsListView(oshiId: oshiId, goodsList: goodsList),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: FloatingActionButton(
                      heroTag: 'goods_list_tab_fab',
                      onPressed: () =>
                          context.push('/oshi/$oshiId/goods/new'),
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// ツールバー
// ---------------------------------------------------------------------------

class _GoodsToolbar extends ConsumerWidget {
  final int oshiId;
  const _GoodsToolbar({required this.oshiId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(goodsViewModeProvider(oshiId));
    final sort = ref.watch(goodsSortProvider(oshiId));

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
      child: Row(
        children: [
          // 月フィルタチップ
          _MonthFilterChip(oshiId: oshiId),

          const SizedBox(width: 4),

          // 期間フィルタチップ
          _DateRangeFilterChip(oshiId: oshiId),

          const SizedBox(width: 4),

          // カテゴリフィルタチップ
          _CategoryFilterChip(oshiId: oshiId),

          const Spacer(),

          // ソートメニュー
          PopupMenuButton<GoodsSort>(
            tooltip: '並び替え',
            icon: const Icon(Icons.sort),
            initialValue: sort,
            onSelected: (v) =>
                ref.read(goodsSortProvider(oshiId).notifier).state = v,
            itemBuilder: (_) => [
              CheckedPopupMenuItem(
                value: GoodsSort.newerFirst,
                checked: sort == GoodsSort.newerFirst,
                child: const Text('新しい順'),
              ),
              CheckedPopupMenuItem(
                value: GoodsSort.olderFirst,
                checked: sort == GoodsSort.olderFirst,
                child: const Text('古い順'),
              ),
            ],
          ),

          // グリッド / リスト 切り替えボタン
          IconButton(
            tooltip: viewMode == GoodsViewMode.list ? 'グリッド表示' : 'リスト表示',
            icon: Icon(
              viewMode == GoodsViewMode.list
                  ? Icons.grid_view
                  : Icons.view_list,
            ),
            onPressed: () {
              ref.read(goodsViewModeProvider(oshiId).notifier).state =
                  viewMode == GoodsViewMode.list
                      ? GoodsViewMode.grid
                      : GoodsViewMode.list;
            },
          ),

          // グッズ追加ボタン（ツールバー）
          IconButton(
            tooltip: 'グッズを追加',
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/oshi/$oshiId/goods/new'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 月フィルタチップ
// ---------------------------------------------------------------------------

class _MonthFilterChip extends ConsumerWidget {
  final int oshiId;
  const _MonthFilterChip({required this.oshiId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(goodsMonthFilterProvider(oshiId));
    final label =
        filter.isActive ? '${filter.year}/${filter.month}' : '全期間';

    return ActionChip(
      avatar: const Icon(Icons.calendar_month, size: 16),
      label: Text(label),
      backgroundColor: filter.isActive
          ? Theme.of(context).colorScheme.primaryContainer
          : null,
      onPressed: () => _showMonthPicker(context, ref, filter),
    );
  }

  Future<void> _showMonthPicker(
      BuildContext context, WidgetRef ref, GoodsMonthFilter current) async {
    int selectedYear = current.year ?? DateTime.now().year;

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () => setState(() => selectedYear--),
                  ),
                  Text('$selectedYear年'),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () => setState(() => selectedYear++),
                  ),
                ],
              ),
              content: SizedBox(
                width: 280,
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  children: List.generate(12, (i) {
                    final m = i + 1;
                    final selected =
                        current.year == selectedYear && current.month == m;
                    return TextButton(
                      style: selected
                          ? TextButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            )
                          : null,
                      onPressed: () {
                        ref
                            .read(goodsMonthFilterProvider(oshiId).notifier)
                            .state = GoodsMonthFilter(
                                year: selectedYear, month: m);
                        Navigator.pop(ctx);
                      },
                      child: Text('$m月'),
                    );
                  }),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    ref
                        .read(goodsMonthFilterProvider(oshiId).notifier)
                        .state = const GoodsMonthFilter();
                    Navigator.pop(ctx);
                  },
                  child: const Text('全期間'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('閉じる'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// カテゴリフィルタチップ
// ---------------------------------------------------------------------------

class _CategoryFilterChip extends ConsumerWidget {
  final int oshiId;
  const _CategoryFilterChip({required this.oshiId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(goodsCategoryFilterProvider(oshiId));

    return PopupMenuButton<String?>(
      tooltip: 'カテゴリ',
      child: Chip(
        avatar: const Icon(Icons.label_outline, size: 16),
        label: Text(category ?? 'カテゴリ'),
        backgroundColor: category != null
            ? Theme.of(context).colorScheme.primaryContainer
            : null,
      ),
      onSelected: (v) =>
          ref.read(goodsCategoryFilterProvider(oshiId).notifier).state = v,
      itemBuilder: (_) => [
        const PopupMenuItem<String?>(
          value: null,
          child: Text('すべて'),
        ),
        ..._kCategories.map(
          (c) => PopupMenuItem<String?>(
            value: c,
            child: Text(c),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 期間フィルタチップ
// ---------------------------------------------------------------------------

class _DateRangeFilterChip extends ConsumerWidget {
  final int oshiId;
  const _DateRangeFilterChip({required this.oshiId});

  String _fmt(DateTime? dt) {
    if (dt == null) return '';
    return '${dt.month}/${dt.day}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(goodsDateRangeFilterProvider(oshiId));
    final label = range.isActive
        ? '${_fmt(range.from)}〜${_fmt(range.to)}'
        : '期間';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ActionChip(
          avatar: const Icon(Icons.date_range, size: 16),
          label: Text(label),
          backgroundColor: range.isActive
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
          onPressed: () => _showPicker(context, ref, range),
        ),
        if (range.isActive) ...[
          const SizedBox(width: 2),
          InkWell(
            onTap: () => ref
                .read(goodsDateRangeFilterProvider(oshiId).notifier)
                .state = const GoodsDateRangeFilter(),
            borderRadius: BorderRadius.circular(10),
            child: const Padding(
              padding: EdgeInsets.all(2),
              child: Icon(Icons.close, size: 14),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _showPicker(BuildContext context, WidgetRef ref,
      GoodsDateRangeFilter current) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: (current.from != null && current.to != null)
          ? DateTimeRange(start: current.from!, end: current.to!)
          : null,
      helpText: '期間を選択',
      cancelText: 'キャンセル',
      confirmText: '決定',
    );

    if (picked != null) {
      ref.read(goodsDateRangeFilterProvider(oshiId).notifier).state =
          GoodsDateRangeFilter(from: picked.start, to: picked.end);
    }
  }
}

// ---------------------------------------------------------------------------
// リストビュー
// ---------------------------------------------------------------------------

class _GoodsListView extends StatelessWidget {
  final int oshiId;
  final List<Good> goodsList;
  const _GoodsListView({required this.oshiId, required this.goodsList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 80),
      itemCount: goodsList.length,
      itemBuilder: (context, i) {
        final goods = goodsList[i];
        final dateStr = goods.purchaseDate.length >= 10
            ? goods.purchaseDate.substring(0, 10).replaceAll('-', '/')
            : goods.purchaseDate;
        final totalAmount = goods.amount * goods.quantity;
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            onTap: () => context.push('/oshi/$oshiId/goods/${goods.id}'),
            leading: CircleAvatar(
              backgroundColor:
                  Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                Icons.shopping_bag,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            title: Text(goods.name),
            subtitle: Text('$dateStr　${goods.category}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '¥${formatAmount(totalAmount)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (goods.quantity > 1)
                  Text(
                    '×${goods.quantity}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                const Icon(Icons.chevron_right, size: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// グリッドビュー
// ---------------------------------------------------------------------------

class _GoodsGridView extends StatelessWidget {
  final int oshiId;
  final List<Good> goodsList;
  const _GoodsGridView({required this.oshiId, required this.goodsList});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 80),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.82,
      ),
      itemCount: goodsList.length,
      itemBuilder: (context, i) {
        final goods = goodsList[i];
        return _GoodsGridCard(oshiId: oshiId, goods: goods);
      },
    );
  }
}

class _GoodsGridCard extends StatelessWidget {
  final int oshiId;
  final Good goods;
  const _GoodsGridCard({required this.oshiId, required this.goods});

  @override
  Widget build(BuildContext context) {
    final totalAmount = goods.amount * goods.quantity;
    final dateStr = goods.purchaseDate.length >= 10
        ? goods.purchaseDate.substring(0, 10).replaceAll('-', '/')
        : goods.purchaseDate;

    // 写真があれば表示、なければアイコン
    final photoPaths = decodePhotoPaths(goods.photoPaths);
    final hasPhoto = photoPaths.isNotEmpty;
    final legacyPath =
        !hasPhoto && goods.imagePath != null && goods.imagePath!.isNotEmpty
            ? goods.imagePath
            : null;
    final displayPath =
        hasPhoto ? photoPaths.first : legacyPath;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/oshi/$oshiId/goods/${goods.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // サムネイル部分
            Expanded(
              child: _GoodsThumbnail(imagePath: displayPath),
            ),

            // テキスト情報
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goods.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    goods.category,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          '¥${formatAmount(totalAmount)}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        dateStr,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.5),
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

/// グリッドカードのサムネイル
class _GoodsThumbnail extends StatelessWidget {
  final String? imagePath;
  const _GoodsThumbnail({this.imagePath});

  @override
  Widget build(BuildContext context) {
    final img = buildOshiIconImage(imagePath);

    if (img != null) {
      return Image(
        image: img,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      width: double.infinity,
      child: Icon(
        Icons.shopping_bag,
        size: 48,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
