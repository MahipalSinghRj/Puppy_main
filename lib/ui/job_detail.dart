import 'dart:convert';
import 'dart:ui' as ui;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friday_v/model/org.dart';
import 'package:friday_v/service/config.dart';
import 'package:friday_v/utils/colors.dart';
import 'package:friday_v/utils/svg.dart';
import 'package:friday_v/utils/utils.dart';
import 'package:friday_v/widgets/atoms.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';

class LocalDetail extends StatefulWidget {
  final Session sessionData;

  const LocalDetail({Key? key, required this.sessionData}) : super(key: key);

  @override
  _LocalDetailState createState() => _LocalDetailState();
}

class _LocalDetailState extends State<LocalDetail> {
  int status = 0;
  bool _isListening = true;

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
        child: Container(
          child: Column(
            children: [
              Item(widget.sessionData),
              const SizedBox(
                height: 4,
              ),
              ToggleButton(
                  logID: widget.sessionData.logId,
                  status: double.parse(widget.sessionData.inBreak),
                  onChanged: (s) {
                    setState(() {
                      status = s == -1 ? 0 : 1;
                    });
                  }),
              // Expanded(
              //   child: ListView.builder(
              //     padding: EdgeInsets.symmetric(horizontal: 16.0),
              //     reverse: true,
              //     physics: ScrollPhysics(),
              //     itemCount: 10,
              //     itemBuilder: (BuildContext context, int index) {
              //       return Container();
              //       // return dc();
              //     },
              //   ),
              // ),
              // const SizedBox(height: 8),
            ],
          ),
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

  Widget Item(Session dd) {
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
                dotIndicator(
                  indicate: status == 0 ? green : primaryDark,
                )
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
                  Utils().String_toDT(dd.visitDate) + ' ' + dd.inTime,
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

// void _listen() async {
//   if (!_isListening) {
//     bool available = await _speech!.initialize(
//       onStatus: (val) => print('onStatus: $val'),
//       onError: (val) => print('onError: $val'),
//     );
//     if (available) {
//       setState(() => _isListening = true);
//       _speech!.listen(
//         onResult: (val) => setState(() {
//           _text = val.recognizedWords;
//           print(_text);
//           if (val.hasConfidenceRating && val.confidence > 0) {
//             _confidence = val.confidence;
//           }
//         }),
//       );
//     }
//   } else {
//     setState(() => _isListening = false);
//     _speech!.stop();
//   }
// }
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
      print("closed");
    });
  }
}

class FullScreenDialogDemo extends StatefulWidget {
  // ByteData _img = ByteData(0);
  final Session sessData;

  FullScreenDialogDemo({Key? key, required this.sessData}) : super(key: key);

  @override
  _FullScreenDialogDemoState createState() => _FullScreenDialogDemoState();
}

class _FullScreenDialogDemoState extends State<FullScreenDialogDemo> {
  var color = Colors.red;
  TimeOfDay selectedTime = TimeOfDay.now();

  var strokeWidth = 5.0;

  final _sign = GlobalKey<SignatureState>();
  String repName = '';
  var sign;

  var dialog;
  HtmlEditorController controller = HtmlEditorController();
  ScrollController _scrollController = ScrollController();
  bool toggle = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Decoration? foregroundDecoration;

    // Remove the MediaQuery padding because the demo is rendered inside of a
    // different page that already accounts for this padding.
    return MediaQuery.removePadding(
      context: context,
      removeTop: false,
      removeBottom: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: TopBar(
          appBar: AppBar(),
          title: "End Session",
          leading: true,
          widgets: [],
        ),
        body: SingleChildScrollView(
          reverse: true,
          controller: _scrollController,
          padding: const EdgeInsets.all(0.0),
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
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
                          HtmlEditor(
                            controller: controller,
                            htmlEditorOptions: const HtmlEditorOptions(hint: "Type list of work perform on the site"),
                            htmlToolbarOptions: const HtmlToolbarOptions(
                                toolbarPosition: ToolbarPosition.custom, toolbarItemHeight: 10),
                            otherOptions: OtherOptions(
                              decoration: BoxDecoration(
                                  border: Border.all(color: borderColor, width: 2.0),
                                  borderRadius: BorderRadius.circular(8.0)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Scroll for Signature",
                            textAlign: TextAlign.center,
                            style: body2.copyWith(color: secondaryDark, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          toggle = !toggle;
                          _scrollController.animateTo(0.0,
                              duration: const Duration(milliseconds: 350), curve: Curves.ease);
                        });
                      },
                      child: Container(
                        height: 24,
                        width: 24,
                        padding: const EdgeInsets.all(6.0),
                        decoration: const BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                        child: SizedBox(
                            height: 16,
                            width: 16,
                            child: SvgView(
                              icon: SvgIcon.chevron_down,
                              size: 16,
                              color: white,
                            )),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  height: toggle ? MediaQuery.of(context).size.height / 2 : 0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: borderColor, width: 2.0),
                      borderRadius: BorderRadius.circular(10)),
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
      ),
    );
  }

  postData(Map<String, dynamic> body) async {
    // try {
    ProgressDialog progressDialog =
        ProgressDialog(context, message: const Text("Sending data..."), title: const Text("Processing"));

    progressDialog.show();
    // make request
    Response response = await post(Uri.parse(URLHelper.endSession), body: body);
    body.remove('signature');
    print(body);
    String raw = response.body;
    print(raw + "===========================");
    if (raw == "success") {
      progressDialog.dismiss();
      await NAlertDialog(
          // title: const Text("Great"),
          content: const Text("Job has been closed successfully"),
          blur: 2,
          actions: <Widget>[
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
    // } catch (e) {
    //   print(e.toString());
    // }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Is this correct time to enter?'),
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
                final encoded = base64.encode(data!.buffer.asUint8List());

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
        // body.remove('signature');
        // print(body);
        //
        postData(body);
      });
      Navigator.pop(context);
      setState(() async {});
    }
  }

  closeDialog(BuildContext context) {
    print("Closed");
    Navigator.pop(context);
  }
}

class ToggleButton extends StatefulWidget {
  final double status;
  final String logID;
  final Function(double) onChanged;

  const ToggleButton({Key? key, required this.status, required this.onChanged, required this.logID}) : super(key: key);

  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

const double width = 300.0;
const double height = 40.0;
const double loginAlign = -1;
const double signInAlign = 1;

class _ToggleButtonState extends State<ToggleButton> {
  TimeOfDay selectedTime = TimeOfDay.now();
  double? xAlign;

  @override
  void initState() {
    super.initState();
    xAlign = widget.status == 0 ? -1 : 1;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor, width: 2),
          color: white,
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              alignment: Alignment(xAlign!, 0),
              duration: const Duration(milliseconds: 300),
              child: Container(
                width: width * 0.5,
                height: height,
                decoration: const BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(6.0),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Map<String, dynamic> body = {'log_id': widget.logID, 'user_id': '1'};
                postData(body);
              },
              child: Align(
                alignment: const Alignment(-1, 0),
                child: ContainerControl(
                  const Text(
                    'In',
                    style: TextStyle(
                      color: secondaryDark,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Map<String, dynamic> body = {'log_id': widget.logID, 'user_id': '1'};
                postData(body);
              },
              child: Align(
                alignment: const Alignment(1, 0),
                child: ContainerControl(
                  const Text(
                    'Out',
                    style: TextStyle(
                      fontSize: 18,
                      color: secondaryDark,
                      fontWeight: FontWeight.bold,
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
    try {
      ProgressDialog progressDialog =
          ProgressDialog(context, message: const Text("Sending data..."), title: const Text("Processing"));

      progressDialog.show();
      // make request
      Response response = await post(Uri.parse(URLHelper.break_toggle), body: body);
      // int raw = int.parse(response.body);
      String raw = response.body;
      if (raw == "failed") {
        progressDialog.dismiss();
        await NAlertDialog(
            title: const Text("Ohhh..."),
            content: const Text("You already have an open session"),
            blur: 2,
            actions: <Widget>[
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ]).show(context, transitionType: DialogTransitionType.Bubble);
      }
      if (raw == "0") {
        progressDialog.dismiss();
        widget.onChanged(loginAlign);
        setState(() {
          xAlign = loginAlign;
        });
      } else {
        progressDialog.dismiss();
        widget.onChanged(signInAlign);
        setState(() {
          xAlign = signInAlign;
        });
        Navigator.pop(context);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Widget ContainerControl(Widget child) {
    return Container(
      width: width * 0.5,
      color: Colors.transparent,
      alignment: Alignment.center,
      child: child,
    );
  }
}
