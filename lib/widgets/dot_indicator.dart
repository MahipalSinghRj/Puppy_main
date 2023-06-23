import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  final Color indicate;

  const DotIndicator({Key? key, required this.indicate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
          color: indicate,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: indicate.withOpacity(0.8), width: 4)),
    );
  }
}
