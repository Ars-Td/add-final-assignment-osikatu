import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/utils/format_utils.dart';
import '../../../shared/utils/photo_utils.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../../../shared/widgets/oshi_icon.dart';
import '../event_providers.dart';

class EventDetailPage extends ConsumerWidget {
  final int oshiId;
  final int eventId;
  const EventDetailPage(
      {super.key, required this.oshiId, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventByIdProvider(eventId));
    final expensesAsync = ref.watch(eventExpensesProvider(eventId));

    return eventAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('エラー: $e')),
      ),
      data: (event) {
        if (event == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('イベントが見つかりません')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(event.name),
            actions: [
              PopupMenuButton<String>(
                onSelected: (v) async {
                  if (v == 'edit') {
                    context.push('/oshi/$oshiId/event/$eventId/edit');
                  } else if (v == 'delete') {
                    final ok = await showConfirmDialog(
                      context: context,
                      title: 'イベントを削除',
                      content: 'このイベントを削除しますか？',
                    );
                    if (ok == true && context.mounted) {
                      await ref
                          .read(eventRepositoryProvider)
                          .deleteEvent(eventId);
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
                label: Text(event.category),
                backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
              ),
              const SizedBox(height: 16),

              // 日付
              _InfoRow(
                icon: Icons.calendar_today,
                label: '日付',
                value: event.date.length >= 10
                    ? event.date.substring(0, 10).replaceAll('-', '/')
                    : event.date,
              ),

              // 場所・会場
              if (event.venue != null && event.venue!.isNotEmpty)
                _InfoRow(
                  icon: Icons.place,
                  label: '会場',
                  value: event.venue!,
                ),

              const SizedBox(height: 16),

              // 支出合計
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.payments_outlined,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 12),
                      Text(
                        '支出合計',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      Text(
                        '¥${formatAmount(event.totalAmount)}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                ),
              ),

              // 内訳
              expensesAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (e, _) => const SizedBox.shrink(),
                data: (expenses) {
                  if (expenses.isEmpty) return const SizedBox.shrink();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text('内訳',
                          style: Theme.of(context).textTheme.titleSmall),
                      const Divider(),
                      ...expenses.map((e) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(e.label),
                             trailing: Text('¥${formatAmount(e.amount)}'),
                          )),
                    ],
                  );
                },
              ),

              // 写真
              _PhotoSection(photoPaths: decodePhotoPaths(event.photoPaths)),

              // メモ
              if (event.memo != null && event.memo!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text('メモ', style: Theme.of(context).textTheme.titleSmall),
                const Divider(),
                Text(event.memo!),
              ],

              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

}

/// 写真一覧（横スクロール、タップで全画面表示）
class _PhotoSection extends StatelessWidget {
  final List<String> photoPaths;
  const _PhotoSection({required this.photoPaths});

  @override
  Widget build(BuildContext context) {
    if (photoPaths.isEmpty) return const SizedBox.shrink();
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
            itemCount: photoPaths.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final img = buildOshiIconImage(photoPaths[i]);
              return GestureDetector(
                onTap: () => _showFullScreen(context, i),
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
                          child:
                              const Icon(Icons.image, color: Colors.grey),
                        ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showFullScreen(BuildContext context, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _FullScreenPhotoPage(
          paths: photoPaths,
          initialIndex: initialIndex,
        ),
      ),
    );
  }
}

/// 全画面写真ビューア
class _FullScreenPhotoPage extends StatefulWidget {
  final List<String> paths;
  final int initialIndex;
  const _FullScreenPhotoPage(
      {required this.paths, required this.initialIndex});

  @override
  State<_FullScreenPhotoPage> createState() => _FullScreenPhotoPageState();
}

class _FullScreenPhotoPageState extends State<_FullScreenPhotoPage> {
  late final PageController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
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
        title: Text('${widget.initialIndex + 1} / ${widget.paths.length}'),
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
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
