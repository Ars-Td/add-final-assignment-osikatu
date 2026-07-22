import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../shared/database/app_database.dart';
import '../../../shared/utils/photo_utils.dart';
import '../../../shared/widgets/app_bar_loading_indicator.dart';
import '../../../shared/widgets/oshi_icon.dart';
import '../goods_providers.dart';

const _goodsCategories = [
  'CD',
  'Blu-ray',
  '写真集',
  'アパレル',
  'アクセサリー',
  '雑貨',
  'その他',
];

class GoodsFormPage extends ConsumerStatefulWidget {
  final int oshiId;
  final int? goodsId;
  const GoodsFormPage({super.key, required this.oshiId, this.goodsId});

  @override
  ConsumerState<GoodsFormPage> createState() => _GoodsFormPageState();
}

class _GoodsFormPageState extends ConsumerState<GoodsFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _shopCtrl = TextEditingController();
  final _memoCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController(text: '1');

  String _category = _goodsCategories[0];
  DateTime? _purchaseDate;
  bool _loading = false;
  final List<String> _photoPaths = [];

  bool get _isEdit => widget.goodsId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) _loadExisting();
  }

  Future<void> _loadExisting() async {
    final goods =
        await ref.read(goodsRepositoryProvider).getGoodsById(widget.goodsId!);
    if (goods == null || !mounted) return;
    setState(() {
      _nameCtrl.text = goods.name;
      _shopCtrl.text = goods.shop ?? '';
      _memoCtrl.text = goods.memo ?? '';
      _amountCtrl.text = goods.amount == 0 ? '' : goods.amount.toString();
      _quantityCtrl.text = goods.quantity.toString();
      _category = goods.category;
      _purchaseDate = DateTime.tryParse(goods.purchaseDate);
      // photoPaths を優先し、なければ旧 imagePath を移行
      final paths = decodePhotoPaths(goods.photoPaths);
      if (paths.isNotEmpty) {
        _photoPaths.addAll(paths);
      } else if (goods.imagePath != null) {
        _photoPaths.add(goods.imagePath!);
      }
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _shopCtrl.dispose();
    _memoCtrl.dispose();
    _amountCtrl.dispose();
    _quantityCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _purchaseDate = picked);
  }

  /// 写真をギャラリーから複数選択
  Future<void> _pickPhotos() async {
    final picker = ImagePicker();
    final files = await picker.pickMultiImage(imageQuality: 80);
    if (files.isNotEmpty) {
      setState(() => _photoPaths.addAll(files.map((f) => f.path)));
    }
  }

  void _removePhoto(int index) => setState(() => _photoPaths.removeAt(index));

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_purchaseDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('購入日を選択してください')),
      );
      return;
    }

    setState(() => _loading = true);
    final repo = ref.read(goodsRepositoryProvider);
    final now = DateTime.now().toIso8601String();
    final amount = int.tryParse(_amountCtrl.text.trim()) ?? 0;
    final quantity = int.tryParse(_quantityCtrl.text.trim()) ?? 1;
    final dateStr = _purchaseDate!.toIso8601String().substring(0, 10);
    final encodedPhotos = encodePhotoPaths(_photoPaths);

    try {
      if (_isEdit) {
        await repo.updateGoods(GoodsCompanion(
          id: Value(widget.goodsId!),
          oshiId: Value(widget.oshiId),
          name: Value(_nameCtrl.text.trim()),
          purchaseDate: Value(dateStr),
          category: Value(_category),
          amount: Value(amount),
          quantity: Value(quantity),
          shop: Value(
              _shopCtrl.text.trim().isEmpty ? null : _shopCtrl.text.trim()),
          memo: Value(
              _memoCtrl.text.trim().isEmpty ? null : _memoCtrl.text.trim()),
          photoPaths: Value(encodedPhotos),
        ));
      } else {
        await repo.insertGoods(GoodsCompanion.insert(
          oshiId: widget.oshiId,
          name: _nameCtrl.text.trim(),
          purchaseDate: dateStr,
          category: _category,
          amount: amount,
          quantity: Value(quantity),
          shop: Value(
              _shopCtrl.text.trim().isEmpty ? null : _shopCtrl.text.trim()),
          memo: Value(
              _memoCtrl.text.trim().isEmpty ? null : _memoCtrl.text.trim()),
          photoPaths: Value(encodedPhotos),
          createdAt: now,
        ));
      }
      if (mounted) {
        // 一覧を最新状態に更新してからページを閉じる
        ref.invalidate(goodsListProvider(widget.oshiId));
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
        title: Text(_isEdit ? 'グッズを編集' : 'グッズを追加'),
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
            // グッズ名
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'グッズ名 *',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'グッズ名を入力してください' : null,
            ),
            const SizedBox(height: 16),

            // 購入日
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('購入日 *'),
              subtitle: Text(
                _purchaseDate == null
                    ? '未選択'
                    : '${_purchaseDate!.year}/${_purchaseDate!.month.toString().padLeft(2, '0')}/${_purchaseDate!.day.toString().padLeft(2, '0')}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: _pickDate,
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),

            // カテゴリ
            // ignore: deprecated_member_use
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(
                labelText: 'カテゴリ',
                border: OutlineInputBorder(),
              ),
              items: _goodsCategories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 16),

            // 金額
            TextFormField(
              controller: _amountCtrl,
              decoration: const InputDecoration(
                labelText: '金額 *（円）',
                border: OutlineInputBorder(),
                suffixText: '円',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? '金額を入力してください' : null,
            ),
            const SizedBox(height: 16),

            // 数量
            TextFormField(
              controller: _quantityCtrl,
              decoration: const InputDecoration(
                labelText: '数量',
                border: OutlineInputBorder(),
                suffixText: '個',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),

            // 購入場所
            TextFormField(
              controller: _shopCtrl,
              decoration: const InputDecoration(
                labelText: '購入場所',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // 写真
            Row(
              children: [
                Text('写真', style: Theme.of(context).textTheme.titleSmall),
                const Spacer(),
                TextButton.icon(
                  onPressed: _pickPhotos,
                  icon: const Icon(Icons.add_a_photo, size: 18),
                  label: const Text('追加'),
                ),
              ],
            ),
            if (_photoPaths.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _photoPaths.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final img = buildOshiIconImage(_photoPaths[i]);
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: img != null
                              ? Image(
                                  image: img,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey.shade200,
                                  child: const Icon(Icons.image,
                                      color: Colors.grey),
                                ),
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: () => _removePhoto(i),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close,
                                  size: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            if (!kIsWeb && _photoPaths.isEmpty)
              Text(
                'ギャラリーから複数選択できます',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey),
              ),
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
