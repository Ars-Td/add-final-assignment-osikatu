import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/utils/format_utils.dart';
import '../../../shared/widgets/oshi_icon.dart';
import '../summary_providers.dart';
import '../summary_repository.dart';

class SummaryPage extends ConsumerWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('支出サマリー'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '月次'),
              Tab(text: '年次'),
              Tab(text: '推しごと'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _MonthlyTab(),
            _YearlyTab(),
            _OshiTab(),
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
    final categoryAsync = ref.watch(monthlyCategoryProvider);

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

        // カテゴリ別棒グラフ（イベント費・グッズ費）
        categoryAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('エラー: $e'),
          data: (categories) {
            final hasData = categories.any((c) => c.amount > 0);
            if (!hasData) return const SizedBox.shrink();
            return _CategoryBarSection(categories: categories);
          },
        ),
        const SizedBox(height: 24),

        // 推しごと内訳（円グラフ）
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

// ---------------------------------------------------------------------------
// カテゴリ別棒グラフ（イベント費・グッズ費）
// ---------------------------------------------------------------------------

class _CategoryBarSection extends StatelessWidget {
  final List<CategoryAmount> categories;
  const _CategoryBarSection({required this.categories});

  // カテゴリごとの色
  static const _colors = [
    Color(0xFF5C6BC0), // イベント費: インディゴ
    Color(0xFF26A69A), // グッズ費: ティール
  ];

  @override
  Widget build(BuildContext context) {
    final maxVal = categories
        .map((c) => c.amount)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
    final effectiveMax = maxVal == 0 ? 1000.0 : maxVal * 1.25;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('カテゴリ別内訳',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),

        SizedBox(
          height: 180,
          child: BarChart(
            BarChartData(
              maxY: effectiveMax,
              barGroups: categories.asMap().entries.map((entry) {
                final i = entry.key;
                final cat = entry.value;
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: cat.amount.toDouble(),
                      color: _colors[i % _colors.length],
                      width: 40,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6)),
                    ),
                  ],
                );
              }).toList(),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      if (i < 0 || i >= categories.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          categories[i].label,
                          style: const TextStyle(fontSize: 11),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 52,
                    getTitlesWidget: (value, meta) {
                      if (value == 0) return const SizedBox.shrink();
                      return Text(
                        '¥${formatAmount(value.toInt())}',
                        style: const TextStyle(fontSize: 9),
                      );
                    },
                  ),
                ),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
              ),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final cat = categories[group.x];
                    return BarTooltipItem(
                      '${cat.label}\n¥${formatAmount(rod.toY.toInt())}',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: true),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // 凡例
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: categories.asMap().entries.map((entry) {
            final i = entry.key;
            final cat = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _colors[i % _colors.length],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(cat.label,
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(width: 4),
                  Text(
                    '¥${formatAmount(cat.amount)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            );
          }).toList(),
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
// 推しごとタブ
// ---------------------------------------------------------------------------

class _OshiTab extends ConsumerWidget {
  const _OshiTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final oshisAsync = ref.watch(allOshisForSummaryProvider);
    final selectedId = ref.watch(selectedOshiIdProvider);
    final year = ref.watch(selectedYearProvider);

    return oshisAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('エラー: $e')),
      data: (oshis) {
        if (oshis.isEmpty) {
          return const _NoDataView(message: '推しが登録されていません');
        }

        // 選択中の推し（初回は先頭）
        final effectiveId = selectedId ?? oshis.first.id;
        final selectedOshi = oshis.firstWhere(
          (o) => o.id == effectiveId,
          orElse: () => oshis.first,
        );
        final color = Color(selectedOshi.coverColor);

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 推しドロップダウン
            // ignore: deprecated_member_use
            DropdownButtonFormField<int>(
              value: effectiveId,
              decoration: const InputDecoration(
                labelText: '推しを選択',
                border: OutlineInputBorder(),
              ),
              items: oshis
                  .map((o) => DropdownMenuItem(
                        value: o.id,
                        child: Row(
                          children: [
                            OshiCircleAvatar(
                              iconPath: o.iconPath,
                              iconData: o.iconData,
                              name: o.name,
                              coverColor: Color(o.coverColor),
                              radius: 14,
                            ),
                            const SizedBox(width: 8),
                            Text(o.name),
                          ],
                        ),
                      ))
                  .toList(),
              onChanged: (id) {
                if (id != null) {
                  ref.read(selectedOshiIdProvider.notifier).state = id;
                }
              },
            ),
            const SizedBox(height: 20),

            // 累計支出
            Consumer(builder: (context, ref, _) {
              final totalAsync =
                  ref.watch(oshiTotalProvider);
              return totalAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text('エラー: $e'),
                data: (total) => _TotalCard(
                  label: '${selectedOshi.name} への累計支出',
                  amount: total ?? 0,
                ),
              );
            }),
            const SizedBox(height: 20),

            // 統計カード
            Consumer(builder: (context, ref, _) {
              final eventCountAsync = ref.watch(oshiEventCountProvider);
              final goodsCountAsync = ref.watch(oshiGoodsCountProvider);
              return Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'イベント参加',
                      valueAsync: eventCountAsync,
                      unit: '回',
                      icon: Icons.event,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'グッズ購入',
                      valueAsync: goodsCountAsync,
                      unit: '点',
                      icon: Icons.shopping_bag,
                      color: color,
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 24),

            // 年セレクター + 月別推移グラフ
            _YearSelector(year: year),
            const SizedBox(height: 12),
            Consumer(builder: (context, ref, _) {
              final monthlyAsync = ref.watch(oshiMonthlyProvider);
              return monthlyAsync.when(
                loading: () => const Center(
                    child: CircularProgressIndicator()),
                error: (e, _) => Text('エラー: $e'),
                data: (monthly) {
                  if (monthly == null) return const SizedBox.shrink();
                  final total =
                      monthly.fold<int>(0, (s, v) => s + v);
                  if (total == 0) {
                    return const _NoDataView(
                        message: 'この年の支出はありません');
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$year年の月別支出推移',
                          style:
                              Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 12),
                      _OshiLineChart(
                          monthly: monthly, color: color),
                    ],
                  );
                },
              );
            }),
          ],
        );
      },
    );
  }
}

/// 統計カード（イベント参加回数・グッズ購入点数）
class _StatCard extends StatelessWidget {
  final String label;
  final AsyncValue<int?> valueAsync;
  final String unit;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.valueAsync,
    required this.unit,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 4),
                Text(label,
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 8),
            valueAsync.when(
              loading: () =>
                  const SizedBox(width: 20, height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2)),
              error: (e, _) => const Text('-'),
              data: (v) => Text(
                '${v ?? 0} $unit',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 推しの月別支出折れ線グラフ
class _OshiLineChart extends StatelessWidget {
  final List<int> monthly;
  final Color color;
  const _OshiLineChart({required this.monthly, required this.color});

  @override
  Widget build(BuildContext context) {
    final maxVal = monthly.reduce((a, b) => a > b ? a : b).toDouble();
    final effectiveMax = maxVal == 0 ? 1000.0 : maxVal * 1.2;

    final spots = monthly.asMap().entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
        .toList();

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          maxY: effectiveMax,
          minY: 0,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: color,
              barWidth: 2.5,
              dotData: FlDotData(
                getDotPainter: (spot, percent, bar, index) =>
                    FlDotCirclePainter(
                  radius: 4,
                  color: color,
                  strokeWidth: 0,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                color: color.withValues(alpha: 0.15),
              ),
            ),
          ],
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
                getTitlesWidget: (value, meta) => Text(
                  '${value.toInt() + 1}月',
                  style: const TextStyle(fontSize: 10),
                ),
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
