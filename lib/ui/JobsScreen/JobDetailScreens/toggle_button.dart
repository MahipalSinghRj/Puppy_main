import 'package:flutter/material.dart';
import 'package:friday_v/service/config.dart';
import 'package:friday_v/utils/colors.dart';
import 'package:http/http.dart';
import 'package:ndialog/ndialog.dart';
import '../../../Debug/printme.dart';

class ToggleButton extends StatefulWidget {
  final double status;
  final String logID;
  final Function(double) onChanged;

  const ToggleButton({Key? key, required this.status, required this.onChanged, required this.logID}) : super(key: key);

  @override
  ToggleButtonState createState() => ToggleButtonState();
}

const double width = 300.0;
const double height = 40.0;
const double loginAlign = -1;
const double signInAlign = 1;

class ToggleButtonState extends State<ToggleButton> {
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
            //In Button
            GestureDetector(
              onTap: () {
                Map<String, dynamic> body = {'log_id': widget.logID, 'user_id': '1'};
                postData(body);
              },
              child: Align(
                alignment: const Alignment(-1, 0),
                child: containerControl(
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
            //Out Button
            GestureDetector(
              onTap: () {
                Map<String, dynamic> body = {'log_id': widget.logID, 'user_id': '1'};
                postData(body);
              },
              child: Align(
                alignment: const Alignment(1, 0),
                child: containerControl(
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

      //Make request
      Response response = await post(Uri.parse(URLHelper.break_toggle), body: body);

      String raw = response.body;
      if (raw == "failed") {
        progressDialog.dismiss();
        await NAlertDialog(
            title: Text("Ohhh..."),
            content: Text("You already have an open session"),
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
      printMe(e.toString());
    }
  }

  Widget containerControl(Widget child) {
    return Container(
      width: width * 0.5,
      color: Colors.transparent,
      alignment: Alignment.center,
      child: child,
    );
  }
}
