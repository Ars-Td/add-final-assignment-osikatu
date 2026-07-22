import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../main.dart' show themeModeProvider;
import '../../../shared/database/database_provider.dart';
import '../../../shared/notifications/notification_service.dart';
import '../../../shared/services/preferences_service.dart';
import '../export_service.dart';

// ---------------------------------------------------------------------------
// フォントスケール Provider（初期値は main.dart で SharedPreferences から注入）
// ---------------------------------------------------------------------------

/// 選択可能なフォントスケール選択肢
const _fontScaleOptions = [
  _FontScaleOption(scale: 0.85, label: '小', description: 'やや小さめ'),
  _FontScaleOption(scale: 1.0, label: '標準', description: 'デフォルト'),
  _FontScaleOption(scale: 1.15, label: '大', description: 'やや大きめ'),
  _FontScaleOption(scale: 1.3, label: '特大', description: 'さらに大きく'),
];

class _FontScaleOption {
  final double scale;
  final String label;
  final String description;
  const _FontScaleOption(
      {required this.scale,
      required this.label,
      required this.description});
}

final fontScaleProvider = StateProvider<double>((ref) => 1.0);

// ---------------------------------------------------------------------------
// 通知設定 Provider（初期値は main.dart で SharedPreferences から注入）
// ---------------------------------------------------------------------------

final savingReminderEnabledProvider =
    StateProvider<bool>((ref) => false);
final savingReminderHourProvider =
    StateProvider<int>((ref) => 20);
final savingReminderMinuteProvider =
    StateProvider<int>((ref) => 0);

/// 誕生日通知 ON/OFF（初期値は main.dart で注入）
final birthdayNotifEnabledProvider =
    StateProvider<bool>((ref) => true);

/// イベント前日通知 ON/OFF（初期値は main.dart で注入）
final eventReminderEnabledProvider =
    StateProvider<bool>((ref) => true);

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
          _FontSizeSection(),

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
          onChanged: (v) async {
            ref.read(themeModeProvider.notifier).state = v!;
            await PreferencesService.instance.setThemeMode(v.index);
          },
          secondary: const Icon(Icons.brightness_auto),
        ),
        RadioListTile<ThemeMode>(
          title: const Text('ライトモード'),
          value: ThemeMode.light,
          groupValue: current,
          onChanged: (v) async {
            ref.read(themeModeProvider.notifier).state = v!;
            await PreferencesService.instance.setThemeMode(v.index);
          },
          secondary: const Icon(Icons.light_mode),
        ),
        RadioListTile<ThemeMode>(
          title: const Text('ダークモード'),
          value: ThemeMode.dark,
          groupValue: current,
          onChanged: (v) async {
            ref.read(themeModeProvider.notifier).state = v!;
            await PreferencesService.instance.setThemeMode(v.index);
          },
          secondary: const Icon(Icons.dark_mode),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// フォントサイズセクション
// ---------------------------------------------------------------------------

class _FontSizeSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentScale = ref.watch(fontScaleProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // プレビューテキスト
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text(
            'プレビュー: 推しログで記録しよう',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        // SegmentedButton で選択
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: SegmentedButton<double>(
            segments: _fontScaleOptions
                .map(
                  (o) => ButtonSegment<double>(
                    value: o.scale,
                    label: Text(o.label),
                    tooltip: o.description,
                  ),
                )
                .toList(),
            selected: {currentScale},
            onSelectionChanged: (Set<double> selected) async {
              final scale = selected.first;
              ref.read(fontScaleProvider.notifier).state = scale;
              await PreferencesService.instance.setFontScale(scale);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            '現在: ${_fontScaleOptions.firstWhere((o) => (o.scale - currentScale).abs() < 0.01, orElse: () => _fontScaleOptions[1]).description}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
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
                  await PreferencesService.instance.setReminderEnabled(v);
                  if (v) {
                    await NotificationService.instance
                        .scheduleDailySavingReminder(hour, minute);
                  } else {
                    await NotificationService.instance
                        .cancelSavingReminder();
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
                await PreferencesService.instance
                    .setReminderHour(picked.hour);
                await PreferencesService.instance
                    .setReminderMinute(picked.minute);
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

        // --- 誕生日通知 ---
        const Divider(indent: 16, endIndent: 16),
        _BirthdayNotifTile(),

        // --- イベント前日通知 ---
        _EventReminderTile(),
      ],
    );
  }
}

class _BirthdayNotifTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(birthdayNotifEnabledProvider);
    return SwitchListTile(
      title: const Text('推しの誕生日通知'),
      subtitle: Text(kIsWeb
          ? '起動時に誕生日バナーを表示する'
          : '誕生日当日の朝 8:00 にお知らせ'),
      value: enabled,
      secondary: const Icon(Icons.cake),
      onChanged: (v) async {
        ref.read(birthdayNotifEnabledProvider.notifier).state = v;
        await PreferencesService.instance.setBirthdayNotifEnabled(v);
        // ネイティブ: OFF にしたら誕生日通知のみ個別にキャンセル
        if (!kIsWeb && !v) {
          final db = ref.read(databaseProvider);
          final oshis = await (db.select(db.oshis)
                ..where((t) => t.birthday.isNotNull()))
              .get();
          for (final oshi in oshis) {
            await NotificationService.instance
                .cancelBirthdayNotification(oshi.id);
          }
        }
      },
    );
  }
}

class _EventReminderTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(eventReminderEnabledProvider);
    return SwitchListTile(
      title: const Text('イベント前日リマインド'),
      subtitle: Text(kIsWeb
          ? '起動時にイベント前日バナーを表示する'
          : 'イベント前日の夜 20:00 にお知らせ'),
      value: enabled,
      secondary: const Icon(Icons.event),
      onChanged: (v) async {
        ref.read(eventReminderEnabledProvider.notifier).state = v;
        await PreferencesService.instance.setEventReminderEnabled(v);
      },
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
        ListTile(
          leading: const Icon(Icons.description_outlined),
          title: const Text('ライセンス'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => showLicensePage(
            context: context,
            applicationName: '推しログ',
            applicationVersion: '1.0.0',
            applicationLegalese: '© 2026 Oshi Log',
          ),
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
