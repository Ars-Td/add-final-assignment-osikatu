import 'package:flutter/material.dart';

class GoodsFormPage extends StatelessWidget {
  final int oshiId;
  final int? goodsId; // null = 新規
  const GoodsFormPage({super.key, required this.oshiId, this.goodsId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(goodsId == null ? 'グッズを追加' : 'グッズを編集')),
      body: const Center(child: Text('グッズ登録・編集フォーム')),
    );
  }
}
