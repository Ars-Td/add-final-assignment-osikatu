import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/database/app_database.dart';
import '../event_providers.dart';

const _eventCategories = ['コンサート', '舞台', '握手会', '配信', 'その他'];
const _expenseLabels = ['チケット代', '交通費', '宿泊費', 'その他'];

/// 内訳行の一時データ
class _ExpenseRow {
  String label;
  final TextEditingController amountCtrl;

  _ExpenseRow({required this.label, int amount = 0})
      : amountCtrl = TextEditingController(
            text: amount == 0 ? '' : amount.toString());

  int get amount => int.tryParse(amountCtrl.text.trim()) ?? 0;

  void dispose() => amountCtrl.dispose();
}

class EventFormPage extends ConsumerStatefulWidget {
  final int oshiId;
  final int? eventId;
  const EventFormPage({super.key, required this.oshiId, this.eventId});

  @override
  ConsumerState<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends ConsumerState<EventFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _venueCtrl = TextEditingController();
  final _memoCtrl = TextEditingController();
  final _totalAmountCtrl = TextEditingController();

  String _category = _eventCategories[0];
  DateTime? _date;
  bool _loading = false;
  bool _useBreakdown = false;
  final List<_ExpenseRow> _expenses = [];

  bool get _isEdit => widget.eventId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) _loadExisting();
  }

  Future<void> _loadExisting() async {
    final repo = ref.read(eventRepositoryProvider);
    final event = await repo.getEventById(widget.eventId!);
    if (event == null || !mounted) return;

    final expenses = await repo.getExpensesByEvent(widget.eventId!);

    setState(() {
      _nameCtrl.text = event.name;
      _venueCtrl.text = event.venue ?? '';
      _memoCtrl.text = event.memo ?? '';
      _totalAmountCtrl.text =
          event.totalAmount == 0 ? '' : event.totalAmount.toString();
      _category = event.category;
      _date = DateTime.tryParse(event.date);

      if (expenses.isNotEmpty) {
        _useBreakdown = true;
        for (final e in expenses) {
          _expenses.add(_ExpenseRow(label: e.label, amount: e.amount));
        }
      }
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _venueCtrl.dispose();
    _memoCtrl.dispose();
    _totalAmountCtrl.dispose();
    for (final e in _expenses) {
      e.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _addExpenseRow() {
    setState(() {
      _expenses.add(_ExpenseRow(label: _expenseLabels[0]));
    });
  }

  void _removeExpenseRow(int index) {
    setState(() {
      _expenses[index].dispose();
      _expenses.removeAt(index);
    });
  }

  /// 内訳合計を totalAmount に反映
  void _syncTotal() {
    if (!_useBreakdown) return;
    final total = _expenses.fold<int>(0, (sum, e) => sum + e.amount);
    _totalAmountCtrl.text = total == 0 ? '' : total.toString();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('日付を選択してください')),
      );
      return;
    }

    setState(() => _loading = true);
    final repo = ref.read(eventRepositoryProvider);

    final totalAmount = int.tryParse(_totalAmountCtrl.text.trim()) ?? 0;
    final now = DateTime.now().toIso8601String();

    try {
      if (_isEdit) {
        await repo.updateEvent(EventsCompanion(
          id: Value(widget.eventId!),
          oshiId: Value(widget.oshiId),
          name: Value(_nameCtrl.text.trim()),
          date: Value(_date!.toIso8601String().substring(0, 10)),
          venue: Value(
              _venueCtrl.text.trim().isEmpty ? null : _venueCtrl.text.trim()),
          category: Value(_category),
          totalAmount: Value(totalAmount),
          memo: Value(
              _memoCtrl.text.trim().isEmpty ? null : _memoCtrl.text.trim()),
        ));
        await repo.deleteExpensesByEvent(widget.eventId!);
        if (_useBreakdown) {
          for (final e in _expenses) {
            if (e.amount > 0) {
              await repo.insertExpense(EventExpensesCompanion.insert(
                eventId: widget.eventId!,
                label: e.label,
                amount: e.amount,
              ));
            }
          }
        }
      } else {
        final eventId = await repo.insertEvent(EventsCompanion.insert(
          oshiId: widget.oshiId,
          name: _nameCtrl.text.trim(),
          date: _date!.toIso8601String().substring(0, 10),
          venue: Value(
              _venueCtrl.text.trim().isEmpty ? null : _venueCtrl.text.trim()),
          category: _category,
          totalAmount: Value(totalAmount),
          memo: Value(
              _memoCtrl.text.trim().isEmpty ? null : _memoCtrl.text.trim()),
          createdAt: now,
        ));
        if (_useBreakdown) {
          for (final e in _expenses) {
            if (e.amount > 0) {
              await repo.insertExpense(EventExpensesCompanion.insert(
                eventId: eventId,
                label: e.label,
                amount: e.amount,
              ));
            }
          }
        }
      }

      if (mounted) {
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
        title: Text(_isEdit ? 'イベントを編集' : 'イベントを追加'),
        actions: [
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
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
            // イベント名
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'イベント名 *',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'イベント名を入力してください' : null,
            ),
            const SizedBox(height: 16),

            // 日付
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('日付 *'),
              subtitle: Text(
                _date == null
                    ? '未選択'
                    : '${_date!.year}/${_date!.month.toString().padLeft(2, '0')}/${_date!.day.toString().padLeft(2, '0')}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: _pickDate,
              ),
            ),
            const Divider(),

            // 場所・会場
            const SizedBox(height: 8),
            TextFormField(
              controller: _venueCtrl,
              decoration: const InputDecoration(
                labelText: '場所・会場',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // カテゴリ
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(
                labelText: 'カテゴリ',
                border: OutlineInputBorder(),
              ),
              items: _eventCategories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 16),

            // 支出金額
            TextFormField(
              controller: _totalAmountCtrl,
              decoration: const InputDecoration(
                labelText: '支出金額（円）',
                border: OutlineInputBorder(),
                suffixText: '円',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              readOnly: _useBreakdown,
            ),
            const SizedBox(height: 8),

            // 内訳スイッチ
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('内訳を入力する'),
              value: _useBreakdown,
              onChanged: (v) {
                setState(() {
                  _useBreakdown = v;
                  if (v && _expenses.isEmpty) _addExpenseRow();
                  if (!v) {
                    for (final e in _expenses) {
                      e.dispose();
                    }
                    _expenses.clear();
                  }
                });
              },
            ),

            if (_useBreakdown) ...[
              const SizedBox(height: 8),
              ..._expenses.asMap().entries.map((entry) {
                final i = entry.key;
                final row = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          value: row.label,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          items: _expenseLabels
                              .map((l) =>
                                  DropdownMenuItem(value: l, child: Text(l)))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => row.label = v!),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: row.amountCtrl,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            suffixText: '円',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (_) => _syncTotal(),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => _removeExpenseRow(i),
                      ),
                    ],
                  ),
                );
              }),
              TextButton.icon(
                onPressed: _addExpenseRow,
                icon: const Icon(Icons.add),
                label: const Text('内訳を追加'),
              ),
            ],

            const SizedBox(height: 16),

            // メモ
            TextFormField(
              controller: _memoCtrl,
              decoration: const InputDecoration(
                labelText: 'メモ',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
