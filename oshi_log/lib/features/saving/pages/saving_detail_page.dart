import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/database/app_database.dart';
import '../../../shared/utils/format_utils.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../saving_providers.dart';

class SavingDetailPage extends ConsumerWidget {
  final int oshiId;
  final int planId;
  const SavingDetailPage(
      {super.key, required this.oshiId, required this.planId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(planByIdProvider(planId));

    return planAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
          appBar: AppBar(), body: Center(child: Text('エラー: $e'))),
      data: (plan) {
        if (plan == null) {
          return Scaffold(
              appBar: AppBar(),
              body: const Center(child: Text('プランが見つかりません')));
        }
        return _PlanBody(oshiId: oshiId, plan: plan);
      },
    );
  }
}

class _PlanBody extends ConsumerStatefulWidget {
  final int oshiId;
  final SavingPlan plan;
  const _PlanBody({required this.oshiId, required this.plan});

  @override
  ConsumerState<_PlanBody> createState() => _PlanBodyState();
}

class _PlanBodyState extends ConsumerState<_PlanBody> {
  late final TextEditingController _amountCtrl;
  int _calendarYear = DateTime.now().year;
  int _calendarMonth = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    _amountCtrl = TextEditingController(
        text: widget.plan.dailyAmount.toString());
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  String get _todayStr {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<void> _checkIn(BuildContext context) async {
    final amount = int.tryParse(_amountCtrl.text.trim()) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('金額を入力してください')),
      );
      return;
    }
    await ref.read(savingRepositoryProvider).checkIn(
          SavingRecordsCompanion.insert(
            planId: widget.plan.id,
            date: _todayStr,
            amount: amount,
            createdAt: DateTime.now().toIso8601String(),
          ),
        );
    // Providers を再取得
    ref.invalidate(recordsProvider(widget.plan.id));
    ref.invalidate(totalAmountProvider(widget.plan.id));
    ref.invalidate(streakProvider(widget.plan.id));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('貯金を記録しました！')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final plan = widget.plan;
    final totalAsync = ref.watch(totalAmountProvider(plan.id));
    final streakAsync = ref.watch(streakProvider(plan.id));
    final recordsAsync = ref.watch(recordsProvider(plan.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(plan.name),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) async {
              if (v == 'edit') {
                context.push('/oshi/${widget.oshiId}/saving/${plan.id}/edit');
              } else if (v == 'delete') {
                final ok = await showConfirmDialog(
                  context: context,
                  title: '貯金プランを削除',
                  content: 'このプランとすべての貯金記録が削除されます。よろしいですか？',
                );
                if (ok == true && context.mounted) {
                  await ref
                      .read(savingRepositoryProvider)
                      .deletePlan(plan.id);
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
          // ---- 進捗セクション ----
          totalAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('エラー: $e'),
            data: (total) {
              final goal = plan.goalAmount;
              final progress =
                  goal != null && goal > 0 ? (total / goal).clamp(0.0, 1.0) : null;
              final achieved = goal != null && total >= goal;

              return Card(
                color: achieved
                    ? Colors.amber.shade50
                    : Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (achieved)
                        const Row(
                          children: [
                            Icon(Icons.celebration, color: Colors.amber),
                            SizedBox(width: 8),
                            Text('目標達成！',
                                style: TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      const SizedBox(height: 4),
                      Text('累計貯金額',
                          style: Theme.of(context).textTheme.bodySmall),
                      Text(
                        '¥${formatAmount(total)}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      if (goal != null) ...[
                        const SizedBox(height: 4),
                        Text('目標: ¥${formatAmount(goal)}',
                            style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${((progress ?? 0) * 100).toStringAsFixed(1)}%',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          // ストリーク
          streakAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (e, _) => const SizedBox.shrink(),
            data: (streak) => Row(
              children: [
                const Icon(Icons.local_fire_department,
                    color: Colors.orange),
                const SizedBox(width: 6),
                Text('連続貯金 $streak 日',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ---- チェックインセクション ----
          recordsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (e, _) => const SizedBox.shrink(),
            data: (records) {
              final alreadyCheckedIn =
                  records.any((r) => r.date == _todayStr);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('今日のチェックイン',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _amountCtrl,
                          decoration: const InputDecoration(
                            labelText: '金額（円）',
                            border: OutlineInputBorder(),
                            suffixText: '円',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          enabled: !alreadyCheckedIn,
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: alreadyCheckedIn
                            ? null
                            : () => _checkIn(context),
                        icon: const Icon(Icons.savings),
                        label: Text(
                            alreadyCheckedIn ? '記録済み' : '今日も貯金した！'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // ---- カレンダーヒートマップ ----
          recordsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (e, _) => const SizedBox.shrink(),
            data: (records) {
              final checkedDates = records.map((r) => r.date).toSet();
              return _CalendarHeatmap(
                year: _calendarYear,
                month: _calendarMonth,
                checkedDates: checkedDates,
                onPrevMonth: () => setState(() {
                  if (_calendarMonth == 1) {
                    _calendarYear--;
                    _calendarMonth = 12;
                  } else {
                    _calendarMonth--;
                  }
                }),
                onNextMonth: () => setState(() {
                  if (_calendarMonth == 12) {
                    _calendarYear++;
                    _calendarMonth = 1;
                  } else {
                    _calendarMonth++;
                  }
                }),
              );
            },
          ),
          const SizedBox(height: 24),

          // ---- 月別合計 ----
          Text('月別合計',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          _MonthlyTotals(planId: plan.id),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// カレンダーヒートマップ
// ---------------------------------------------------------------------------

class _CalendarHeatmap extends StatelessWidget {
  final int year;
  final int month;
  final Set<String> checkedDates;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;

  const _CalendarHeatmap({
    required this.year,
    required this.month,
    required this.checkedDates,
    required this.onPrevMonth,
    required this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    final firstWeekday = DateTime(year, month, 1).weekday % 7; // 0=日
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ヘッダー
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: onPrevMonth),
            Text('$year年$month月',
                style: Theme.of(context).textTheme.titleMedium),
            IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: onNextMonth),
          ],
        ),
        // 曜日ヘッダー
        Row(
          children: ['日', '月', '火', '水', '木', '金', '土']
              .map((d) => Expanded(
                    child: Center(
                      child: Text(d,
                          style: Theme.of(context).textTheme.bodySmall),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 4),
        // カレンダーグリッド
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
          ),
          itemCount: firstWeekday + daysInMonth,
          itemBuilder: (context, index) {
            if (index < firstWeekday) return const SizedBox();
            final day = index - firstWeekday + 1;
            final dateStr =
                '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
            final checked = checkedDates.contains(dateStr);
            return Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: checked ? primary : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 12,
                    color: checked ? Colors.white : Colors.black87,
                    fontWeight:
                        checked ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 月別合計リスト（直近3ヶ月）
// ---------------------------------------------------------------------------

class _MonthlyTotals extends ConsumerWidget {
  final int planId;
  const _MonthlyTotals({required this.planId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(recordsProvider(planId));
    return recordsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const SizedBox.shrink(),
      data: (records) {
        // 月ごとに集計
        final Map<String, int> byMonth = {};
        for (final r in records) {
          if (r.date.length >= 7) {
            final key = r.date.substring(0, 7); // YYYY-MM
            byMonth[key] = (byMonth[key] ?? 0) + r.amount;
          }
        }
        final sorted = byMonth.entries.toList()
          ..sort((a, b) => b.key.compareTo(a.key));
        final recent = sorted.take(6).toList();

        if (recent.isEmpty) {
          return const Text('まだ記録がありません',
              style: TextStyle(color: Colors.grey));
        }
        return Column(
          children: recent.map((entry) {
            final parts = entry.key.split('-');
            final label =
                parts.length == 2 ? '${parts[0]}年${int.parse(parts[1])}月' : entry.key;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(label),
              trailing: Text('¥${formatAmount(entry.value)}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            );
          }).toList(),
        );
      },
    );
  }
}
