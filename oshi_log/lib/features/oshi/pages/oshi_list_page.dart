import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/database/app_database.dart';
import '../../../shared/database/database_provider.dart';
import '../../../shared/notifications/web_banner_service.dart';
import '../../../shared/widgets/oshi_icon.dart';
import '../oshi_providers.dart';

class OshiListPage extends ConsumerStatefulWidget {
  const OshiListPage({super.key});

  @override
  ConsumerState<OshiListPage> createState() => _OshiListPageState();
}

class _OshiListPageState extends ConsumerState<OshiListPage> {
  @override
  void initState() {
    super.initState();
    // 画面描画後に Web バナーチェックを実行（1 セッション 1 回のみ）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final db = ref.read(databaseProvider);
      WebBannerService.instance.showStartupBanners(context, db);
    });
  }

  @override
  Widget build(BuildContext context) {
    final oshiListAsync = ref.watch(oshiListProvider);
    final sort = ref.watch(oshiSortProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('推し一覧'),
        actions: [
          PopupMenuButton<OshiSort>(
            icon: const Icon(Icons.sort),
            tooltip: '並び替え',
            initialValue: sort,
            onSelected: (v) =>
                ref.read(oshiSortProvider.notifier).state = v,
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: OshiSort.createdAt,
                child: Text('登録順'),
              ),
              PopupMenuItem(
                value: OshiSort.name,
                child: Text('名前順'),
              ),
              PopupMenuItem(
                value: OshiSort.lastViewed,
                child: Text('最近閲覧順'),
              ),
            ],
          ),
        ],
      ),
      body: oshiListAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('エラー: $e')),
        data: (list) {
          if (list.isEmpty) {
            return const _EmptyOshiView();
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (context, i) => _OshiCard(oshi: list[i]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'oshi_list_fab',
        onPressed: () => context.push('/oshi/new'),
        icon: const Icon(Icons.add),
        label: const Text('推しを追加'),
      ),
    );
  }
}

class _OshiCard extends StatelessWidget {
  final Oshi oshi;
  const _OshiCard({required this.oshi});

  @override
  Widget build(BuildContext context) {
    final color = Color(oshi.coverColor);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/oshi/${oshi.id}'),
        child: Row(
          children: [
            // カバーカラー帯
            Container(
              width: 6,
              height: 72,
              color: color,
            ),
            const SizedBox(width: 12),
            // アイコン
            OshiCircleAvatar(
              iconPath: oshi.iconPath,
              name: oshi.name,
              coverColor: color,
              radius: 28,
            ),
            const SizedBox(width: 12),
            // 名前・カテゴリ
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    oshi.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    oshi.category,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class _EmptyOshiView extends StatelessWidget {
  const _EmptyOshiView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite_border,
              size: 72, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          const Text('推しがまだいません'),
          const SizedBox(height: 8),
          const Text('「推しを追加」ボタンで登録してみましょう！'),
        ],
      ),
    );
  }
}
