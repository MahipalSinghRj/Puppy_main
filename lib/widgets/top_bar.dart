import 'package:flutter/material.dart';
import 'package:friday_v/utils/colors.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? backgroundColor, titleColor;
  final AppBar appBar;
  final List<Widget>? widgets;
  final bool leading;

  const TopBar(
      {Key? key,
      required this.title,
      this.backgroundColor = white,
      this.titleColor = black,
      required this.appBar,
      this.widgets,
      this.leading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      title: Text(
        title,
        style: TextStyle(color: titleColor, fontSize: 20, fontWeight: FontWeight.w700),
      ),
      actions: widgets,
      automaticallyImplyLeading: leading,
      elevation: 2.0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
