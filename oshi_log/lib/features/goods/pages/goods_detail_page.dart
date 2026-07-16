import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/utils/format_utils.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../goods_providers.dart';

class GoodsDetailPage extends ConsumerWidget {
  final int oshiId;
  final int goodsId;
  const GoodsDetailPage(
      {super.key, required this.oshiId, required this.goodsId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goodsAsync = ref.watch(goodsByIdProvider(goodsId));

    return goodsAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('エラー: $e')),
      ),
      data: (goods) {
        if (goods == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('グッズが見つかりません')),
          );
        }

        final totalAmount = goods.amount * goods.quantity;

        return Scaffold(
          appBar: AppBar(
            title: Text(goods.name),
            actions: [
              PopupMenuButton<String>(
                onSelected: (v) async {
                  if (v == 'edit') {
                    context.push('/oshi/$oshiId/goods/$goodsId/edit');
                  } else if (v == 'delete') {
                    final ok = await showConfirmDialog(
                      context: context,
                      title: 'グッズを削除',
                      content: 'このグッズを削除しますか？',
                    );
                    if (ok == true && context.mounted) {
                      await ref
                          .read(goodsRepositoryProvider)
                          .deleteGoods(goodsId);
                      if (context.mounted) context.pop();
                    }
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('編集')),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('削除', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // カテゴリバッジ
              Chip(
                label: Text(goods.category),
                backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
              ),
              const SizedBox(height: 16),

              // 購入日
              _InfoRow(
                icon: Icons.calendar_today,
                label: '購入日',
                value: goods.purchaseDate.length >= 10
                    ? goods.purchaseDate.substring(0, 10).replaceAll('-', '/')
                    : goods.purchaseDate,
              ),

              // 購入場所
              if (goods.shop != null && goods.shop!.isNotEmpty)
                _InfoRow(
                  icon: Icons.store,
                  label: '購入場所',
                  value: goods.shop!,
                ),

              const SizedBox(height: 16),

              // 金額カード
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.payments_outlined,
                              color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 12),
                          Text('単価',
                              style: Theme.of(context).textTheme.titleMedium),
                          const Spacer(),
                          Text('¥${formatAmount(goods.amount)}',
                              style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.numbers,
                              color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 12),
                          Text('数量',
                              style: Theme.of(context).textTheme.titleMedium),
                          const Spacer(),
                          Text('${goods.quantity}個',
                              style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Icon(Icons.summarize,
                              color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 12),
                          Text('合計',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const Spacer(),
                          Text(
                            '¥${formatAmount(totalAmount)}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // メモ
              if (goods.memo != null && goods.memo!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text('メモ', style: Theme.of(context).textTheme.titleSmall),
                const Divider(),
                Text(goods.memo!),
              ],

              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(width: 8),
          Expanded(
            child:
                Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
