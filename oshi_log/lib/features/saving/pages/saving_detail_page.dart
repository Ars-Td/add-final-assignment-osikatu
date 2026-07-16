import 'package:flutter/material.dart';

class SavingDetailPage extends StatelessWidget {
  final int oshiId;
  final int planId;
  const SavingDetailPage({super.key, required this.oshiId, required this.planId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('貯金詳細')),
      body: Center(child: Text('貯金詳細 planId=$planId')),
    );
  }
}
