import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friday_v/Constants/api_constants.dart';
import 'package:friday_v/model/location.dart';
import 'package:friday_v/model/org.dart';
import 'package:friday_v/service/job_service.dart';
import 'package:friday_v/service/user_service.dart';
import 'package:friday_v/utils/colors.dart';
import 'package:friday_v/utils/size_config.dart';
import 'package:friday_v/widgets/sizebox_spacer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:ndialog/ndialog.dart';
import '../../Debug/printme.dart';
import '../../widgets/map_bottom_sheet.dart';
import '../../widgets/top_bar.dart';

class NewJob extends StatefulWidget {
  const NewJob({super.key});

  @override
  NewJobState createState() => NewJobState();
}

class NewJobState extends State<NewJob> with TickerProviderStateMixin {
  late GoogleMapController _controller;
  static const LatLng initialLocation = LatLng(-36.502181, 145.483975);

  //Initial Camera position
  static const CameraPosition _kGooglePlex = CameraPosition(target: initialLocation, zoom: 5.4746);

  //ViewModels for API responses
  List<OrganizationModel> data = [];
  List<Site> site = [];
  OrganizationModel? dropdownValue;
  String? initialValue = '';

  //Parameters
  int? orgID = 0, jobID = 0, siteID = 0;
  String? repName = "";
  String siteLatLng = "";

  //Job Dropdown
  List<JobType> jobList = [];
  JobType? jobValue;

  final Location location = Location();

  PermissionStatus? _permissionGranted;

  LocationData? _location;
  String? _error;
  String id = '1';

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
          position: initialLocation,
          infoWindow: const InfoWindow(title: "Please select the organization"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          consumeTapEvents: true,
          onTap: () {})
    };
  }

  late BitmapDescriptor pinLocationIcon;

  Set<Marker> _createMarker(List<Site> marker) {
    return marker
        .map((Site data) => Marker(
            markerId: MarkerId(data.siteId!),
            position: LatLng(double.parse(data.siteLat!), double.parse(data.siteLng!)),
            infoWindow: InfoWindow(title: data.siteAddress),
            icon: pinLocationIcon,
            consumeTapEvents: true,
            onTap: () {
              FocusScope.of(context).unfocus();
              printMe("Site address is : ${data.siteAddress}");
              showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  isDismissible: true,
                  context: context,
                  builder: (context) => MapBottomSheet(
                        marker: data,
                        organization: dropdownValue,
                        onPressed: (id, address, site) {
                          siteID = id;
                          siteLatLng = '${site.siteLat!},${site.siteLng!}';
                          validateFields();
                          Navigator.pop(context);
                        },
                      )).then((value) => printMe("Value is : ${value.toString()}"));
            }))
        .toSet();
  }

  LatLngBounds _createBounds(List<LatLng> positions) {
    final southwestLat =
        positions.map((p) => p.latitude).reduce((value, element) => value < element ? value : element); // smallest
    final southwestLon =
        positions.map((p) => p.longitude).reduce((value, element) => value < element ? value : element);
    final northeastLat =
        positions.map((p) => p.latitude).reduce((value, element) => value > element ? value : element); // biggest
    final northeastLon =
        positions.map((p) => p.longitude).reduce((value, element) => value > element ? value : element);
    return LatLngBounds(southwest: LatLng(southwestLat, southwestLon), northeast: LatLng(northeastLat, northeastLon));
  }

  LatLngBounds _bounds(Set<Marker> markers) {
    return _createBounds(markers.map((m) => m.position).toList());
  }

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
    _checkPermissions();

    UserService().getID().then((value) {
      id = value;
    });
    super.initState();
  }

  void setCustomMapPin() async {
    pinLocationIcon =
        await BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 1.5), 'assets/marker.png');
  }

  Future<void> _checkPermissions() async {
    final PermissionStatus permissionGrantedResult = await location.hasPermission();
    setState(() {
      _permissionGranted = permissionGrantedResult;
    });
    switch (permissionGrantedResult) {
      case PermissionStatus.denied:
      case PermissionStatus.deniedForever:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) => AlertDialog(
              title: const Text('Puppy needs your location'),
              content: const Text(
                  'Puppy collects location data to enable P, ["feature"], & ["feature"] even when the app is closed or not in use'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Deny'),
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
                TextButton(
                  child: const Text('Allow'),
                  onPressed: () => _requestPermission(),
                ),
              ],
            ),
          );
        });
        break;
      default:
        _getLocation();
        break;
    }
  }

  Future<void> _getLocation() async {
    try {
      final LocationData locationResult = await location.getLocation();
      _location = locationResult;
      siteLatLng = "${_location!.latitude},${_location!.longitude}";
      printMe("Location latitude or longitude : ${_location!.latitude}  ${_location!.longitude}");
    } on PlatformException catch (err) {
      _error = err.code;
      printError("Location error is : ${_error!}");
    }
  }

  Future<void> _requestPermission() async {
    if (_permissionGranted != PermissionStatus.granted) {
      final PermissionStatus permissionRequestedResult = await location.requestPermission();
      setState(() {
        _permissionGranted = permissionRequestedResult;
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopBar(appBar: AppBar(), title: "New Job", leading: true),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            children: [
              spacer(16.0),
              //Organization widget
              Text("Organization", style: body2.copyWith(color: secondaryDark)),
              spacer(8.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: white,
                    border: Border.all(color: borderColor, width: 2.0)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<OrganizationModel>(
                    dropdownColor: white,
                    iconEnabledColor: secondaryDark,
                    hint: Text("Select Organization",
                        style: body1.copyWith(fontFamily: "RedHatDisplay", color: Colors.grey)),
                    value: dropdownValue,
                    isDense: true,
                    isExpanded: true,
                    style: body1.copyWith(color: Colors.white),
                    onChanged: (OrganizationModel? newValue) {
                      dropdownValue = newValue;
                      initialValue = dropdownValue?.firstName;
                      repName = initialValue;
                      orgID = int.parse(dropdownValue!.orgId!);

                      JobService().getSites(dropdownValue!.orgId!).then((value) => setState(() {
                            site = value;
                            _controller.animateCamera(CameraUpdate.newLatLngBounds(_bounds(_createMarker(site)), 100));
                          }));
                    },
                    items: data.map((OrganizationModel user) {
                      return DropdownMenuItem<OrganizationModel>(
                        value: user,
                        child: Text(
                          user.orgName!.toString(),
                          style: body1.copyWith(fontFamily: "RedHatDisplay", color: secondaryDark),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              spacer(16.0),
              //Site Representative widget
              Text("Site Representative", style: body2.copyWith(color: secondaryDark)),
              spacer(8.0),
              TextField(
                onChanged: (s) => repName = s,
                controller: TextEditingController()..text = initialValue ?? '',
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
                    hintText: "Site Representative Name",
                    hintStyle: const TextStyle(color: Colors.grey)),
              ),
              spacer(16.0),
              //Job type widget
              Text("Job type", style: body2.copyWith(color: secondaryDark)),
              spacer(8.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: white,
                    border: Border.all(color: borderColor, width: 2.0)),
                child: DropdownButtonHideUnderline(
                  key: const Key("job_dropdown"),
                  child: DropdownButton<JobType>(
                    dropdownColor: white,
                    iconEnabledColor: secondaryDark,
                    hint: Text("Select Job", style: body1.copyWith(fontFamily: "RedHatDisplay", color: Colors.grey)),
                    value: jobValue,
                    isDense: true,
                    isExpanded: true,
                    style: body1.copyWith(color: Colors.white),
                    onChanged: (JobType? newValue) {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        jobValue = newValue;
                        jobID = int.parse(jobValue!.typeID!);
                      });
                    },
                    items: jobList.map((JobType user) {
                      return DropdownMenuItem<JobType>(
                        value: user,
                        child: Text(
                          user.typeName!.toString(),
                          style: body1.copyWith(fontFamily: "RedHatDisplay", color: secondaryDark),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              spacer(16.0),
              //Site Location widget
              Text("Site Location", style: body2.copyWith(color: secondaryDark)),
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
                      myLocationEnabled: true,
                      trafficEnabled: true,
                      markers: site.isEmpty ? _mainMarker() : _createMarker(site),
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
            ],
          ),
        ));
  }

  checkExist(Map<String, dynamic> body) async {
    printMe(body.toString());
    try {
      ProgressDialog progressDialog =
          ProgressDialog(context, message: const Text("Verifying sessions..."), title: const Text("Processing"));
      ProgressDialog progressDialog1 = ProgressDialog(context,
          message: const Text("You have an active session in this organization"), title: const Text("Ohhh.."));
      progressDialog.show();

      //Make request
      Response response = await post(Uri.parse(ApiConstants.openSession), body: body);
      printMe("Status Code is : ${response.statusCode}");
      printMe("Response is : ${response.body}");
      if (response.statusCode == 200) {
        if (response.body == "failed") {
          progressDialog.dismiss();
          postData(body);
        } else {
          Navigator.pop(context);
          progressDialog.dismiss();
          progressDialog1.show();
        }
      } else {
        throw Exception('Received status code ${response.statusCode}');
      }
    } catch (e, r) {
      printError("Error : ${e.toString()}");
      printError(r.toString());
      return [];
    }
  }

  postData(Map<String, dynamic> body) async {
    try {
      ProgressDialog progressDialog =
          ProgressDialog(context, message: const Text("Sending data..."), title: const Text("Progressing"));
      ProgressDialog progressDialog1 = ProgressDialog(context,
          message: const Text("Error occurred on the server side"), title: const Text("Ohhh.."));
      progressDialog.show();

      //Make request
      Response response = await post(Uri.parse(ApiConstants.createLog), body: body);
      printMe("Status Code is : ${response.statusCode}");
      printMe("Response is : ${response.body}");
      if (response.statusCode == 200) {
        if (response.body == "success") {
          progressDialog.dismiss();
          Navigator.pop(context);
          setState(() {});
        } else {
          progressDialog.dismiss();
          progressDialog1.show();
        }
      } else {
        throw Exception('Received status code ${response.statusCode}');
      }
    } catch (e, r) {
      printError("Error : ${e.toString()}");
      printError(r.toString());
      return [];
    }
  }

  Future<void> validateFields() async {
    Map<String, dynamic> body = {
      'org_name': orgID.toString(),
      'site_address': siteID.toString(),
      'job_type': jobID.toString(),
      'rep_name': repName,
      'lat_lng': siteLatLng,
      'user_id': id
    };

    validate()
        ? checkExist(body)
        : const NAlertDialog(
            title: Text("Oops!"),
            content: Text("Are you missing something?"),
            blur: 2,
          ).show(context, transitionType: DialogTransitionType.Bubble);
  }

  validate() {
    if (orgID == 0) {
      return false;
    }
    if (siteID == 0) {
      return false;
    }
    if (jobID == 0) {
      return false;
    }
    if (repName == '') {
      return false;
    }
    return true;
  }
}
