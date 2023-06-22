import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friday_v/model/location.dart';
import 'package:friday_v/model/org.dart';
import 'package:friday_v/service/config.dart';
import 'package:friday_v/service/customer_onsite.dart';
import 'package:friday_v/service/job_service.dart';
import 'package:friday_v/service/user_service.dart';
import 'package:friday_v/utils/colors.dart';
import 'package:friday_v/utils/size_config.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:friday_v/widgets/atoms.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:ndialog/ndialog.dart';
import 'dart:io' show Platform;

class NewMeeting extends StatefulWidget {
  @override
  _NewMeetingState createState() => _NewMeetingState();
}

class _NewMeetingState extends State<NewMeeting> with TickerProviderStateMixin {
  /*
  * Map functionality
  */

  //Onload initialization
  late GoogleMapController _controller;
  static final LatLng InitialLocation = LatLng(-36.502181, 145.483975);

  //Initial Camera position
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: InitialLocation,
    zoom: 5.4746,
  );

  var users;

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
          onTap: () {})
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
                  validateFields();
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
  String user_id = "", siteLatLng = "";

  //Job Dropdown
  List<JobType> jobList = [];
  JobType? jobValue;

  final Location location = Location();

  PermissionStatus? _permissionGranted;

  Future<void> _checkPermissions() async {
    final PermissionStatus permissionGrantedResult =
    await location.hasPermission();
    setState(() {
      _permissionGranted = permissionGrantedResult;
    });
    switch (permissionGrantedResult) {
      case PermissionStatus.denied:
      case PermissionStatus.deniedForever:showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Puppy needs your location'),
              content: const Text(
                  'Puppy collects location data to enable P, ["feature"], & ["feature"] even when the app is closed or not in use'),
              // +'This app collects location data to provide GPS information to the Smart-tech portal even when the app is closed or not in use'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Deny'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('Allow'),
                  onPressed: () => _requestPermission(),
                ),
              ],
            ));

        break;
        default:
        _getLocation();
        break;
    }
  }
  //svg.check

  Future<void> _requestPermission() async {
    if (_permissionGranted != PermissionStatus.granted) {
      final PermissionStatus permissionRequestedResult =
      await location.requestPermission();
      setState(() {
        _permissionGranted = permissionRequestedResult;
         Navigator.of(context).pop();
      });
    }
  }

  bool _loading = false;

  LocationData? _location;
  String? _error;
  String id = '1';

  Future<void> _getLocation() async {
    try {
      final LocationData _locationResult = await location.getLocation();
      _location = _locationResult;
      siteLatLng = _location!.latitude.toString() +
          "," +
          _location!.longitude.toString();
      print("============> " +
          _location!.latitude.toString() +
          "  " +
          _location!.longitude.toString());
    } on PlatformException catch (err) {
      _error = err.code;
      print("============> " + _error!);
    }
  }

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
    _checkPermissions();

    UserService().getID().then((value) {
      id = value;
    });
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List<OrganizationModel> data = [];
    List<Map<String, dynamic>> results = [];
    data.map((OrganizationModel) => users);
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users

      users.toString();
    } else {
      results = users.where((user) =>
          user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }
    // Refresh the UI
       setState(() {
      //_foundUsers = results;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopBar(
          appBar: AppBar(),
          title: "New Job",
          leading: true,

        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            children: [
              spacer(16.0),
              // DropdownSearch<OrganizationModel>(
              //   label: "Name",
              //   onFind: (filter) async => getData(filter),
              //   itemAsString: (OrganizationModel u) => u.userAsStringByName(),
              //   onChanged: (OrganizationModel data) => print(data),
              // ),
              //
              // DropdownSearch<String>(
              //   //mode of dropdown
              //   mode: Mode.DIALOG,
              //   //to show search box
              //   showSearchBox: true,
              //   showSelectedItems: true,
              //   //list of dropdown items
              //   items: [
              //     "India",
              //     "USA",
              //     "Brazil",
              //     "Canada",
              //     "Australia",
              //     "Singapore"
              //   ],
              //   label: "Country",
              //   onChanged: print,
              //   //show selected item
              //   selectedItem: "India",
              // ),

              // TextField(
              //   onChanged: (value) => _runFilter(value),
              //   decoration: const InputDecoration(
              //       labelText: 'Search', suffixIcon: Icon(Icons.search)),
              // ),

              Text(
                "Organization",
                style: body2.copyWith(color: secondaryDark),
              ),
              spacer(8.0),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                    color: white,
                    border: Border.all(color: borderColor, width: 2.0)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<OrganizationModel>(
                    dropdownColor: white,
                    iconEnabledColor: secondaryDark,
                    hint: Text("Select Organization",
                        style: body1.copyWith(
                            fontFamily: "RedHatDisplay", color: Colors.grey)),
                    value: dropdownValue,
                    isDense: true,
                    isExpanded: true,
                    style: body1.copyWith(color: Colors.white),
                    onChanged: (OrganizationModel? newValue) {
                      dropdownValue = newValue;
                      print(OrganizationModel);
                      initialValue = dropdownValue?.firstName;
                      repName = initialValue;
                      OrgID = int.parse(dropdownValue!.orgId!);

                      JobService()
                          .getSites(dropdownValue!.orgId!)
                          .then((value) => setState(() {
                        site = value;
                        _controller.animateCamera(
                            CameraUpdate.newLatLngBounds(
                                _bounds(_createMarker(site)), 100));
                      }));
                    },
                    items: data.map((OrganizationModel user) {
                      return DropdownMenuItem<OrganizationModel>(
                        value: user,
                        child: Text(user.orgName!.toString(),
                          style: body1.copyWith(
                              fontFamily: "RedHatDisplay",
                              color: secondaryDark),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              spacer(16.0),

              Text(
                "Site Representative",
                style: body2.copyWith(color: secondaryDark),
              ),
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
                    hintText: "Site Representative Name",
                    hintStyle: const TextStyle(color: Colors.grey)),
              ),
              spacer(16.0),
              Text(
                "Job type",
                style: body2.copyWith(color: secondaryDark),
              ),
              spacer(8.0),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: white,
                    border: Border.all(color: borderColor, width: 2.0)),
                child: DropdownButtonHideUnderline(
                  key: Key("job_dropdown"),
                  child: DropdownButton<JobType>(
                    dropdownColor: white,
                    iconEnabledColor: secondaryDark,
                    hint: Text("Select Job",
                        style: body1.copyWith(
                            fontFamily: "RedHatDisplay", color: Colors.grey)),
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
                          style: body1.copyWith(
                              fontFamily: "RedHatDisplay",
                              color: secondaryDark),
                        ),
                      );
                    }).toList(),
                  ),
                ),
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
                      myLocationEnabled: true,
                      trafficEnabled: true,
                      markers:
                      site == null ? _mainMarker() : _createMarker(site),
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
            ],
          ),
        ));
  }

  Future<void> validateFields() async {
    // User user = User.fromJson(await SharedPref().read("user"));
    // user_id = user..toString();
    Map<String, dynamic> body = {

//8608554911
      'org_name': OrgID.toString(),
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

  postData(Map<String, dynamic> body) async {
    try {
      ProgressDialog progressDialog = ProgressDialog(context,
          message: Text("Sending data..."), title: Text("Progressing"));
      ProgressDialog progressDialog1 = ProgressDialog(context,
          message: Text("Error occurred on the server side"),
          title: Text("Ohhh.."));
      progressDialog.show();
      // make request
      Response response =
      await post(Uri.parse(URLHelper.create_log), body: body);
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

  checkExist(Map<String, dynamic> body) async {
    // String content = json.encode(body);
    // print(content);
    print(body);
    try {
      ProgressDialog progressDialog = ProgressDialog(context,
          message: Text("Verifying sessions..."), title: Text("Processing"));
      ProgressDialog progressDialog1 = ProgressDialog(context,
          message: Text("You have an active session in this organization"),
          title: Text("Ohhh.."));
      progressDialog.show();
      // make request
      Response response =
      await post(Uri.parse(URLHelper.open_session), body: body);
      String raw = response.body;
      print(raw);
      if (response.body == "failed") {
        progressDialog.dismiss();
        postData(body);
      } else {
        Navigator.pop(context);

        progressDialog.dismiss();
        progressDialog1.show();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  validate() {
    if (OrgID == 0) {
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
//
// class Carousel extends StatefulWidget {
//   final Function(int) JobId;
//
//   const Carousel({
//     Key? key,
//     required this.JobId,
//   }) : super(key: key);
//
//   @override
//   _CarouselState createState() => _CarouselState();
// }
//
// class _CarouselState extends State<Carousel> {
//   int selectedItem = -1;
//
//   late Future<List<JobType>> futureList;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 40,
//       child: FutureBuilder<List<JobType>>(
//           future: fetchList(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState != ConnectionState.done) {}
//             if (snapshot.hasError) {}
//             List<JobType> jobs = snapshot.data ?? [];
//             return ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: jobs.length,
//                 shrinkWrap: true,
//                 physics: const BouncingScrollPhysics(),
//                 itemBuilder: (BuildContext context, int index) {
//                   JobType jobType = jobs[index];
//                   return Padding(
//                     padding: const EdgeInsets.only(right: 10),
//                     child: GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           selectedItem = index;
//                           widget.JobId(int.parse(jobType.typeID!));
//                         });
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                             borderRadius:
//                                 const BorderRadius.all(Radius.circular(10)),
//                             border: Border.all(
//                                 color: selectedItem == index
//                                     ? primaryLite
//                                     : borderColor,
//                                 width: 2.0),
//                             color:
//                                 selectedItem == index ? primaryColor : white),
//                         child: Stack(
//                           alignment: Alignment.topRight,
//                           children: [
//                             Center(
//                               child: Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 8.0),
//                                 child: Text(
//                                   jobType.typeName!,
//                                   style: body1.copyWith(
//                                       fontWeight: FontWeight.w400,
//                                       color: selectedItem == index
//                                           ? white
//                                           : secondaryDark),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 });
//           }),
//     );
//   }
// }
