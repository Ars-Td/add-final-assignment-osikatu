import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/database/app_database.dart';
import '../../shared/database/database_provider.dart';
import 'goods_repository.dart';

/// GoodsRepository Provider
final goodsRepositoryProvider = Provider<GoodsRepository>((ref) {
  return GoodsRepository(ref.watch(databaseProvider));
});

/// 推しに紐づくグッズ一覧（購入日の新しい順）
final goodsListProvider =
    FutureProvider.family<List<Good>, int>((ref, oshiId) {
  return ref.watch(goodsRepositoryProvider).getGoodsByOshi(oshiId);
});

/// グッズ単体取得
final goodsByIdProvider =
    FutureProvider.family<Good?, int>((ref, goodsId) {
  return ref.watch(goodsRepositoryProvider).getGoodsById(goodsId);
});
