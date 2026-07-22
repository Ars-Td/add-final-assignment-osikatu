import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/database/app_database.dart';
import '../../../shared/utils/format_utils.dart';
import '../../../shared/utils/photo_utils.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../../../shared/widgets/oshi_icon.dart';
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
                      // 一覧を最新状態に更新
                      ref.invalidate(goodsListProvider(oshiId));
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

              // 写真（photoPaths 優先、なければ旧 imagePath を表示）
              _GoodsPhotoSection(goods: goods),

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

/// 写真セクション（旧 imagePath との後方互換あり）
class _GoodsPhotoSection extends StatelessWidget {
  final Good goods;
  const _GoodsPhotoSection({required this.goods});

  @override
  Widget build(BuildContext context) {
    // photoPaths 優先、空なら旧 imagePath を移行して表示
    final paths = decodePhotoPaths(goods.photoPaths).isNotEmpty
        ? decodePhotoPaths(goods.photoPaths)
        : (goods.imagePath != null ? [goods.imagePath!] : <String>[]);

    if (paths.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text('写真', style: Theme.of(context).textTheme.titleSmall),
        const Divider(),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: paths.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final img = buildOshiIconImage(paths[i]);
              return GestureDetector(
                onTap: () => _showFullScreen(context, i, paths),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: img != null
                      ? Image(
                          image: img,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 120,
                          height: 120,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showFullScreen(
      BuildContext context, int index, List<String> paths) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => _FullScreenPage(paths: paths, initialIndex: index),
    ));
  }
}

class _FullScreenPage extends StatefulWidget {
  final List<String> paths;
  final int initialIndex;
  const _FullScreenPage({required this.paths, required this.initialIndex});

  @override
  State<_FullScreenPage> createState() => _FullScreenPageState();
}

class _FullScreenPageState extends State<_FullScreenPage> {
  late final PageController _ctrl;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _ctrl = PageController(initialPage: widget.initialIndex);
    _ctrl.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    final page = _ctrl.page?.round();
    if (page != null && page != _currentIndex) {
      setState(() => _currentIndex = page);
    }
  }

  @override
  void dispose() {
    _ctrl.removeListener(_onPageChanged);
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('${_currentIndex + 1} / ${widget.paths.length}'),
      ),
      body: PageView.builder(
        controller: _ctrl,
        itemCount: widget.paths.length,
        itemBuilder: (context, i) {
          final img = buildOshiIconImage(widget.paths[i]);
          return InteractiveViewer(
            child: Center(
              child: img != null
                  ? Image(image: img, fit: BoxFit.contain)
                  : const Icon(Icons.image, color: Colors.grey, size: 80),
            ),
          );
        },
      ),
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
