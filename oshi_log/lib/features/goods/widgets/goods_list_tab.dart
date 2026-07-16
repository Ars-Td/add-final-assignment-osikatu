import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/utils/format_utils.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../goods_providers.dart';

/// OshiDetailPage のグッズタブ
class GoodsListTab extends ConsumerWidget {
  final int oshiId;
  const GoodsListTab({super.key, required this.oshiId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goodsAsync = ref.watch(goodsListProvider(oshiId));

    return goodsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('エラー: $e')),
      data: (goodsList) {
        if (goodsList.isEmpty) {
          return EmptyStateView(
            icon: Icons.shopping_bag_outlined,
            message: 'グッズはまだありません',
            actionLabel: 'グッズを追加',
            onAction: () => context.push('/oshi/$oshiId/goods/new'),
          );
        }

        return Stack(
          children: [
            ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
              itemCount: goodsList.length,
              itemBuilder: (context, i) {
                final goods = goodsList[i];
                final dateStr = goods.purchaseDate.length >= 10
                    ? goods.purchaseDate
                        .substring(0, 10)
                        .replaceAll('-', '/')
                    : goods.purchaseDate;
                final totalAmount = goods.amount * goods.quantity;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    onTap: () =>
                        context.push('/oshi/$oshiId/goods/${goods.id}'),
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
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: FloatingActionButton(
                heroTag: 'goods_list_tab_fab',
                onPressed: () => context.push('/oshi/$oshiId/goods/new'),
                child: const Icon(Icons.add),
              ),
            ),
          ],
        );
      },
    );
  }
}
