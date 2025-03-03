import 'package:flutter/material.dart';

class BottomBarContainerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Size(width, height) = width, height;
    final width = size.width;
    final height = size.height;
    Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(height, 0)
      ..lineTo(height, width)
      ..lineTo(0, width) ;

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
