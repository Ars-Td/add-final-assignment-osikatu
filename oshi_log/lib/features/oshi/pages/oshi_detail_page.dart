import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/confirm_dialog.dart';
import '../../../shared/widgets/oshi_icon.dart';
import '../../event/widgets/event_list_tab.dart';
import '../../goods/widgets/goods_list_tab.dart';
import '../../saving/widgets/saving_list_tab.dart';
import '../oshi_providers.dart';

class OshiDetailPage extends ConsumerStatefulWidget {
  final int oshiId;
  const OshiDetailPage({super.key, required this.oshiId});

  @override
  ConsumerState<OshiDetailPage> createState() => _OshiDetailPageState();
}

class _OshiDetailPageState extends ConsumerState<OshiDetailPage> {
  @override
  void initState() {
    super.initState();
    // ページ表示時に lastViewedAt を更新し、最近閲覧順ソートを機能させる
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(oshiRepositoryProvider)
          .touchLastViewed(widget.oshiId);
      // 一覧 Provider を invalidate して最近閲覧順に反映
      ref.invalidate(oshiListProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final oshiAsync = ref.watch(oshiByIdProvider(widget.oshiId));

    return oshiAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('エラー: $e')),
      ),
      data: (oshi) {
        if (oshi == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('推しが見つかりません')),
          );
        }

        final color = Color(oshi.coverColor);

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (context, _) => [
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  actions: [
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onSelected: (v) async {
                        if (v == 'edit') {
                          context.push('/oshi/${widget.oshiId}/edit');
                        } else if (v == 'delete') {
                          final ok = await showConfirmDialog(
                            context: context,
                            title: '推しを削除',
                            content:
                                'この推しとすべての関連データが削除されます。よろしいですか？',
                          );
                          if (ok == true && context.mounted) {
                            await ref
                                .read(oshiRepositoryProvider)
                                .deleteOshi(widget.oshiId);
                            if (context.mounted) context.pop();
                          }
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'edit', child: Text('編集')),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('削除',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [color, color.withValues(alpha: 0.7)],
                        ),
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 48,
                              backgroundColor: Colors.white24,
                              backgroundImage:
                                  buildOshiIconImage(oshi.iconPath),
                              child: oshi.iconPath == null
                                  ? Text(
                                      oshi.name.isNotEmpty
                                          ? oshi.name[0]
                                          : '?',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              oshi.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              oshi.category,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  bottom: TabBar(
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white60,
                    indicatorColor: Colors.white,
                    tabs: const [
                      Tab(text: 'イベント'),
                      Tab(text: 'グッズ'),
                      Tab(text: '貯金'),
                    ],
                  ),
                ),
              ],
              body: TabBarView(
                children: [
                  EventListTab(oshiId: widget.oshiId),
                  GoodsListTab(oshiId: widget.oshiId),
                  SavingListTab(oshiId: widget.oshiId),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
