import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/database/app_database.dart';
import '../../shared/database/database_provider.dart';
import 'oshi_repository.dart';

/// ソート種別
enum OshiSort { createdAt, name, lastViewed }

/// OshiRepository Provider
final oshiRepositoryProvider = Provider<OshiRepository>((ref) {
  return OshiRepository(ref.watch(databaseProvider));
});

/// ソート状態
final oshiSortProvider = StateProvider<OshiSort>((ref) => OshiSort.createdAt);

/// 推し一覧（ソート反映済み）
final oshiListProvider = FutureProvider<List<Oshi>>((ref) {
  final repo = ref.watch(oshiRepositoryProvider);
  final sort = ref.watch(oshiSortProvider);
  switch (sort) {
    case OshiSort.name:
      return repo.getOshisSortedByName();
    case OshiSort.lastViewed:
      return repo.getOshisSortedByLastViewed();
    case OshiSort.createdAt:
      return repo.getAllOshis();
  }
});

/// 単体取得
final oshiByIdProvider =
    FutureProvider.family<Oshi?, int>((ref, id) async {
  return ref.watch(oshiRepositoryProvider).getOshiById(id);
});
