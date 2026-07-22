import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../shared/database/app_database.dart';
import '../../../shared/notifications/notification_service.dart';
import '../../../shared/widgets/app_bar_loading_indicator.dart';
import '../../../shared/widgets/oshi_icon.dart';
import '../oshi_providers.dart';

const _categories = ['アイドル', '俳優', 'VTuber', 'アニメ', 'その他'];

/// members JSON エンコード
String? _encodeMembers(List<String> members) {
  final trimmed = members.map((m) => m.trim()).where((m) => m.isNotEmpty).toList();
  if (trimmed.isEmpty) return null;
  return jsonEncode(trimmed);
}

/// members JSON デコード
List<String> _decodeMembers(String? json) {
  if (json == null || json.isEmpty) return [];
  try {
    final decoded = jsonDecode(json);
    if (decoded is List) return decoded.cast<String>();
  } catch (_) {}
  return [];
}

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

  // グループ関連
  bool _isGroup = false;
  final List<TextEditingController> _memberCtrls = [];

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
    final members = _decodeMembers(oshi.members);
    setState(() {
      _nameCtrl.text = oshi.name;
      _memoCtrl.text = oshi.memo ?? '';
      _coverColor = Color(oshi.coverColor);
      _category = oshi.category;
      _iconPath = oshi.iconPath;
      _isGroup = oshi.isGroup;
      if (oshi.birthday != null) {
        _birthday = DateTime.tryParse(oshi.birthday!);
      }
      // メンバーコントローラを復元
      for (final ctrl in _memberCtrls) {
        ctrl.dispose();
      }
      _memberCtrls.clear();
      for (final name in members) {
        _memberCtrls.add(TextEditingController(text: name));
      }
      // 空欄がなければ入力欄を1つ追加
      if (_isGroup && _memberCtrls.isEmpty) {
        _memberCtrls.add(TextEditingController());
      }
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _memoCtrl.dispose();
    for (final ctrl in _memberCtrls) {
      ctrl.dispose();
    }
    super.dispose();
  }

  void _toggleGroup(bool value) {
    setState(() {
      _isGroup = value;
      if (value && _memberCtrls.isEmpty) {
        _memberCtrls.add(TextEditingController());
      }
    });
  }

  void _addMember() {
    setState(() => _memberCtrls.add(TextEditingController()));
  }

  void _removeMember(int index) {
    setState(() {
      _memberCtrls[index].dispose();
      _memberCtrls.removeAt(index);
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(source: source, imageQuality: 80);
    if (xfile != null) setState(() => _iconPath = xfile.path);
  }

  Future<void> _pickColor() async {
    final result = await showDialog<Color>(
      context: context,
      builder: (ctx) => _ColorPickerDialog(initialColor: _coverColor),
    );
    if (result != null && mounted) {
      setState(() => _coverColor = result);
    }
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
    final membersJson = _isGroup
        ? _encodeMembers(_memberCtrls.map((c) => c.text).toList())
        : null;

    try {
      int savedId;
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
          isGroup: Value(_isGroup),
          members: Value(membersJson),
        ));
        savedId = widget.oshiId!;
      } else {
        savedId = await repo.insertOshi(OshisCompanion.insert(
          name: _nameCtrl.text.trim(),
          coverColor: _coverColor.toARGB32(),
          category: _category,
          memo: Value(_memoCtrl.text.trim().isEmpty
              ? null
              : _memoCtrl.text.trim()),
          birthday: Value(_birthday?.toIso8601String()),
          iconPath: Value(_iconPath),
          isGroup: Value(_isGroup),
          members: Value(membersJson),
          createdAt: now,
        ));
      }

      // 誕生日通知のスケジュール更新（ネイティブのみ）
      if (!kIsWeb) {
        final notif = NotificationService.instance;
        if (_birthday != null) {
          await notif.scheduleBirthdayNotification(
              savedId, _nameCtrl.text.trim(), _birthday!);
        } else {
          await notif.cancelBirthdayNotification(savedId);
        }
      }

      if (mounted) {
        // 一覧を最新状態に更新してからページを閉じる
        ref.invalidate(oshiListProvider);
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
            // アイコン画像
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: _coverColor.withValues(alpha: 0.2),
                    backgroundImage: buildOshiIconImage(_iconPath),
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

            // グループ / 個人 切り替え
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('グループとして登録'),
              subtitle: const Text('複数メンバーをまとめて管理する'),
              secondary: Icon(
                _isGroup ? Icons.group : Icons.person,
                color: Theme.of(context).colorScheme.primary,
              ),
              value: _isGroup,
              onChanged: _toggleGroup,
            ),
            const Divider(),

            // 名前（グループ名 or 個人名）
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: _isGroup ? 'グループ名 *' : '名前 *',
                border: const OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? '名前を入力してください' : null,
            ),
            const SizedBox(height: 16),

            // メンバー入力（グループ時のみ）
            if (_isGroup) ...[
              Row(
                children: [
                  Text(
                    'メンバー',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: _addMember,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('追加'),
                  ),
                ],
              ),
              ..._memberCtrls.asMap().entries.map((entry) {
                final i = entry.key;
                final ctrl = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: ctrl,
                          decoration: InputDecoration(
                            labelText: 'メンバー ${i + 1}',
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline,
                            color: Colors.red),
                        onPressed: _memberCtrls.length > 1
                            ? () => _removeMember(i)
                            : null,
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 8),
              const Divider(),
            ],

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

            // 誕生日（個人のみ表示 / グループ時は非表示）
            if (!_isGroup) ...[
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
            ],

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
}

/// カラーピッカーダイアログ（独立した StatefulWidget）
/// 親ウィジェットの setState を呼ばずにダイアログ内だけで状態管理する
class _ColorPickerDialog extends StatefulWidget {
  final Color initialColor;
  const _ColorPickerDialog({required this.initialColor});

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late Color _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('カバーカラーを選択'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: _current,
          onColorChanged: (c) => setState(() => _current = c),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(_current),
          child: const Text('決定'),
        ),
      ],
    );
  }
}
