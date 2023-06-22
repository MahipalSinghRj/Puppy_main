import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:friday_v/Navigation_drawer/drawer.dart';
import 'package:friday_v/utils/colors.dart';
import 'package:friday_v/widgets/atoms.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Debug/printme.dart';

class scanner extends StatefulWidget {
  final String text;
  const scanner({Key? key, required this.text}) : super(key: key);
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<scanner> {
  final sno = TextEditingController();

  File? _image;
  @override
  void initState() {
    super.initState();
    sno.text = widget.text;
    printMe(widget.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Barcode scan')),
        drawer: const NavDrawer(),
        body: Builder(builder: (BuildContext context) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            children: [
              spacer(8.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              ),
              spacer(16.0),
              Text(
                "Product Name",
                style: body2.copyWith(color: secondaryDark),
              ),
              spacer(8.0),
              TextField(
                textInputAction: TextInputAction.go,
                //controller: TextEditingController()..text = initialValue ?? '',
                style: body1.copyWith(color: secondaryDark),
                decoration: InputDecoration(
                    filled: true,
                    isDense: true,
                    fillColor: white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: primaryLite.withOpacity(0.8), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: borderColor, width: 2.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8.0),
                    hintText: "Enter Product Name",
                    hintStyle: const TextStyle(color: Colors.grey)),
              ),
              spacer(16.0),
              const Text("serial Number"),
              spacer(8.0),
              TextField(
                textInputAction: TextInputAction.go,
                controller: sno,
                readOnly: true,
                onTap: () {
                  _showPicker(context);
                },
                onChanged: (dg) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => QRViewExample(),
                  ));
                },
                //controller: TextEditingController()..text = initialValue ?? '',
                style: body1.copyWith(color: secondaryDark),
                decoration: InputDecoration(
                    filled: true,
                    isDense: true,
                    fillColor: white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: primaryLite.withOpacity(0.8), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: borderColor, width: 2.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8.0),
                    hintText: "Enter serial number",
                    hintStyle: const TextStyle(color: Colors.grey)),
              ),
              spacer(16.0),
              Text(
                "enroll Number",
                style: body2.copyWith(color: secondaryDark),
              ),
              spacer(8.0),
              TextField(
                textInputAction: TextInputAction.go,
                //controller: TextEditingController()..text = initialValue ?? '',
                style: body1.copyWith(color: secondaryDark),
                decoration: InputDecoration(
                    filled: true,
                    isDense: true,
                    fillColor: white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: primaryLite.withOpacity(0.8), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: borderColor, width: 2.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8.0),
                    hintText: "Enter enroll number",
                    hintStyle: const TextStyle(color: Colors.grey)),
              ),
              spacer(16.0),
              Text(
                "Select Product image",
                style: body2.copyWith(color: secondaryDark),
              ),
              spacer(8.0),
              Column(
                children: <Widget>[
                  const SizedBox(height: 32),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        _showPickers(context);
                      },
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: const Color(000),
                        child: _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  _image!,
                                  width: 1500,
                                  height: 1500,
                                  fit: BoxFit.fitHeight,
                                ),
                              )
                            : Container(
                                decoration:
                                    BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(50)),
                                width: 100,
                                height: 100,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey[800],
                                ),
                              ),
                      ),
                    ),
                  )
                ],
              ),
              spacer(32.0),
              TextButton(
                child: const Text('Submit'),
                onPressed: () {
                  //Navigator.pop(context);
                },
              ),
            ],
          );
        }));
  }

  void _showPickers(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      _getFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  imgFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showPicker(context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => QRViewExample(),
    ));
  }
}

// Qr code scanner
class qr_code extends StatelessWidget {
  const qr_code({Key? key, required this.text}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('qrcode scanner')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => QRViewExample(),
            ));
          },
          child: const Text('qrView'),
        ),
      ),
    );
  }
}

class QRViewExample extends StatefulWidget {
  const QRViewExample({super.key});

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  // late final String url;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          //  Expanded(
          //  flex: 1,
          //child: FittedBox(
          //fit: BoxFit.contain,
          //child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //children: <Widget>[
          //     if (result != null)
          // //  return WebView(
          // // initialUrl: result!.code,
          // //    )
          //
          //       Text(
          //           ': ${describeEnum(result!.format)}   Data: ${result!.code}')
          //     else
          //       Text('Scan a code'),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: <Widget>[
          //     Container(
          //       margin: EdgeInsets.all(8),
          //       child: ElevatedButton(
          //           onPressed: () async {
          //             await controller?.toggleFlash();
          //             setState(() {});
          //           },
          //           child: FutureBuilder(
          //             future: controller?.getFlashStatus(),
          //             builder: (context, snapshot) {
          //               return Text('Flash: ${snapshot.data}');
          //             },
          //           )),
          //     ),
          //     Container(
          //       margin: EdgeInsets.all(8),
          //       child: ElevatedButton(
          //           onPressed: () async {
          //
          //             await controller?.flipCamera();
          //             setState(() {});
          //           },
          //           child: FutureBuilder(
          //             future: controller?.getCameraInfo(),
          //             builder: (context, snapshot) {
          //               if (snapshot.data != null) {
          //                 return Text(
          //                     'Camera facing ${describeEnum(snapshot.data!)}');
          //               } else {
          //                 return Text('loading');
          //               }
          //             },
          //           )),
          //     )
          //   ],
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: <Widget>[
          //     Container(
          //       margin: EdgeInsets.all(8),
          //       child: ElevatedButton(
          //         onPressed: () async {
          //           await controller?.pauseCamera();
          //         },
          //         child: Text('pause', style: TextStyle(fontSize: 20)),
          //       ),
          //     ),
          //     Container(
          //       margin: EdgeInsets.all(8),
          //       child: ElevatedButton(
          //         onPressed: () async {
          //           await controller?.resumeCamera();
          //         },
          //         child: Text('resume', style: TextStyle(fontSize: 20)),
          //       ),
          //     )
          //   ],
          // ),
          // ],
          //  ),
          //),
          //)
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea =
        (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 150.0 : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red, borderRadius: 10, borderLength: 30, borderWidth: 10, cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        var url = result!.code as String;
        // WebView(
        //   initialUrl:'https://flutter.dev',
        // );
        // url=result as String;
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => scanner(
                text: url,
              ),
            ));
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
// @override
// void initState() {
//   super.initState();
//   if (result != null) {
//     //_checkPermissions();
//
//   }
//
}

// web view
class WebViewExample extends StatefulWidget {
  final String text;
  // receive data from the FirstScreen as a parameter
  const WebViewExample({Key? key, required this.text}) : super(key: key);

  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WebView(
      initialUrl: widget.text,
    ));
  }

  @override
  bool get wantKeepAlive => true;
}

//   @override
//   Widget build(BuildContext context) {
//     return WebView(
//       initialUrl: widget.text,
//     );
//   }
// }

// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:friday_v/Navigation_drawer/drawer.dart';
// import 'package:friday_v/utils/colors.dart';
// import 'package:friday_v/widgets/atoms.dart';
// import 'package:location/location.dart';
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class scanner extends StatefulWidget {
//   const scanner({Key? key, required this.title}) : super(key: key);
//   final String title;
//   @override
//   _SplashState createState() => _SplashState();
// }
//
//
// class _SplashState extends State<scanner> {
//
//   final sno = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//   //  sno.text=widget.text;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//         return Scaffold(
//     appBar: AppBar(title: const Text('Barcode scan')),
//             drawer: NavDrawer(),
//             body: Builder(builder: (BuildContext context) {
//               return Container(
//                   child: ListView(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               physics: const ScrollPhysics(),
//               shrinkWrap: true,
//               children:[
//                 spacer(8.0),
//                 Container(
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
//                 ),
//                 spacer(16.0),
//                 Text(
//                   "Product Name",
//                   style: body2.copyWith(color: secondaryDark),
//                 ),
//                 spacer(8.0),
//                 TextField(
//                   textInputAction: TextInputAction.go,
//                   //controller: TextEditingController()..text = initialValue ?? '',
//                   style: body1.copyWith(color: secondaryDark),
//                   decoration: InputDecoration(
//                       filled: true,
//                       isDense: true,
//                       fillColor: white,
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                         borderSide: BorderSide(
//                             color: primaryLite.withOpacity(0.8), width: 2.0),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                         borderSide:
//                         const BorderSide(color: borderColor, width: 2.0),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           vertical: 10, horizontal: 8.0),
//                       hintText: "Enter Product Name",
//                       hintStyle: const TextStyle(color: Colors.grey)),
//                 ),
//                 spacer(16.0),
//                 FlatButton(
//                   child: new Text('serial Number'),
//                   onPressed: () {
//                     Navigator.of(context).push(MaterialPageRoute(
//                       builder: (context) => QRViewExample(),
//                     ));
//                     },
//                 ),
//                 // Text(
//                 //   "serial Number",
//                 //
//                 // ),
//                 spacer(8.0),
//                 TextField(
//                   textInputAction: TextInputAction.go,
//                  // controller:sno,
//                   //controller: TextEditingController()..text = initialValue ?? '',
//                   style: body1.copyWith(color: secondaryDark),
//                   decoration: InputDecoration(
//                       filled: true,
//                       isDense: true,
//                       fillColor: white,
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                         borderSide: BorderSide(
//                             color: primaryLite.withOpacity(0.8), width: 2.0),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                         borderSide:
//                         const BorderSide(color: borderColor, width: 2.0),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           vertical: 10, horizontal: 8.0),
//                       hintText: "Enter serial number",
//                       hintStyle: const TextStyle(color: Colors.grey)),
//                 ),
//                 spacer(16.0),
//                 Text(
//                   "enroll Number",
//                   style: body2.copyWith(color: secondaryDark),
//                 ),
//                 spacer(8.0),
//                 TextField(
//                   textInputAction: TextInputAction.go,
//                   //controller: TextEditingController()..text = initialValue ?? '',
//                   style: body1.copyWith(color: secondaryDark),
//                   decoration: InputDecoration(
//                       filled: true,
//                       isDense: true,
//                       fillColor: white,
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                         borderSide: BorderSide(
//                             color: primaryLite.withOpacity(0.8), width: 2.0),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                         borderSide:
//                         const BorderSide(color: borderColor, width: 2.0),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           vertical: 10, horizontal: 8.0),
//                       hintText: "Enter enroll number",
//                       hintStyle: const TextStyle(color: Colors.grey)),
//                 ),
//               ],
//                   ),
//               );
//             }));
//   }
//   }
//
// // Qr code scanner
// class qr_code extends StatelessWidget {
//   const qr_code({Key? key,required this.text}) : super(key: key);
//   final String text;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('qrcode scanner')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.of(context).push(MaterialPageRoute(
//               builder: (context) => QRViewExample(),
//             ));
//           },
//           child: Text('qrView'),
//         ),
//       ),
//     );
//   }
// }
//
// class QRViewExample extends StatefulWidget {
//
//   @override
//   State<StatefulWidget> createState() => _QRViewExampleState();
// }
//
// class _QRViewExampleState extends State<QRViewExample> {
//   Barcode? result;
//   // late final String url;
//   QRViewController? controller;
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   // In order to get hot reload to work we need to pause the camera if the platform
//   // is android, or resume the camera if the platform is iOS.
//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller!.pauseCamera();
//     }
//     controller!.resumeCamera();
//   }
//
//   void initState() {
//     super.initState();
//     // Enable hybrid composition.
//     if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           Expanded(flex: 4, child: _buildQrView(context)),
//         ],
//       ),
//     );
//
//
//
//   }
//
//   Widget _buildQrView(BuildContext context) {
//     // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
//     var scanArea = (MediaQuery.of(context).size.width < 400 ||
//         MediaQuery.of(context).size.height < 400)
//         ? 150.0
//         : 300.0;
//     // To ensure the Scanner view is properly sizes after rotation
//     // we need to listen for Flutter SizeChanged notification and update controller
//     return QRView(
//       key: qrKey,
//       onQRViewCreated: _onQRViewCreated,
//       overlay: QrScannerOverlayShape(
//           borderColor: Colors.red,
//           borderRadius: 10,
//           borderLength: 30,
//           borderWidth: 10,
//           cutOutSize: scanArea),
//       onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
//     );
//   }
//
//   void _onQRViewCreated(QRViewController controller) {
//     setState(() {
//       this.controller = controller;
//     });
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         result = scanData;
//         var url=result!.code as String;
//         print(url);
//         // WebView(
//         //   initialUrl:'https://flutter.dev',
//         // );
//         // url=result as String;
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => WebViewExample(text:url,),
//             ));
//       });
//     });
//   }
//
//   void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
//     log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
//     if (!p) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('no Permission')),
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
// // @override
// // void initState() {
// //   super.initState();
// //   if (result != null) {
// //     //_checkPermissions();
// //
// //   }
// //
// }
// // web view
// class WebViewExample extends StatefulWidget {
//   final String text;
//   // receive data from the FirstScreen as a parameter
//   const WebViewExample({Key? key, required this.text}) : super(key: key);
//
//   @override
//   WebViewExampleState createState() => WebViewExampleState();
// }
//
// class WebViewExampleState extends State<WebViewExample> {
//   @override
//   void initState() {
//     super.initState();
//     // Enable hybrid composition.
//     if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: WebView(
//           initialUrl: widget.text,
//         ));
//   }
//
//   @override
//   bool get wantKeepAlive => true;
// }

//   @override
//   Widget build(BuildContext context) {
//     return WebView(
//       initialUrl: widget.text,
//     );
//   }
// }

// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:friday_v/Navigation_drawer/drawer.dart';
// import 'package:friday_v/utils/colors.dart';
// import 'package:friday_v/widgets/atoms.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class Barcode extends StatefulWidget {
//   final String text;
//   const Barcode({Key? key, required this.text}) : super(key: key);
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<Barcode> {
//   String _scanBarcode = 'Unknown';
//   final sno = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     sno.text=widget.text;
//   }
//
//
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//
//
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//     appBar: AppBar(title: const Text('Barcode scan')),
//             drawer: NavDrawer(),
//             body: Builder(builder: (BuildContext context) {
//               return Container(
//                   child: ListView(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               physics: const ScrollPhysics(),
//               shrinkWrap: true,
//               children:[
//                 spacer(8.0),
//                 Container(
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
//                 ),
//                 spacer(16.0),
//                 Text(
//                   "Product Name",
//                   style: body2.copyWith(color: secondaryDark),
//                 ),
//                 spacer(8.0),
//                 TextField(
//                   textInputAction: TextInputAction.go,
//                   //controller: TextEditingController()..text = initialValue ?? '',
//                   style: body1.copyWith(color: secondaryDark),
//                   decoration: InputDecoration(
//                       filled: true,
//                       isDense: true,
//                       fillColor: white,
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                         borderSide: BorderSide(
//                             color: primaryLite.withOpacity(0.8), width: 2.0),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                         borderSide:
//                         const BorderSide(color: borderColor, width: 2.0),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           vertical: 10, horizontal: 8.0),
//                       hintText: "Enter Product Name",
//                       hintStyle: const TextStyle(color: Colors.grey)),
//                 ),
//                 spacer(16.0),
//                 FlatButton(
//                   child: new Text('serial Number'),
//                   onPressed: () {
//                     Navigator.of(context).push(MaterialPageRoute(
//                       builder: (context) => qr_code(text: '',),
//                     ));
//                     },
//                 ),
//                 // Text(
//                 //   "serial Number",
//                 //
//                 // ),
//                 spacer(8.0),
//                 TextField(
//                   textInputAction: TextInputAction.go,
//                   controller:sno,
//                   //controller: TextEditingController()..text = initialValue ?? '',
//                   style: body1.copyWith(color: secondaryDark),
//                   decoration: InputDecoration(
//                       filled: true,
//                       isDense: true,
//                       fillColor: white,
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                         borderSide: BorderSide(
//                             color: primaryLite.withOpacity(0.8), width: 2.0),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                         borderSide:
//                         const BorderSide(color: borderColor, width: 2.0),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           vertical: 10, horizontal: 8.0),
//                       hintText: "Enter serial number",
//                       hintStyle: const TextStyle(color: Colors.grey)),
//                 ),
//                 spacer(16.0),
//                 Text(
//                   "enroll Number",
//                   style: body2.copyWith(color: secondaryDark),
//                 ),
//                 spacer(8.0),
//                 TextField(
//                   textInputAction: TextInputAction.go,
//                   //controller: TextEditingController()..text = initialValue ?? '',
//                   style: body1.copyWith(color: secondaryDark),
//                   decoration: InputDecoration(
//                       filled: true,
//                       isDense: true,
//                       fillColor: white,
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                         borderSide: BorderSide(
//                             color: primaryLite.withOpacity(0.8), width: 2.0),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                         borderSide:
//                         const BorderSide(color: borderColor, width: 2.0),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           vertical: 10, horizontal: 8.0),
//                       hintText: "Enter enroll number",
//                       hintStyle: const TextStyle(color: Colors.grey)),
//                 ),
//               ],
//                   ),
//               );
//             }));
//   }
// }
// // Qr code scanner
//
//
//
// class qr_code extends StatelessWidget {
//   const qr_code({Key? key,required this.text}) : super(key: key);
//   final String text;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('qrcode scanner')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.of(context).push(MaterialPageRoute(
//               builder: (context) => QRViewExample(),
//             ));
//           },
//           child: Text('qrView'),
//         ),
//       ),
//     );
//   }
// }
//
// class QRViewExample extends StatefulWidget {
//
//   @override
//   State<StatefulWidget> createState() => _QRViewExampleState();
// }
//
// class _QRViewExampleState extends State<QRViewExample> {
//   Barcode? result;
//   // late final String url;
//   QRViewController? controller;
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//
//
//
//   // In order to get hot reload to work we need to pause the camera if the platform
//   // is android, or resume the camera if the platform is iOS.
//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller!.pauseCamera();
//     }
//     controller!.resumeCamera();
//   }
//
//   void initState() {
//     super.initState();
//     // Enable hybrid composition.
//     if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           Expanded(flex: 4, child: _buildQrView(context)),
//           //  Expanded(
//           //  flex: 1,
//           //child: FittedBox(
//           //fit: BoxFit.contain,
//           //child: Column(
//           //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           //children: <Widget>[
//           //     if (result != null)
//           // //  return WebView(
//           // // initialUrl: result!.code,
//           // //    )
//           //
//           //       Text(
//           //           ': ${describeEnum(result!.format)}   Data: ${result!.code}')
//           //     else
//           //       Text('Scan a code'),
//
//           // Row(
//           //   mainAxisAlignment: MainAxisAlignment.center,
//           //   crossAxisAlignment: CrossAxisAlignment.center,
//           //   children: <Widget>[
//           //     Container(
//           //       margin: EdgeInsets.all(8),
//           //       child: ElevatedButton(
//           //           onPressed: () async {
//           //             await controller?.toggleFlash();
//           //             setState(() {});
//           //           },
//           //           child: FutureBuilder(
//           //             future: controller?.getFlashStatus(),
//           //             builder: (context, snapshot) {
//           //               return Text('Flash: ${snapshot.data}');
//           //             },
//           //           )),
//           //     ),
//           //     Container(
//           //       margin: EdgeInsets.all(8),
//           //       child: ElevatedButton(
//           //           onPressed: () async {
//           //
//           //             await controller?.flipCamera();
//           //             setState(() {});
//           //           },
//           //           child: FutureBuilder(
//           //             future: controller?.getCameraInfo(),
//           //             builder: (context, snapshot) {
//           //               if (snapshot.data != null) {
//           //                 return Text(
//           //                     'Camera facing ${describeEnum(snapshot.data!)}');
//           //               } else {
//           //                 return Text('loading');
//           //               }
//           //             },
//           //           )),
//           //     )
//           //   ],
//           // ),
//           // Row(
//           //   mainAxisAlignment: MainAxisAlignment.center,
//           //   crossAxisAlignment: CrossAxisAlignment.center,
//           //   children: <Widget>[
//           //     Container(
//           //       margin: EdgeInsets.all(8),
//           //       child: ElevatedButton(
//           //         onPressed: () async {
//           //           await controller?.pauseCamera();
//           //         },
//           //         child: Text('pause', style: TextStyle(fontSize: 20)),
//           //       ),
//           //     ),
//           //     Container(
//           //       margin: EdgeInsets.all(8),
//           //       child: ElevatedButton(
//           //         onPressed: () async {
//           //           await controller?.resumeCamera();
//           //         },
//           //         child: Text('resume', style: TextStyle(fontSize: 20)),
//           //       ),
//           //     )
//           //   ],
//           // ),
//           // ],
//           //  ),
//           //),
//           //)
//         ],
//       ),
//     );
//
//
//
//   }
//
//   Widget _buildQrView(BuildContext context) {
//     // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
//     var scanArea = (MediaQuery.of(context).size.width < 400 ||
//         MediaQuery.of(context).size.height < 400)
//         ? 150.0
//         : 300.0;
//     // To ensure the Scanner view is properly sizes after rotation
//     // we need to listen for Flutter SizeChanged notification and update controller
//     return QRView(
//       key: qrKey,
//       onQRViewCreated: _onQRViewCreated,
//       overlay: QrScannerOverlayShape(
//           borderColor: Colors.red,
//           borderRadius: 10,
//           borderLength: 30,
//           borderWidth: 10,
//           cutOutSize: scanArea),
//       onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
//     );
//   }
//
//   void _onQRViewCreated(QRViewController controller) {
//     setState(() {
//       this.controller = controller;
//     });
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         result = scanData;
//         var url=result as String;
//         print(url);
//         // WebView(
//         //   initialUrl:'https://flutter.dev',
//         // );
//         // url=result as String;
//         // Navigator.push(
//         //     context,
//         //     MaterialPageRoute(
//         //       builder: (context) => WebViewExample(text:url,),
//         //     ));
//       });
//     });
//   }
//
//   void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
//    // log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
//     if (!p) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('no Permission')),
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
// }
