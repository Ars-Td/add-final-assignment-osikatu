import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/database/app_database.dart';
import '../../shared/database/database_provider.dart';
import 'event_repository.dart';

/// EventRepository Provider
final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepository(ref.watch(databaseProvider));
});

// --- ソート ---
enum EventSort { newerFirst, olderFirst }

/// ソート状態（推しIDごと）
final eventSortProvider =
    StateProvider.family<EventSort, int>((ref, oshiId) => EventSort.newerFirst);

// --- 月フィルタ ---
/// フィルタ対象年月（null = 全期間）
class EventMonthFilter {
  final int? year;
  final int? month;
  const EventMonthFilter({this.year, this.month});
  bool get isActive => year != null && month != null;
}

final eventMonthFilterProvider =
    StateProvider.family<EventMonthFilter, int>(
        (ref, oshiId) => const EventMonthFilter());

// --- 表示モード ---
enum EventViewMode { list, calendar }

final eventViewModeProvider =
    StateProvider.family<EventViewMode, int>(
        (ref, oshiId) => EventViewMode.list);

// --- イベント一覧（ソート・フィルタ適用済み） ---
final eventListProvider =
    FutureProvider.family<List<Event>, int>((ref, oshiId) async {
  final repo = ref.watch(eventRepositoryProvider);
  final sort = ref.watch(eventSortProvider(oshiId));
  final filter = ref.watch(eventMonthFilterProvider(oshiId));

  List<Event> events;
  if (filter.isActive) {
    events = await repo.getEventsByMonth(oshiId, filter.year!, filter.month!);
    if (sort == EventSort.newerFirst) {
      events = events.reversed.toList();
    }
  } else {
    events = sort == EventSort.newerFirst
        ? await repo.getEventsByOshi(oshiId)
        : await repo.getEventsByOshiOldFirst(oshiId);
  }
  return events;
});

/// イベント単体取得
final eventByIdProvider =
    FutureProvider.family<Event?, int>((ref, eventId) {
  return ref.watch(eventRepositoryProvider).getEventById(eventId);
});

/// イベントの支出内訳一覧
final eventExpensesProvider =
    FutureProvider.family<List<EventExpense>, int>((ref, eventId) {
  return ref.watch(eventRepositoryProvider).getExpensesByEvent(eventId);
});
