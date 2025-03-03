import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout(
      {super.key,
      required this.mobileScreenLayout,
      required this.webScreenLayout});

  static const routeName = 'responsive_layout';

  final Widget mobileScreenLayout;
  final Widget webScreenLayout;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          // Web
          return webScreenLayout;
        } else {
          // Mobile
          // log('${constraints.maxWidth}', name: routeName);
          // log('${constraints.maxHeight}', name: routeName);
          // log('${constraints.minHeight}', name: routeName);
          // log('${constraints.minHeight}', name: routeName);
          return mobileScreenLayout;
        }
      },
    );
  }
}
