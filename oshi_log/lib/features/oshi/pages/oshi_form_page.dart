import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../shared/database/app_database.dart';
import '../oshi_providers.dart';

const _categories = ['アイドル', '俳優', 'VTuber', 'アニメ', 'その他'];

class OshiFormPage extends ConsumerStatefulWidget {
  final int? oshiId;
  const OshiFormPage({super.key, this.oshiId});

  @override
  ConsumerState<OshiFormPage> createState() => _OshiFormPageState();
}

class _OshiFormPageState extends ConsumerState<OshiFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _memoCtrl = TextEditingController();

  Color _coverColor = const Color(0xFFE91E8C);
  String _category = _categories[0];
  DateTime? _birthday;
  String? _iconPath;
  bool _loading = false;

  bool get _isEdit => widget.oshiId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) _loadExisting();
  }

  Future<void> _loadExisting() async {
    final oshi = await ref
        .read(oshiRepositoryProvider)
        .getOshiById(widget.oshiId!);
    if (oshi == null || !mounted) return;
    setState(() {
      _nameCtrl.text = oshi.name;
      _memoCtrl.text = oshi.memo ?? '';
      _coverColor = Color(oshi.coverColor);
      _category = oshi.category;
      _iconPath = oshi.iconPath;
      if (oshi.birthday != null) {
        _birthday = DateTime.tryParse(oshi.birthday!);
      }
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _memoCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(source: source, imageQuality: 80);
    if (xfile != null) setState(() => _iconPath = xfile.path);
  }

  Future<void> _pickColor() async {
    Color tmp = _coverColor;
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('カバーカラーを選択'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _coverColor,
            onColorChanged: (c) => tmp = c,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _coverColor = tmp);
              Navigator.pop(context);
            },
            child: const Text('決定'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickBirthday() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthday ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _birthday = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final repo = ref.read(oshiRepositoryProvider);
    final now = DateTime.now().toIso8601String();

    try {
      if (_isEdit) {
        await repo.updateOshi(OshisCompanion(
          id: Value(widget.oshiId!),
          name: Value(_nameCtrl.text.trim()),
          coverColor: Value(_coverColor.toARGB32()),
          category: Value(_category),
          memo: Value(_memoCtrl.text.trim().isEmpty
              ? null
              : _memoCtrl.text.trim()),
          birthday: Value(_birthday?.toIso8601String()),
          iconPath: Value(_iconPath),
        ));
      } else {
        await repo.insertOshi(OshisCompanion.insert(
          name: _nameCtrl.text.trim(),
          coverColor: _coverColor.toARGB32(),
          category: _category,
          memo: Value(_memoCtrl.text.trim().isEmpty
              ? null
              : _memoCtrl.text.trim()),
          birthday: Value(_birthday?.toIso8601String()),
          iconPath: Value(_iconPath),
          createdAt: now,
        ));
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
        title: Text(_isEdit ? '推しを編集' : '推しを追加'),
        actions: [
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2)),
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
            // アイコン画像
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: _coverColor.withValues(alpha: 0.2),
                    backgroundImage: _buildIconImage(),
                    child: _iconPath == null
                        ? Icon(Icons.person, size: 48, color: _coverColor)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor:
                          Theme.of(context).colorScheme.primary,
                      child: PopupMenuButton<ImageSource>(
                        icon: const Icon(Icons.camera_alt,
                            size: 16, color: Colors.white),
                        onSelected: _pickImage,
                        itemBuilder: (_) => [
                          const PopupMenuItem(
                            value: ImageSource.gallery,
                            child: Text('ギャラリーから選択'),
                          ),
                          if (!kIsWeb)
                            const PopupMenuItem(
                              value: ImageSource.camera,
                              child: Text('カメラで撮影'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 名前
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: '名前 *',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? '名前を入力してください' : null,
            ),
            const SizedBox(height: 16),

            // カバーカラー
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('カバーカラー'),
              trailing: GestureDetector(
                onTap: _pickColor,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _coverColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey),
                  ),
                ),
              ),
            ),
            const Divider(),

            // カテゴリ
            // ignore: deprecated_member_use
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(
                labelText: 'カテゴリ',
                border: OutlineInputBorder(),
              ),
              items: _categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 16),

            // 誕生日
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('誕生日'),
              subtitle: Text(_birthday == null
                  ? '未設定'
                  : '${_birthday!.year}/${_birthday!.month}/${_birthday!.day}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_birthday != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _birthday = null),
                    ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickBirthday,
                  ),
                ],
              ),
            ),
            const Divider(),

            // メモ
            const SizedBox(height: 8),
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

  ImageProvider? _buildIconImage() {
    if (_iconPath == null) return null;
    if (kIsWeb) return null; // Web では File 非対応
    return FileImage(File(_iconPath!));
  }
}
