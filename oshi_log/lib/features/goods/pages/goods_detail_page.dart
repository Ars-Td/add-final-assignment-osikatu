import 'package:flutter/material.dart';

class GoodsDetailPage extends StatelessWidget {
  final int oshiId;
  final int goodsId;
  const GoodsDetailPage({super.key, required this.oshiId, required this.goodsId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('グッズ詳細')),
      body: Center(child: Text('グッズ詳細 id=$goodsId')),
    );
  }
}
