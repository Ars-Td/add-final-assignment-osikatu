import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/database/app_database.dart';
import '../../shared/database/database_provider.dart';
import 'event_repository.dart';

/// EventRepository Provider
final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepository(ref.watch(databaseProvider));
});

/// 推しに紐づくイベント一覧（新しい順）
final eventListProvider =
    FutureProvider.family<List<Event>, int>((ref, oshiId) {
  return ref.watch(eventRepositoryProvider).getEventsByOshi(oshiId);
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
