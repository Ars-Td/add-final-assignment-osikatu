import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/database/app_database.dart';
import '../../../shared/utils/format_utils.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../saving_providers.dart';

/// OshiDetailPage の貯金タブ
class SavingListTab extends ConsumerWidget {
  final int oshiId;
  const SavingListTab({super.key, required this.oshiId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsync = ref.watch(planListProvider(oshiId));

    return plansAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('エラー: $e')),
      data: (plans) {
        if (plans.isEmpty) {
          return EmptyStateView(
            icon: Icons.savings_outlined,
            message: '貯金プランはまだありません',
            actionLabel: '貯金プランを追加',
            onAction: () => context.push('/oshi/$oshiId/saving/new'),
          );
        }

        return Stack(
          children: [
            ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
              itemCount: plans.length,
              itemBuilder: (context, i) {
                final plan = plans[i];
                return _PlanCard(oshiId: oshiId, plan: plan);
              },
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: FloatingActionButton(
                heroTag: 'saving_list_tab_fab',
                onPressed: () => context.push('/oshi/$oshiId/saving/new'),
                child: const Icon(Icons.add),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PlanCard extends ConsumerWidget {
  final int oshiId;
  final SavingPlan plan;
  const _PlanCard({required this.oshiId, required this.plan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalAsync = ref.watch(totalAmountProvider(plan.id));
    final streakAsync = ref.watch(streakProvider(plan.id));

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: () =>
            context.push('/oshi/$oshiId/saving/${plan.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // プラン名 + ストリーク
              Row(
                children: [
                  const Icon(Icons.savings, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      plan.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  streakAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (e, _) => const SizedBox.shrink(),
                    data: (streak) => streak > 0
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.local_fire_department,
                                  color: Colors.orange, size: 16),
                              Text('$streak日',
                                  style: const TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold)),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // 累計額 + 進捗
              totalAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => const SizedBox.shrink(),
                data: (total) {
                  final goal = plan.goalAmount;
                  final progress = goal != null && goal > 0
                      ? (total / goal).clamp(0.0, 1.0)
                      : null;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('¥${formatAmount(total)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                  )),
                          if (goal != null) ...[
                            Text(
                              ' / ¥${formatAmount(goal)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ],
                      ),
                      if (progress != null) ...[
                        const SizedBox(height: 6),
                        LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 4),
              Text('1日 ¥${formatAmount(plan.dailyAmount)}',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
