import 'dart:convert';
import 'dart:ui' as ui;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friday_v/Constants/api_constants.dart';
import 'package:friday_v/model/org.dart';
import 'package:friday_v/utils/colors.dart';
import 'package:friday_v/utils/svg.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import '../../../Debug/printme.dart';
import '../../../widgets/svg_view.dart';
import '../../../widgets/top_bar.dart';

class FullScreenDialogDemo extends StatefulWidget {
  // ByteData _img = ByteData(0);
  final Session sessData;

  const FullScreenDialogDemo({Key? key, required this.sessData}) : super(key: key);

  @override
  FullScreenDialogDemoState createState() => FullScreenDialogDemoState();
}

class FullScreenDialogDemoState extends State<FullScreenDialogDemo> {
  final _sign = GlobalKey<SignatureState>();
  var color = Colors.red;
  var strokeWidth = 5.0;
  String repName = '';
  var sign;
  var dialog;
  HtmlEditorController controller = HtmlEditorController();
  final ScrollController _scrollController = ScrollController();
  bool toggle = false;
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: TopBar(
        appBar: AppBar(),
        title: "End Session",
        leading: true,
        widgets: const [],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(0.0),
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Work Performed",
                    style: body2.copyWith(color: black, fontWeight: FontWeight.w500),
                  ),
                ),
                ToolbarWidget(
                  controller: controller,
                  htmlToolbarOptions: const HtmlToolbarOptions(
                    defaultToolbarButtons: [
                      ListButtons(listStyles: false),
                      StyleButtons(),
                    ],
                    toolbarPosition: ToolbarPosition.custom,
                  ),
                  callbacks: null,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3, // Set a percentage of the screen height
                    // Set a fixed width value here
                    child: HtmlEditor(
                      controller: controller,
                      htmlEditorOptions: const HtmlEditorOptions(hint: "Type list of work performed on the site"),
                      htmlToolbarOptions:
                          const HtmlToolbarOptions(toolbarPosition: ToolbarPosition.custom, toolbarItemHeight: 10),
                      otherOptions: OtherOptions(
                        decoration: BoxDecoration(
                          border: Border.all(color: borderColor, width: 2.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            //Scroll the signature row dropdown button
            GestureDetector(
              onTap: () {
                setState(() {
                  toggle = !toggle;
                  _scrollController.animateTo(0.0, duration: const Duration(milliseconds: 350), curve: Curves.ease);
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Click for Signature",
                            textAlign: TextAlign.center,
                            style: body2.copyWith(color: secondaryDark, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 24,
                      width: 24,
                      padding: const EdgeInsets.all(6.0),
                      decoration: const BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                      child: SizedBox(
                          height: 16,
                          width: 16,
                          child: SvgView(
                            icon: toggle ? SvgIcon.chevron_down : SvgIcon.chevron_right,
                            size: 16,
                            color: white,
                          )),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            //Signature container
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                height: toggle ? MediaQuery.of(context).size.height * 0.3 : 0,
                // Set a percentage of the screen height
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: borderColor, width: 2.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Signature(
                  color: Colors.black,
                  key: _sign,
                  strokeWidth: strokeWidth,
                  onSign: () {
                    FocusScope.of(context).unfocus();
                    sign = _sign.currentState;
                    setState(() {});
                    debugPrint('${sign.points.length} points in the signature');
                  },
                ),
              ),
            ),
            //Animated check mark button
            Center(
              child: GestureDetector(
                onTap: () {
                  _showMyDialog();
                },
                child: AvatarGlow(
                  endRadius: 48,
                  showTwoGlows: true,
                  glowColor: green_lite,
                  duration: const Duration(milliseconds: 2000),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: green,
                      shape: BoxShape.circle,
                    ),
                    margin: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          SvgIcon.check,
                          color: white,
                          matchTextDirection: true,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  postData(Map<String, dynamic> body) async {
    ProgressDialog progressDialog =
        ProgressDialog(context, message: const Text("Sending data..."), title: const Text("Processing"));
    progressDialog.show();

    //Make request
    Response response = await post(Uri.parse(ApiConstants.endSession), body: body);
    body.remove('signature');
    printMe(body.toString());
    String raw = response.body;
    printMe(raw);
    if (raw == "success") {
      progressDialog.dismiss();
      await NAlertDialog(content: const Text("Job has been closed successfully"), blur: 2, actions: <Widget>[
        TextButton(
          child: Text("Ok"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ]).show(context, transitionType: DialogTransitionType.Bubble);
    } else {
      progressDialog.dismiss();
      dialog = await NAlertDialog(
          title: const Text("Ohhh..."),
          content: const Text("Problem when end the session"),
          blur: 2,
          actions: <Widget>[
            TextButton(child: const Text("Ok"), onPressed: closeDialog(context)),
          ]).show(context, transitionType: DialogTransitionType.Bubble);
    }
    Navigator.pop(context);
  }

  String formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(dateTime);
  }

  String formatTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('HH:mm:ss');
    return formatter.format(dateTime);
  }

  Future<void> _showMyDialog() async {
    DateTime now = DateTime.now();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Is this correct time to enter?'),
                Text('Date is : ${formatDate(now)}'),
                Text('Time is : ${formatTime(now)}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('yes'),
              onPressed: () async {
                Navigator.pop(context);
                //retrieve image data, do whatever you want with it (send to server, save locally...)
                final sign = _sign.currentState;
                final image = await sign!.getData();
                var data = await image.toByteData(format: ui.ImageByteFormat.png);
                debugPrint('${data!.lengthInBytes} data of image');
                debugPrint('${image.width} data of image');
                debugPrint('${image.height} data of image');
                sign.clear();
                final encoded = base64.encode(data.buffer.asUint8List());

                String description = '';
                setState(() {});
                controller.getText().then((value) async {
                  description = value;

                  Map<String, dynamic> body = {
                    'description': description,
                    'signature': encoded.toString(),
                    'log_id': widget.sessData.logId,
                    'org_name': widget.sessData.orgName,
                    'static': "-1",
                  };
                  postData(body);
                });
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context);
                _selectTime(context);
              },
            ),
          ],
        );
      },
    );
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null) {
      //retrieve image data, do whatever you want with it (send to server, save locally...)
      final image = await sign.getData();
      var data = await image.toByteData(format: ui.ImageByteFormat.png);
      sign.clear();
      final encoded = base64.encode(data.buffer.asUint8List());

      String description = '';
      controller.getText().then((value) async {
        description = value;

        final now = DateTime.now();
        var dd = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute, 0);
        var ddd = DateFormat.Hm().format(dd);
        Map<String, dynamic> body = {
          'description': description,
          'signature': encoded.toString(),
          'log_id': widget.sessData.logId,
          'org_name': widget.sessData.orgName,
          'static': '0',
          'manual': ddd
          // 'time':${selectedTime.hour}${selectedTime.minute},
        };
        postData(body);
      });
      Navigator.pop(context);
      setState(() async {});
    }
  }

  closeDialog(BuildContext context) {
    printMe("Closed");
    Navigator.pop(context);
  }
}
