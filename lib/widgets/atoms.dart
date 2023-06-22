import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:friday_v/model/location.dart';
import 'package:friday_v/model/org.dart';
import 'package:friday_v/utils/colors.dart';
import 'package:friday_v/utils/svg.dart';

class SvgView extends StatelessWidget {
  final double size, padding;
  final Color color;
  final String icon;

  const SvgView(
      {Key? key,
      this.size = 24,
      required this.color,
      required this.icon,
      this.padding = 0})
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

class Dummy extends StatelessWidget {
  final double size;

  const Dummy({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      height: size,
      width: size,
      color: Colors.red,
    );
  }
}

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
        style: TextStyle(
            color: titleColor, fontSize: 20, fontWeight: FontWeight.w700),
      ),
      actions: widgets,
      automaticallyImplyLeading: leading,
      elevation: 2.0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}

class MapBottomSheet extends StatelessWidget {
  final Site marker;
  final OrganizationModel? organization;
  final Function(int, String, Site) onPressed;

  const MapBottomSheet(
      {Key? key, required this.marker, required this.onPressed, required this.organization})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      decoration:
          BoxDecoration(color: white, borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 16.0),
            height: 4,
            width: 48,
            decoration: BoxDecoration(
              color: secondaryLite,
              borderRadius: BorderRadius.circular(4.0)
            ),
          ),
          Text(
            organization!.orgName!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: secondaryDark,
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            marker.siteAddress!,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: secondaryDark.withOpacity(0.5),
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 16,
          ),
          Divider(),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: (){
                  onPressed(int.parse(marker.siteId!), marker.siteAddress!, marker);
                  Navigator.pop(context);
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(8.0)
                  ),
                  child: Center(child: Text("Start Work?", style: button.copyWith(color: white, fontWeight: FontWeight.w700),)),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class dotIndicator extends StatelessWidget {
  final Color indicate;

  const dotIndicator({Key? key, required this.indicate}) : super(key: key);

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

spacer(double size) {
  return SizedBox(
    height: size,
    width: size,
  );
}
/*

* SvgView(color: black, size: 22, icon: SvgIcon.search),
        Space(size: 22),
        SvgView(color: black, icon: SvgIcon.notification),
        Space(size: 24),
        SvgView(color: black, size: 24, icon: SvgIcon.overflow),
        Space(size: 16),*/
