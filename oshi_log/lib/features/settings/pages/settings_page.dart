import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../main.dart' show themeModeProvider;
import '../../../shared/database/database_provider.dart';
import '../../../shared/notifications/notification_service.dart';
import '../export_service.dart';

// ---------------------------------------------------------------------------
// 通知設定 Provider（SharedPreferences の代わりに StateProvider で管理）
// ---------------------------------------------------------------------------

final savingReminderEnabledProvider =
    StateProvider<bool>((ref) => false);
final savingReminderHourProvider =
    StateProvider<int>((ref) => 20); // デフォルト 20:00
final savingReminderMinuteProvider =
    StateProvider<int>((ref) => 0);

// ---------------------------------------------------------------------------
// SettingsPage
// ---------------------------------------------------------------------------

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: ListView(
        children: [
          // ---- 表示設定 ----
          _SectionHeader(title: '表示設定'),
          _ThemeSection(),

          // ---- 通知設定 ----
          _SectionHeader(title: '通知設定'),
          _NotificationSection(),

          // ---- データエクスポート ----
          _SectionHeader(title: 'データエクスポート'),
          _ExportSection(),

          // ---- アプリ情報 ----
          _SectionHeader(title: 'アプリ情報'),
          const _AppInfoSection(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 表示設定セクション（ダークモード）
// ---------------------------------------------------------------------------

class _ThemeSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(themeModeProvider);
    return Column(
      children: [
        RadioListTile<ThemeMode>(
          title: const Text('システムに合わせる'),
          value: ThemeMode.system,
          groupValue: current,
          onChanged: (v) =>
              ref.read(themeModeProvider.notifier).state = v!,
          secondary: const Icon(Icons.brightness_auto),
        ),
        RadioListTile<ThemeMode>(
          title: const Text('ライトモード'),
          value: ThemeMode.light,
          groupValue: current,
          onChanged: (v) =>
              ref.read(themeModeProvider.notifier).state = v!,
          secondary: const Icon(Icons.light_mode),
        ),
        RadioListTile<ThemeMode>(
          title: const Text('ダークモード'),
          value: ThemeMode.dark,
          groupValue: current,
          onChanged: (v) =>
              ref.read(themeModeProvider.notifier).state = v!,
          secondary: const Icon(Icons.dark_mode),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 通知設定セクション
// ---------------------------------------------------------------------------

class _NotificationSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(savingReminderEnabledProvider);
    final hour = ref.watch(savingReminderHourProvider);
    final minute = ref.watch(savingReminderMinuteProvider);

    return Column(
      children: [
        SwitchListTile(
          title: const Text('貯金リマインダー'),
          subtitle: const Text('毎日指定時刻に貯金を促す通知を送る'),
          value: enabled,
          onChanged: kIsWeb
              ? null // Web は OS スケジュール通知非対応
              : (v) async {
                  ref.read(savingReminderEnabledProvider.notifier).state = v;
                  if (v) {
                    await NotificationService.instance
                        .scheduleDailySavingReminder(hour, minute);
                  } else {
                    await NotificationService.instance.cancelAll();
                  }
                },
          secondary: const Icon(Icons.savings),
        ),
        if (kIsWeb)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              'Web ではスケジュール通知は非対応です。',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey),
            ),
          ),
        if (enabled && !kIsWeb)
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('リマインダー時刻'),
            subtitle: Text(
                '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}'),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(hour: hour, minute: minute),
              );
              if (picked != null) {
                ref.read(savingReminderHourProvider.notifier).state =
                    picked.hour;
                ref.read(savingReminderMinuteProvider.notifier).state =
                    picked.minute;
                if (enabled) {
                  await NotificationService.instance
                      .scheduleDailySavingReminder(
                          picked.hour, picked.minute);
                }
              }
            },
          ),
        ListTile(
          leading: const Icon(Icons.notifications_active),
          title: const Text('テスト通知を送る'),
          subtitle: const Text('貯金リマインダーをすぐ表示する'),
          onTap: () async {
            if (kIsWeb) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('💰 今日の貯金はお済みですか？'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else {
              await NotificationService.instance.showSavingReminder();
            }
          },
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// データエクスポートセクション
// ---------------------------------------------------------------------------

class _ExportSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.read(databaseProvider);
    final exportService = ExportService(db);

    return Column(
      children: [
        _ExportTile(
          icon: Icons.event_note,
          title: 'イベント履歴を CSV でエクスポート',
          subtitle: '参加イベント・支出記録を CSV 形式で出力',
          onTap: () async {
            try {
              final csv = await exportService.exportEventsCsv();
              if (context.mounted) {
                await ExportService.downloadOrCopy(
                  context,
                  content: csv,
                  filename: 'oshilog_events.csv',
                  mimeType: 'text/csv',
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('エクスポート失敗: $e')),
                );
              }
            }
          },
        ),
        _ExportTile(
          icon: Icons.shopping_bag,
          title: 'グッズ履歴を CSV でエクスポート',
          subtitle: 'グッズ購入記録を CSV 形式で出力',
          onTap: () async {
            try {
              final csv = await exportService.exportGoodsCsv();
              if (context.mounted) {
                await ExportService.downloadOrCopy(
                  context,
                  content: csv,
                  filename: 'oshilog_goods.csv',
                  mimeType: 'text/csv',
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('エクスポート失敗: $e')),
                );
              }
            }
          },
        ),
        _ExportTile(
          icon: Icons.savings,
          title: '貯金記録を CSV でエクスポート',
          subtitle: '貯金チェックイン記録を CSV 形式で出力',
          onTap: () async {
            try {
              final csv = await exportService.exportSavingsCsv();
              if (context.mounted) {
                await ExportService.downloadOrCopy(
                  context,
                  content: csv,
                  filename: 'oshilog_savings.csv',
                  mimeType: 'text/csv',
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('エクスポート失敗: $e')),
                );
              }
            }
          },
        ),
        _ExportTile(
          icon: Icons.backup,
          title: '全データを JSON でエクスポート',
          subtitle: 'すべてのデータをバックアップ用に JSON 形式で出力',
          onTap: () async {
            try {
              final json = await exportService.exportAllJson();
              if (context.mounted) {
                await ExportService.downloadOrCopy(
                  context,
                  content: json,
                  filename: 'oshilog_backup.json',
                  mimeType: 'application/json',
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('エクスポート失敗: $e')),
                );
              }
            }
          },
        ),
      ],
    );
  }
}

class _ExportTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ExportTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.download),
      onTap: onTap,
    );
  }
}

// ---------------------------------------------------------------------------
// アプリ情報セクション
// ---------------------------------------------------------------------------

class _AppInfoSection extends StatelessWidget {
  const _AppInfoSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('バージョン'),
          trailing: const Text('1.0.0'),
        ),
        ListTile(
          leading: const Icon(Icons.favorite_outline),
          title: const Text('推しログについて'),
          subtitle: const Text('推し活専用の活動記録・家計簿アプリ'),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// セクションヘッダー
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
