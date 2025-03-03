import 'package:flutter/material.dart';

class LoadingWid extends StatelessWidget {
  const LoadingWid({super.key});

  static const route = 'loading/wid';

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
