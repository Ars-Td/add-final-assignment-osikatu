import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../event_providers.dart';

/// OshiDetailPage のイベントタブ
class EventListTab extends ConsumerWidget {
  final int oshiId;
  const EventListTab({super.key, required this.oshiId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventListProvider(oshiId));

    return eventsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('エラー: $e')),
      data: (events) {
        if (events.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.event_note, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text('イベントはまだありません'),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () =>
                      context.push('/oshi/$oshiId/event/new'),
                  icon: const Icon(Icons.add),
                  label: const Text('イベントを追加'),
                ),
              ],
            ),
          );
        }

        return Stack(
          children: [
            ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
              itemCount: events.length,
              itemBuilder: (context, i) {
                final event = events[i];
                final dateStr = event.date.length >= 10
                    ? event.date.substring(0, 10).replaceAll('-', '/')
                    : event.date;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    onTap: () => context
                        .push('/oshi/$oshiId/event/${event.id}'),
                    leading: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(Icons.event,
                          color:
                              Theme.of(context).colorScheme.primary),
                    ),
                    title: Text(event.name),
                    subtitle: Text('$dateStr　${event.category}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '¥${_fmt(event.totalAmount)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
                heroTag: 'event_list_tab_fab',
                onPressed: () =>
                    context.push('/oshi/$oshiId/event/new'),
                child: const Icon(Icons.add),
              ),
            ),
          ],
        );
      },
    );
  }

  String _fmt(int amount) {
    final s = amount.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}
