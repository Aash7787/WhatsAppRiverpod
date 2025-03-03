import 'package:flutter/material.dart';

class ErrorWid extends StatelessWidget {
  const ErrorWid({super.key, this.error = ''});

  static const route = 'error/wid';

  final String error;

  @override
  Widget build(BuildContext context) {
    return ErrorWidget('Page not found\n$error');
  }
}