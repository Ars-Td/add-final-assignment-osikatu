import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/database/app_database.dart';
import '../../../shared/widgets/app_bar_loading_indicator.dart';
import '../saving_providers.dart';

class SavingPlanFormPage extends ConsumerStatefulWidget {
  final int oshiId;
  final int? planId;
  const SavingPlanFormPage({super.key, required this.oshiId, this.planId});

  @override
  ConsumerState<SavingPlanFormPage> createState() =>
      _SavingPlanFormPageState();
}

class _SavingPlanFormPageState extends ConsumerState<SavingPlanFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _dailyAmountCtrl = TextEditingController();
  final _goalAmountCtrl = TextEditingController();

  DateTime? _startDate;
  DateTime? _goalDate;
  bool _loading = false;

  bool get _isEdit => widget.planId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) _loadExisting();
  }

  Future<void> _loadExisting() async {
    final plan =
        await ref.read(savingRepositoryProvider).getPlanById(widget.planId!);
    if (plan == null || !mounted) return;
    setState(() {
      _nameCtrl.text = plan.name;
      _dailyAmountCtrl.text = plan.dailyAmount.toString();
      _goalAmountCtrl.text =
          plan.goalAmount != null ? plan.goalAmount.toString() : '';
      _startDate = DateTime.tryParse(plan.startDate);
      _goalDate =
          plan.goalDate != null ? DateTime.tryParse(plan.goalDate!) : null;
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dailyAmountCtrl.dispose();
    _goalAmountCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isStart) async {
    final initial = isStart
        ? (_startDate ?? DateTime.now())
        : (_goalDate ?? DateTime.now().add(const Duration(days: 30)));
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _goalDate = picked;
        }
      });
    }
  }

  String _fmtDate(DateTime? dt) {
    if (dt == null) return '未選択';
    return '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('開始日を選択してください')),
      );
      return;
    }

    setState(() => _loading = true);
    final repo = ref.read(savingRepositoryProvider);
    final now = DateTime.now().toIso8601String();
    final dailyAmount =
        int.tryParse(_dailyAmountCtrl.text.trim()) ?? 0;
    final goalAmount = _goalAmountCtrl.text.trim().isEmpty
        ? null
        : int.tryParse(_goalAmountCtrl.text.trim());
    final startStr = _startDate!.toIso8601String().substring(0, 10);
    final goalStr = _goalDate?.toIso8601String().substring(0, 10);

    try {
      if (_isEdit) {
        await repo.updatePlan(SavingPlansCompanion(
          id: Value(widget.planId!),
          oshiId: Value(widget.oshiId),
          name: Value(_nameCtrl.text.trim()),
          startDate: Value(startStr),
          goalDate: Value(goalStr),
          goalAmount: Value(goalAmount),
          dailyAmount: Value(dailyAmount),
        ));
      } else {
        await repo.insertPlan(SavingPlansCompanion.insert(
          oshiId: widget.oshiId,
          name: _nameCtrl.text.trim(),
          startDate: startStr,
          goalDate: Value(goalStr),
          goalAmount: Value(goalAmount),
          dailyAmount: dailyAmount,
          createdAt: now,
        ));
      }
      if (mounted) {
        // 一覧を最新状態に更新してからページを閉じる
        ref.invalidate(planListProvider(widget.oshiId));
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/');
        }
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? '貯金プランを編集' : '貯金プランを追加'),
        actions: [
          if (_loading)
            const AppBarLoadingIndicator()
          else
            TextButton(
              onPressed: _save,
              child: const Text('保存'),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 貯金名
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: '貯金名 *',
                hintText: '例: ○○ちゃん誕生日貯金',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? '貯金名を入力してください' : null,
            ),
            const SizedBox(height: 16),

            // 開始日
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('開始日 *'),
              subtitle: Text(_fmtDate(_startDate)),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _pickDate(true),
              ),
            ),
            const Divider(),

            // 目標日（任意）
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('目標日（任意）'),
              subtitle: Text(_fmtDate(_goalDate)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_goalDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _goalDate = null),
                    ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _pickDate(false),
                  ),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),

            // 1日あたりの基本貯金額
            TextFormField(
              controller: _dailyAmountCtrl,
              decoration: const InputDecoration(
                labelText: '1日あたりの貯金額 *（円）',
                border: OutlineInputBorder(),
                suffixText: '円/日',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) {
                if (v == null || v.trim().isEmpty) return '貯金額を入力してください';
                final n = int.tryParse(v.trim());
                if (n == null || n <= 0) return '1以上の金額を入力してください';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 目標金額（任意）
            TextFormField(
              controller: _goalAmountCtrl,
              decoration: const InputDecoration(
                labelText: '目標金額（任意）',
                border: OutlineInputBorder(),
                suffixText: '円',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
