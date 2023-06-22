import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friday_v/Navigation_drawer/drawer.dart';
import 'package:friday_v/model/location.dart';
import 'package:friday_v/model/org.dart';
import 'package:friday_v/service/config.dart';
import 'package:friday_v/service/job_service.dart';
import 'package:friday_v/service/user_service.dart';
import 'package:friday_v/utils/colors.dart';
import 'package:friday_v/utils/size_config.dart';
import 'package:friday_v/widgets/atoms.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:ndialog/ndialog.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
import 'dart:io' show Platform;

class customer_onsite extends StatefulWidget {
  static const String routeName = '/customer_onsite';
  @override
  meetingsite createState() => meetingsite();
}

class meetingsite extends State<customer_onsite> with TickerProviderStateMixin {

  /*
  * Map functionality
  */

  //Onload initialization
  late GoogleMapController _controller;
  static final LatLng InitialLocation = LatLng(-36.502181, 145.483975);

  final company = TextEditingController();
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final emails = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final latitute = TextEditingController();
  final longitute = TextEditingController();

  List<Marker> _markers = <Marker>[];
  final Set<Marker> _marker = {};


  //Initial Camera position
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: InitialLocation,
    zoom: 5.4746,
  );

  String Address="search";

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
  Set<Marker> _mainMarker() {
    return <Marker>{
      Marker(
          markerId: const MarkerId("Empty"),
          position: InitialLocation,
          infoWindow: InfoWindow(title: "Please select the organization"),
          icon:
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          consumeTapEvents: true,
          onTap: () {
          })
    };
  }
  late BitmapDescriptor pinLocationIcon;

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 1.5), 'assets/marker.png');
  }
  Set<Marker> _createMarker(List<Site> marker) {
    return marker
        .map((Site data) => Marker(
        markerId: MarkerId(data.siteId!),
        position: LatLng(
            double.parse(data.siteLat!), double.parse(data.siteLng!)),
        infoWindow: InfoWindow(title: data.siteAddress),
        icon: pinLocationIcon,
        consumeTapEvents: true,
        onTap: () {
          FocusScope.of(context).unfocus();
          showModalBottomSheet(
              backgroundColor: Colors.transparent,
              isDismissible: true,
              context: context,
              builder: (context) => MapBottomSheet(
                marker: data,
                organization: dropdownValue,
                onPressed: (id, address, site) {
                  siteID = id;
                  siteLatLng = site.siteLat! + ',' + site.siteLng!;
                 // validateFields();
                  Navigator.pop(context);
                },
              )).then((value) => print("data"));
        }))
        .toSet();
  }

  LatLngBounds _createBounds(List<LatLng> positions) {
    final southwestLat = positions.map((p) => p.latitude).reduce(
            (value, element) => value < element ? value : element); // smallest
    final southwestLon = positions
        .map((p) => p.longitude)
        .reduce((value, element) => value < element ? value : element);
    final northeastLat = positions.map((p) => p.latitude).reduce(
            (value, element) => value > element ? value : element); // biggest
    final northeastLon = positions
        .map((p) => p.longitude)
        .reduce((value, element) => value > element ? value : element);
    return LatLngBounds(
        southwest: LatLng(southwestLat, southwestLon),
        northeast: LatLng(northeastLat, northeastLon));
  }

  LatLngBounds _bounds(Set<Marker> markers) {
    return _createBounds(markers.map((m) => m.position).toList());
  }

  //ViewModels for API responses
  List<OrganizationModel> data = [];
  List<Site> site = [];
  OrganizationModel? dropdownValue;
  String? initialValue = '';

  //Parameters
  int? OrgID = 0, jobID = 0, siteID = 0;
  String? repName = "";
  double? lat=0;
  double? long=0;
  String user_id = "", siteLatLng = "";

  //Job Dropdown
  List<JobType> jobList = [];
  JobType? jobValue;

  //final Location location = Location();

  PermissionStatus? _permissionGranted;
  bool _loading = false;

  LocationData? _location;
  String? _error;
  String id = '1';

  @override
  void initState() {
    JobService().getOrgs().then((value) {
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
          title: Text("customer onsite"),
          // leading: true,
        ),
        drawer: NavDrawer(),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            children: [
              spacer(8.0),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
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
                      borderSide: BorderSide(
                          color: primaryLite.withOpacity(0.8), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                      const BorderSide(color: borderColor, width: 2.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 8.0),
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
                      borderSide: BorderSide(
                          color: primaryLite.withOpacity(0.8), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                      const BorderSide(color: borderColor, width: 2.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 8.0),
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
                      borderSide: BorderSide(
                          color: primaryLite.withOpacity(0.8), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                      const BorderSide(color: borderColor, width: 2.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 8.0),
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
                      borderSide: BorderSide(
                          color: primaryLite.withOpacity(0.8), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                      const BorderSide(color: borderColor, width: 2.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 8.0),
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
                      borderSide: BorderSide(
                          color: primaryLite.withOpacity(0.8), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                      const BorderSide(color: borderColor, width: 2.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 8.0),
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
                      borderSide: BorderSide(
                          color: primaryLite.withOpacity(0.8), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                      const BorderSide(color: borderColor, width: 2.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 8.0),
                    hintText: "Address",
                    hintStyle: const TextStyle(color: Colors.grey)),
              ),
              spacer(8.0),
             // double.parse(productprice.toString())
              Text(
                'lat',
                style: body2.copyWith(color: secondaryDark),
              ),
              TextField(
                onChanged: (s)  => lat =   s.toString() as double? ,
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
                      borderSide: BorderSide(
                          color: primaryLite.withOpacity(0.8), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                      const BorderSide(color: borderColor, width: 2.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 8.0),
                    hintText: "Lat",
                    hintStyle: const TextStyle(color: Colors.grey)),
              ),

              Text(
                "Long",
                style: body2.copyWith(color: secondaryDark),
              ),
              TextField(
                onChanged: (s) =>  long.toString(),
                controller: longitute,
                //controller: TextEditingController()..text = long.toString(),
                style: body1.copyWith(color: secondaryDark),
                decoration: InputDecoration(
                    filled: true,
                    isDense: true,
                    fillColor: white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: primaryLite.withOpacity(0.8), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                      const BorderSide(color: borderColor, width: 2.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 8.0),
                    hintText: "Long",
                    hintStyle: const TextStyle(color: Colors.grey)),
              ),

              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
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
                    child: GoogleMap(markers: _marker,
                    //site == null ? _mainMarker() : _createMarker(site),
                      onTap: (LatLng latLng) async {
                        // _marker.clear();
                        _marker.add(Marker(
                          markerId: MarkerId(latLng.toString()),
                          position: latLng,
                          infoWindow: InfoWindow(
                            title: 'I am a marker',
                          ),
                          icon:
                          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                        ));
                         lat = latLng.latitude;
                         long = latLng.longitude;
                         latitute.text=lat.toString();
                         longitute.text=long.toString();
                         print(lat);
                         print(long);

                        // List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude,latLng.longitude);
                        // print(placemarks);
                        // Placemark place = placemarks[0];
                        // Address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
                        // print(Address);
                        address.text=Address;

                         setState(() {
                           //_marker.remove(_marker);
                         }
                         );
                        // _markers.add(Marker(
                        //   markerId: MarkerId(latLng.toString()),
                        //   position: latLng,
                        //   infoWindow: InfoWindow(
                        //     title: 'I am a marker',
                        //   ),
                        //   icon:
                        //   BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
                        // ));
                      },
                    myLocationEnabled: true,
                      trafficEnabled: true,
                      scrollGesturesEnabled: true,
                      myLocationButtonEnabled: true,
                      mapType: MapType.normal,
                      initialCameraPosition: _kGooglePlex,
                      gestureRecognizers: Set()
                        ..add(Factory<PanGestureRecognizer>(
                                () => PanGestureRecognizer())),
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
                    //Navigator.pop(context);
                    Map<String, dynamic> body = {
                      'org_name':company.text,
                      'rep_first_name':firstname.text,
                      'rep_last_name':lastname.text,
                      'email':emails.text,
                      'phone':phone.text,
                      'address':address.text,
                      'lat':lat.toString(),
                      'lng':long.toString(),
                    };
                    print(body.toString());
                    postData(body);
                  },
              ),
              spacer(16.0),
            ],
          ),
        )

    );


  }


  postData(Map<String, dynamic> body) async {
    try {
      ProgressDialog progressDialog = ProgressDialog(context,
          message: Text("Sending data..."), title: Text("Processing"));
      ProgressDialog progressDialog1 = ProgressDialog(context,
          message: Text("Error occurred on the server side"),
          title: Text("Ohhh.."));
      progressDialog.show();
      // make request
      Response response =
      await post(Uri.parse(URLHelper.create_customer), body: body);
      String raw = response.body;
      print(raw);
      if (response.body == "success") {
        progressDialog.dismiss();
        Navigator.pop(context);
        setState(() {});
      } else {
        progressDialog.dismiss();
        progressDialog1.show();
      }
    }
    catch (e) {
      print(e.toString());
    }
  }
  // validate() {
  //   if (OrgID == 0) {
  //     return false;
  //   }
  //   if (siteID == 0) {
  //     return false;
  //   }
  //   if (jobID == 0) {
  //     return false;
  //   }
  //   if (repName == '') {
  //     return false;
  //   }
  //   return true;
  // }
}