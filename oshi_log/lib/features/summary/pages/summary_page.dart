import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/utils/format_utils.dart';
import '../summary_providers.dart';
import '../summary_repository.dart';

class SummaryPage extends ConsumerWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('支出サマリー'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '月次'),
              Tab(text: '年次'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _MonthlyTab(),
            _YearlyTab(),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 月次タブ
// ---------------------------------------------------------------------------

class _MonthlyTab extends ConsumerWidget {
  const _MonthlyTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final year = ref.watch(selectedYearProvider);
    final month = ref.watch(selectedMonthProvider);
    final totalAsync = ref.watch(monthlyTotalProvider);
    final byOshiAsync = ref.watch(monthlyByOshiProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 年月セレクター
        _MonthSelector(year: year, month: month),
        const SizedBox(height: 16),

        // 総支出カード
        totalAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('エラー: $e'),
          data: (total) => _TotalCard(
            label: '$year年$month月の支出',
            amount: total,
          ),
        ),
        const SizedBox(height: 24),

        // 推しごと内訳
        byOshiAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('エラー: $e'),
          data: (list) {
            if (list.isEmpty) {
              return const _NoDataView(message: 'この月の支出はありません');
            }
            return _OshiPieSection(items: list);
          },
        ),
      ],
    );
  }
}

class _MonthSelector extends ConsumerWidget {
  final int year;
  final int month;
  const _MonthSelector({required this.year, required this.month});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            if (month == 1) {
              ref.read(selectedYearProvider.notifier).state = year - 1;
              ref.read(selectedMonthProvider.notifier).state = 12;
            } else {
              ref.read(selectedMonthProvider.notifier).state = month - 1;
            }
          },
        ),
        Text(
          '$year年$month月',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            if (month == 12) {
              ref.read(selectedYearProvider.notifier).state = year + 1;
              ref.read(selectedMonthProvider.notifier).state = 1;
            } else {
              ref.read(selectedMonthProvider.notifier).state = month + 1;
            }
          },
        ),
      ],
    );
  }
}

class _OshiPieSection extends StatefulWidget {
  final List<OshiAmount> items;
  const _OshiPieSection({required this.items});

  @override
  State<_OshiPieSection> createState() => _OshiPieSectionState();
}

class _OshiPieSectionState extends State<_OshiPieSection> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final total =
        widget.items.fold<int>(0, (sum, i) => sum + i.amount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('推しごと内訳',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),

        // 円グラフ
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        response == null ||
                        response.touchedSection == null) {
                      _touchedIndex = -1;
                      return;
                    }
                    _touchedIndex =
                        response.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              sections: widget.items.asMap().entries.map((entry) {
                final i = entry.key;
                final item = entry.value;
                final isTouched = i == _touchedIndex;
                final radius = isTouched ? 70.0 : 58.0;
                final pct = total > 0
                    ? (item.amount / total * 100).toStringAsFixed(1)
                    : '0.0';
                return PieChartSectionData(
                  color: Color(item.coverColor),
                  value: item.amount.toDouble(),
                  title: '$pct%',
                  radius: radius,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 凡例
        ...widget.items.map((item) {
          final pct = total > 0
              ? (item.amount / total * 100).toStringAsFixed(1)
              : '0.0';
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Color(item.coverColor),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(item.oshiName)),
                Text('¥${formatAmount(item.amount)}'),
                const SizedBox(width: 8),
                SizedBox(
                  width: 44,
                  child: Text(
                    '$pct%',
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 年次タブ
// ---------------------------------------------------------------------------

class _YearlyTab extends ConsumerWidget {
  const _YearlyTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final year = ref.watch(selectedYearProvider);
    final yearlyAsync = ref.watch(yearlyMonthlyProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 年セレクター
        _YearSelector(year: year),
        const SizedBox(height: 16),

        yearlyAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('エラー: $e'),
          data: (monthly) {
            final yearTotal =
                monthly.fold<int>(0, (sum, v) => sum + v);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 年間総支出
                _TotalCard(
                  label: '$year年の年間支出',
                  amount: yearTotal,
                ),
                const SizedBox(height: 24),

                if (yearTotal == 0)
                  const _NoDataView(message: 'この年の支出はありません')
                else ...[
                  Text('月別支出推移',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  _YearlyBarChart(monthly: monthly),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _YearSelector extends ConsumerWidget {
  final int year;
  const _YearSelector({required this.year});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () =>
              ref.read(selectedYearProvider.notifier).state = year - 1,
        ),
        Text('$year年', style: Theme.of(context).textTheme.titleLarge),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () =>
              ref.read(selectedYearProvider.notifier).state = year + 1,
        ),
      ],
    );
  }
}

class _YearlyBarChart extends StatelessWidget {
  final List<int> monthly; // 12要素
  const _YearlyBarChart({required this.monthly});

  @override
  Widget build(BuildContext context) {
    final maxVal =
        monthly.reduce((a, b) => a > b ? a : b).toDouble();
    final effectiveMax = maxVal == 0 ? 1000.0 : maxVal * 1.2;

    return SizedBox(
      height: 220,
      child: BarChart(
        BarChartData(
          maxY: effectiveMax,
          barGroups: monthly.asMap().entries.map((entry) {
            final m = entry.key; // 0-indexed
            final val = entry.value.toDouble();
            return BarChartGroupData(
              x: m,
              barRods: [
                BarChartRodData(
                  toY: val,
                  color: Theme.of(context).colorScheme.primary,
                  width: 14,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 48,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const SizedBox.shrink();
                  return Text(
                    '¥${formatAmount(value.toInt())}',
                    style: const TextStyle(fontSize: 9),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt() + 1}月',
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: true),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 共通ウィジェット
// ---------------------------------------------------------------------------

class _TotalCard extends StatelessWidget {
  final String label;
  final int amount;
  const _TotalCard({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(
              '¥${formatAmount(amount)}',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoDataView extends StatelessWidget {
  final String message;
  const _NoDataView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bar_chart,
              size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(message,
              style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}
