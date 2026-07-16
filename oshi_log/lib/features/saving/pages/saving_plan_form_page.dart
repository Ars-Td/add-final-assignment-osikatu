import 'package:flutter/material.dart';

class SavingPlanFormPage extends StatelessWidget {
  final int oshiId;
  final int? planId; // null = 新規
  const SavingPlanFormPage({super.key, required this.oshiId, this.planId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(planId == null ? '貯金プランを追加' : '貯金プランを編集')),
      body: const Center(child: Text('貯金プラン登録・編集フォーム')),
    );
  }
}
