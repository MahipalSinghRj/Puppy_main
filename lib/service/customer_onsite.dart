import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friday_v/Constants/api_constants.dart';
import 'package:friday_v/Navigation_drawer/drawer.dart';
import 'package:friday_v/model/location.dart';
import 'package:friday_v/model/org.dart';
 import 'package:friday_v/service/job_service.dart';
import 'package:friday_v/service/user_service.dart';
import 'package:friday_v/utils/colors.dart';
import 'package:friday_v/utils/size_config.dart';
import 'package:friday_v/widgets/sizebox_spacer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:ndialog/ndialog.dart';
import '../Debug/printme.dart';

class CustomerOnSite extends StatefulWidget {
  static const String routeName = '/customer_onsite';

  const CustomerOnSite({super.key});

  @override
  MeetingSite createState() => MeetingSite();
}

class MeetingSite extends State<CustomerOnSite> with TickerProviderStateMixin {
  //On load initialization
  late GoogleMapController _controller;
  static const LatLng initialLocation = LatLng(-36.502181, 145.483975);

  final company = TextEditingController();
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final emails = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final latitute = TextEditingController();
  final longitute = TextEditingController();

  final Set<Marker> _marker = {};

  //Initial Camera position
  static const CameraPosition _kGooglePlex = CameraPosition(target: initialLocation, zoom: 5.4746);

  String Address = "search";

  //Change the map theme
  changeMapMode() {
    getJsonFile("assets/style.json").then(setMapStyle);
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    setState(() {
      _controller.setMapStyle(mapStyle);
    });
  }

  late BitmapDescriptor pinLocationIcon;

  void setCustomMapPin() async {
    pinLocationIcon =
        await BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 1.5), 'assets/marker.png');
  }

  //ViewModels for API responses
  List<OrganizationModel> data = [];
  List<Site> site = [];
  OrganizationModel? dropdownValue;
  String? initialValue = '';

  //Parameters
  int? OrgID = 0, jobID = 0, siteID = 0;
  String? repName = "";
  double? lat = 0;
  double? long = 0;
  String user_id = "", siteLatLng = "";

  //Job Dropdown
  List<JobType> jobList = [];
  JobType? jobValue;

  String id = '1';

  @override
  void initState() {
    JobService().getOrganization().then((value) {
      setState(() {
        data = value;
      });
    });

    JobService().fetchList().then((value) {
      setState(() {
        jobList = value;
      });
    });

    setCustomMapPin();

    UserService().getID().then((value) {
      id = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("customer onsite"),
          // leading: true,
        ),
        drawer: const NavDrawer(),
        body: SafeArea(
          child: ListView(
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
                "Company",
                style: body2.copyWith(color: secondaryDark),
              ),
              spacer(8.0),
              TextField(
                textInputAction: TextInputAction.go,
                onChanged: (s) => repName = s,
                controller: company,
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
                    hintText: "Company Name",
                    hintStyle: const TextStyle(color: Colors.grey)),
              ),
              spacer(16.0),
              Text(
                "First Name",
                style: body2.copyWith(color: secondaryDark),
              ),
              TextField(
                onChanged: (s) => repName = s,
                controller: firstname,
                // controller: TextEditingController()..text = initialValue ?? '',
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
                    hintText: "First Name",
                    hintStyle: const TextStyle(color: Colors.grey)),
              ),
              spacer(8.0),
              Text(
                "Last Name",
                style: body2.copyWith(color: secondaryDark),
              ),
              TextField(
                onChanged: (s) => repName = s,
                controller: lastname,
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
                    hintText: "Last Name",
                    hintStyle: const TextStyle(color: Colors.grey)),
              ),
              spacer(8.0),
              Text(
                "Email",
                style: body2.copyWith(color: secondaryDark),
              ),
              TextField(
                onChanged: (s) => repName = s,
                controller: emails,
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
                    hintText: "Email",
                    hintStyle: const TextStyle(color: Colors.grey)),
              ),
              spacer(8.0),
              Text(
                "phone",
                style: body2.copyWith(color: secondaryDark),
              ),
              TextField(
                onChanged: (s) => repName = s,
                controller: phone,
                keyboardType: TextInputType.number,
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
                    hintText: "phone",
                    hintStyle: const TextStyle(color: Colors.grey)),
              ),
              spacer(8.0),
              Text(
                "Address",
                style: body2.copyWith(color: secondaryDark),
              ),
              TextField(
                onChanged: (s) => repName = s,
                controller: address,
                // controller: TextEditingController()..text = initialValue ?? '',
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
                    hintText: "Address",
                    hintStyle: const TextStyle(color: Colors.grey)),
              ),
              spacer(8.0),
              Text(
                'lat',
                style: body2.copyWith(color: secondaryDark),
              ),
              TextField(
                onChanged: (s) => lat = s.toString() as double?,
                controller: latitute,
                // value = double.parse(s);
                //controller: TextEditingController()..text = lat as double,
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
                    hintText: "Lat",
                    hintStyle: const TextStyle(color: Colors.grey)),
              ),
              Text(
                "Long",
                style: body2.copyWith(color: secondaryDark),
              ),
              TextField(
                onChanged: (s) => long.toString(),
                controller: longitute,
                //controller: TextEditingController()..text = long.toString(),
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
                    hintText: "Long",
                    hintStyle: const TextStyle(color: Colors.grey)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              ),
              spacer(16.0),
              Text(
                "Site Location",
                style: body2.copyWith(color: secondaryDark),
              ),
              spacer(8.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor, width: 2.0),
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: SizedBox(
                    height: SizeConfig.screenWidth_,
                    width: SizeConfig.screenWidth_,
                    child: GoogleMap(
                      markers: _marker,
                      //site == null ? _mainMarker() : _createMarker(site),
                      onTap: (LatLng latLng) async {
                        // _marker.clear();
                        _marker.add(Marker(
                          markerId: MarkerId(latLng.toString()),
                          position: latLng,
                          infoWindow: const InfoWindow(title: 'I am a marker'),
                          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                        ));
                        lat = latLng.latitude;
                        long = latLng.longitude;
                        latitute.text = lat.toString();
                        longitute.text = long.toString();
                        printMe(lat.toString());
                        printMe(long.toString());
                        address.text = Address;
                        setState(() {});
                      },
                      myLocationEnabled: true,
                      trafficEnabled: true,
                      scrollGesturesEnabled: true,
                      myLocationButtonEnabled: true,
                      mapType: MapType.normal,
                      initialCameraPosition: _kGooglePlex,
                      gestureRecognizers: Set()..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),
                      onMapCreated: (GoogleMapController controller) {
                        _controller = controller;
                        changeMapMode();
                      },
                    ),
                  ),
                ),
              ),
              spacer(16.0),
              TextButton(
                child: const Text('Submit'),
                onPressed: () {
                  Map<String, dynamic> body = {
                    'org_name': company.text,
                    'rep_first_name': firstname.text,
                    'rep_last_name': lastname.text,
                    'email': emails.text,
                    'phone': phone.text,
                    'address': address.text,
                    'lat': lat.toString(),
                    'lng': long.toString(),
                  };
                  printMe(body.toString());
                  postData(body);
                },
              ),
              spacer(16.0),
            ],
          ),
        ));
  }

  postData(Map<String, dynamic> body) async {
    try {
      ProgressDialog progressDialog =
          ProgressDialog(context, message: const Text("Sending data..."), title: const Text("Processing"));
      ProgressDialog progressDialog1 = ProgressDialog(context,
          message: const Text("Error occurred on the server side"), title: const Text("Ohhh.."));
      progressDialog.show();
      // make request
      Response response = await post(Uri.parse(ApiConstants.createCustomer), body: body);
      String raw = response.body;
      printMe(raw);
      if (response.body == "success") {
        progressDialog.dismiss();
        Navigator.pop(context);
        setState(() {});
      } else {
        progressDialog.dismiss();
        progressDialog1.show();
      }
    } catch (e) {
      printMe(e.toString());
    }
  }
}
