import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/database/app_database.dart';
import '../../../shared/utils/format_utils.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../event_providers.dart';

/// OshiDetailPage のイベントタブ
/// - リスト / カレンダー 表示切り替え
/// - 新しい順 / 古い順 ソート
/// - 月フィルタ
class EventListTab extends ConsumerWidget {
  final int oshiId;
  const EventListTab({super.key, required this.oshiId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(eventViewModeProvider(oshiId));
    final sort = ref.watch(eventSortProvider(oshiId));
    final filter = ref.watch(eventMonthFilterProvider(oshiId));
    final eventsAsync = ref.watch(eventListProvider(oshiId));

    return Column(
      children: [
        // ---- ツールバー ----
        _EventToolbar(oshiId: oshiId, viewMode: viewMode, sort: sort, filter: filter),
        const Divider(height: 1),

        // ---- コンテンツ ----
        Expanded(
          child: eventsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('エラー: $e')),
            data: (events) {
              if (events.isEmpty && !filter.isActive) {
                return EmptyStateView(
                  icon: Icons.event_note,
                  message: 'イベントはまだありません',
                  actionLabel: 'イベントを追加',
                  onAction: () =>
                      context.push('/oshi/$oshiId/event/new'),
                );
              }
              if (events.isEmpty) {
                return const EmptyStateView(
                  icon: Icons.event_busy,
                  message: 'この月のイベントはありません',
                );
              }

              if (viewMode == EventViewMode.calendar) {
                return _CalendarView(
                  oshiId: oshiId,
                  events: events,
                  filter: filter,
                );
              }
              return _ListView(oshiId: oshiId, events: events);
            },
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// ツールバー
// ---------------------------------------------------------------------------

class _EventToolbar extends ConsumerWidget {
  final int oshiId;
  final EventViewMode viewMode;
  final EventSort sort;
  final EventMonthFilter filter;

  const _EventToolbar({
    required this.oshiId,
    required this.viewMode,
    required this.sort,
    required this.filter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          // 月フィルタ
          _MonthFilterChip(oshiId: oshiId, filter: filter),
          const Spacer(),

          // ソートボタン（リスト時のみ）
          if (viewMode == EventViewMode.list)
            PopupMenuButton<EventSort>(
              icon: Icon(
                Icons.sort,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              tooltip: '並び替え',
              initialValue: sort,
              onSelected: (v) =>
                  ref.read(eventSortProvider(oshiId).notifier).state = v,
              itemBuilder: (_) => const [
                PopupMenuItem(
                    value: EventSort.newerFirst, child: Text('新しい順')),
                PopupMenuItem(
                    value: EventSort.olderFirst, child: Text('古い順')),
              ],
            ),

          // リスト/カレンダー切り替え
          IconButton(
            icon: Icon(
              viewMode == EventViewMode.list
                  ? Icons.calendar_month
                  : Icons.list,
              size: 20,
            ),
            tooltip: viewMode == EventViewMode.list
                ? 'カレンダー表示'
                : 'リスト表示',
            onPressed: () {
              final next = viewMode == EventViewMode.list
                  ? EventViewMode.calendar
                  : EventViewMode.list;
              ref.read(eventViewModeProvider(oshiId).notifier).state = next;

              // カレンダーへ切り替えたとき、フィルタが未設定なら当月にセット
              if (next == EventViewMode.calendar && !filter.isActive) {
                ref
                    .read(eventMonthFilterProvider(oshiId).notifier)
                    .state = EventMonthFilter(
                        year: now.year, month: now.month);
              }
            },
          ),

          // イベント追加FAB代替ボタン
          IconButton(
            icon: const Icon(Icons.add, size: 20),
            tooltip: 'イベントを追加',
            onPressed: () =>
                context.push('/oshi/$oshiId/event/new'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 月フィルタチップ
// ---------------------------------------------------------------------------

class _MonthFilterChip extends ConsumerWidget {
  final int oshiId;
  final EventMonthFilter filter;
  const _MonthFilterChip({required this.oshiId, required this.filter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _showMonthPicker(context, ref),
      child: Chip(
        avatar: Icon(
          filter.isActive ? Icons.filter_alt : Icons.filter_alt_off,
          size: 16,
          color: filter.isActive
              ? Theme.of(context).colorScheme.primary
              : Colors.grey,
        ),
        label: Text(
          filter.isActive
              ? '${filter.year}年${filter.month}月'
              : '全期間',
          style: TextStyle(
            fontSize: 12,
            color: filter.isActive
                ? Theme.of(context).colorScheme.primary
                : null,
          ),
        ),
        deleteIcon: filter.isActive
            ? const Icon(Icons.close, size: 14)
            : null,
        onDeleted: filter.isActive
            ? () => ref
                .read(eventMonthFilterProvider(oshiId).notifier)
                .state = const EventMonthFilter()
            : null,
      ),
    );
  }

  Future<void> _showMonthPicker(BuildContext context, WidgetRef ref) async {
    final now = DateTime.now();
    final initYear = filter.year ?? now.year;
    final initMonth = filter.month ?? now.month;

    int pickedYear = initYear;
    int pickedMonth = initMonth;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('月を選択'),
          content: SizedBox(
            width: 280,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 年セレクター
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () =>
                          setState(() => pickedYear--),
                    ),
                    Text('$pickedYear年',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () =>
                          setState(() => pickedYear++),
                    ),
                  ],
                ),
                // 月グリッド
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  childAspectRatio: 1.4,
                  children: List.generate(12, (i) {
                    final m = i + 1;
                    final selected = m == pickedMonth;
                    return GestureDetector(
                      onTap: () => setState(() => pickedMonth = m),
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: selected
                              ? Theme.of(ctx).colorScheme.primary
                              : null,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: selected
                                ? Theme.of(ctx).colorScheme.primary
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '$m月',
                            style: TextStyle(
                              fontSize: 12,
                              color: selected ? Colors.white : null,
                              fontWeight: selected
                                  ? FontWeight.bold
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('決定'),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      ref.read(eventMonthFilterProvider(oshiId).notifier).state =
          EventMonthFilter(year: pickedYear, month: pickedMonth);
    }
  }
}

// ---------------------------------------------------------------------------
// リストビュー
// ---------------------------------------------------------------------------

class _ListView extends StatelessWidget {
  final int oshiId;
  final List<Event> events;
  const _ListView({required this.oshiId, required this.events});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 80),
      itemCount: events.length,
      itemBuilder: (context, i) => _EventCard(
        oshiId: oshiId,
        event: events[i],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// カレンダービュー
// ---------------------------------------------------------------------------

class _CalendarView extends ConsumerStatefulWidget {
  final int oshiId;
  final List<Event> events;
  final EventMonthFilter filter;
  const _CalendarView({
    required this.oshiId,
    required this.events,
    required this.filter,
  });

  @override
  ConsumerState<_CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends ConsumerState<_CalendarView> {
  String? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final year = widget.filter.year ?? DateTime.now().year;
    final month = widget.filter.month ?? DateTime.now().month;

    // イベントがある日付のSet
    final eventDates = <String>{};
    final eventsByDate = <String, List<Event>>{};
    for (final e in widget.events) {
      final d = e.date.length >= 10 ? e.date.substring(0, 10) : e.date;
      eventDates.add(d);
      eventsByDate.putIfAbsent(d, () => []).add(e);
    }

    final selectedEvents =
        _selectedDate != null ? (eventsByDate[_selectedDate] ?? []) : [];

    return Column(
      children: [
        // カレンダーグリッド
        _CalendarGrid(
          year: year,
          month: month,
          eventDates: eventDates,
          selectedDate: _selectedDate,
          onDateTap: (date) =>
              setState(() => _selectedDate = date == _selectedDate ? null : date),
          onPrevMonth: () => _shiftMonth(ref, year, month, -1),
          onNextMonth: () => _shiftMonth(ref, year, month, 1),
        ),
        const Divider(height: 1),

        // 選択日のイベント一覧
        Expanded(
          child: selectedEvents.isEmpty
              ? Center(
                  child: Text(
                    _selectedDate == null
                        ? '日付をタップするとイベントが表示されます'
                        : 'この日のイベントはありません',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                  itemCount: selectedEvents.length,
                  itemBuilder: (context, i) => _EventCard(
                    oshiId: widget.oshiId,
                    event: selectedEvents[i],
                  ),
                ),
        ),
      ],
    );
  }

  void _shiftMonth(WidgetRef ref, int year, int month, int delta) {
    int newMonth = month + delta;
    int newYear = year;
    if (newMonth < 1) {
      newMonth = 12;
      newYear--;
    } else if (newMonth > 12) {
      newMonth = 1;
      newYear++;
    }
    ref.read(eventMonthFilterProvider(widget.oshiId).notifier).state =
        EventMonthFilter(year: newYear, month: newMonth);
    setState(() => _selectedDate = null);
  }
}

class _CalendarGrid extends StatelessWidget {
  final int year;
  final int month;
  final Set<String> eventDates;
  final String? selectedDate;
  final void Function(String) onDateTap;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;

  const _CalendarGrid({
    required this.year,
    required this.month,
    required this.eventDates,
    required this.selectedDate,
    required this.onDateTap,
    required this.onPrevMonth,
    required this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    final firstWeekday = DateTime(year, month, 1).weekday % 7; // 0=日
    final primary = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // ヘッダー
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: const Icon(Icons.chevron_left, size: 20),
                  onPressed: onPrevMonth),
              Text('$year年$month月',
                  style: Theme.of(context).textTheme.titleMedium),
              IconButton(
                  icon: const Icon(Icons.chevron_right, size: 20),
                  onPressed: onNextMonth),
            ],
          ),
          // 曜日ヘッダー
          Row(
            children: ['日', '月', '火', '水', '木', '金', '土']
                .map((d) => Expanded(
                      child: Center(
                          child: Text(d,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall)),
                    ))
                .toList(),
          ),
          const SizedBox(height: 4),
          // グリッド
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: firstWeekday + daysInMonth,
            itemBuilder: (context, index) {
              if (index < firstWeekday) return const SizedBox();
              final day = index - firstWeekday + 1;
              final dateStr =
                  '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
              final hasEvent = eventDates.contains(dateStr);
              final isSelected = dateStr == selectedDate;

              return GestureDetector(
                onTap: hasEvent ? () => onDateTap(dateStr) : null,
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primary
                        : hasEvent
                            ? primary.withValues(alpha: 0.15)
                            : null,
                    borderRadius: BorderRadius.circular(6),
                    border: hasEvent && !isSelected
                        ? Border.all(color: primary, width: 1)
                        : null,
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          '$day',
                          style: TextStyle(
                            fontSize: 13,
                            color: isSelected ? Colors.white : null,
                            fontWeight: hasEvent
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (hasEvent && !isSelected)
                        Positioned(
                          bottom: 3,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// イベントカード（リスト・カレンダー共通）
// ---------------------------------------------------------------------------

class _EventCard extends StatelessWidget {
  final int oshiId;
  final Event event;
  const _EventCard({required this.oshiId, required this.event});

  @override
  Widget build(BuildContext context) {
    final dateStr = event.date.length >= 10
        ? event.date.substring(0, 10).replaceAll('-', '/')
        : event.date;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        onTap: () => context.push('/oshi/$oshiId/event/${event.id}'),
        leading: CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.primaryContainer,
          child: Icon(Icons.event,
              color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(event.name),
        subtitle: Text('$dateStr　${event.category}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '¥${formatAmount(event.totalAmount)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.chevron_right, size: 16),
          ],
        ),
      ),
    );
  }
}
