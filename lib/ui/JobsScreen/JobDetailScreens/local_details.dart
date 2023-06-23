import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friday_v/model/org.dart';
import 'package:friday_v/ui/JobsScreen/JobDetailScreens/toggle_button.dart';
import 'package:friday_v/utils/colors.dart';
import 'package:friday_v/utils/svg.dart';
import 'package:friday_v/utils/utils.dart';
import 'package:friday_v/widgets/sizebox_spacer.dart';

import '../../../Debug/printme.dart';
import '../../../widgets/dot_indicator.dart';
import '../../../widgets/top_bar.dart';
import 'full_screen_dialog_demo.dart';

class LocalDetail extends StatefulWidget {
  final Session sessionData;

  const LocalDetail({Key? key, required this.sessionData}) : super(key: key);

  @override
  LocalDetailState createState() => LocalDetailState();
}

class LocalDetailState extends State<LocalDetail> {
  int status = 0;
  final bool _isListening = true;

  @override
  void initState() {
    super.initState();
    status = int.parse(widget.sessionData.inBreak);
  }

  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return Scaffold(
      appBar: TopBar(
        appBar: AppBar(),
        title: widget.sessionData.typeName,
        leading: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            itemDetails(widget.sessionData),
            const SizedBox(height: 4),
            ToggleButton(
                logID: widget.sessionData.logId,
                status: double.parse(widget.sessionData.inBreak),
                onChanged: (s) {
                  setState(() {
                    status = s == -1 ? 0 : 1;
                  });
                }),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: showFab
          ? AnimatedOpacity(
              opacity: status == 0 ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: AvatarGlow(
                animate: _isListening,
                glowColor: green_lite,
                endRadius: 75.0,
                duration: const Duration(milliseconds: 2000),
                repeatPauseDuration: const Duration(milliseconds: 100),
                repeat: true,
                child: FloatingActionButton(
                    elevation: 0,
                    onPressed: _endSession,
                    backgroundColor: green,
                    child: SvgPicture.asset(
                      SvgIcon.check,
                      color: white,
                      matchTextDirection: true,
                    )),
              ),
            )
          : null,
    );
  }

  Widget itemDetails(Session dd) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Text(
                  dd.orgName,
                  style: title.copyWith(color: secondaryDark, fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
                DotIndicator(indicate: status == 0 ? green : primaryDark)
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              dd.siteAddress,
              style: body1.copyWith(color: menuDisabled, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              dd.typeName,
              style: body2.copyWith(color: secondaryDark, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                SvgPicture.asset(
                  SvgIcon.clock,
                  color: primaryColor,
                  height: 16,
                  width: 16,
                  matchTextDirection: true,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  '${Utils().String_toDT(dd.visitDate)} ${dd.inTime}',
                  style: body2.copyWith(color: menuDisabled, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dd.siteRep,
                  style: body1.copyWith(color: secondaryDark, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ));
  }

  void _endSession() async {
    Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => FullScreenDialogDemo(sessData: widget.sessionData),
      fullscreenDialog: true,
    ))
        .whenComplete(() {
      setState(() {
        Navigator.pop(context);
      });
      printMe("closed");
    });
  }
}
