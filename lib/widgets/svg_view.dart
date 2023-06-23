import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgView extends StatelessWidget {
  final double size, padding;
  final Color color;
  final String icon;

  const SvgView({Key? key, this.size = 24, required this.color, required this.icon, this.padding = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      child: SvgPicture.asset(
        icon,
        color: color,
        height: size,
        width: size,
        matchTextDirection: true,
      ),
    );
  }
}
