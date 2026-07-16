import 'package:flutter/material.dart';

/// 空状態（データなし）を表示する汎用ウィジェット。
///
/// ```dart
/// EmptyStateView(
///   icon: Icons.event_note,
///   message: 'イベントはまだありません',
///   actionLabel: 'イベントを追加',
///   onAction: () => context.push('/oshi/$oshiId/event/new'),
/// )
/// ```
class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateView({
    super.key,
    this.icon = Icons.inbox,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(message),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.add),
              label: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
