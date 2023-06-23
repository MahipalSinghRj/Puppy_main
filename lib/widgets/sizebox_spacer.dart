import 'package:flutter/material.dart';

class Space extends StatelessWidget {
  final double size;

  const Space({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
    );
  }
}

spacer(double size) {
  return SizedBox(
    height: size,
    width: size,
  );
}
