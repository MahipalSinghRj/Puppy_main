import 'package:flutter/material.dart';
import 'package:friday_v/utils/colors.dart';
import '../../widgets/svg_view.dart';

class BottomItem extends StatelessWidget {
  final bool isSelected;
  final String menu;
  final String icon;

  const BottomItem({Key? key, required this.isSelected, required this.menu, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        color: Colors.white,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SvgView(
            color: isSelected ? primaryColor : menuDisabled,
            icon: icon,
            padding: 4,
          ),
          isSelected
              ? Text(menu, style: const TextStyle(fontSize: 16.0, color: primaryColor, fontWeight: FontWeight.bold))
              : Container()
        ]));
  }
}
