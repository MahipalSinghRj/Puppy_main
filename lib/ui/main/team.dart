import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friday_v/model/team.dart';
import 'package:friday_v/provider/ui/rest.dart';
import 'package:friday_v/service/team_service.dart';
import 'package:friday_v/utils/colors.dart';
import 'package:friday_v/widgets/atoms.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as IMG;

import 'dart:io' show Platform;

class Teams extends StatefulWidget {
  @override
  _TeamsState createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  late GoogleMapController _controller;

  // final LatLng _center = const LatLng(45.521563, -122.677433);


  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    changeMapMode();
    debugPrint('markers length${markers.length}');
    // _controller.animateCamera(CameraUpdate.newLatLngBounds(_bounds(markers.toSet()), 50));
    Future.delayed(const Duration(seconds: 200),(){
      _controller.animateCamera(CameraUpdate.newLatLngBounds(_bounds(markers.toSet()), 50));
      setState(() {

      });
    });
    setState(() {});

  }

  late BitmapDescriptor pinLocationIcon;
  String token = "";

  List<TeamModel> teamModel = [];
  List<Marker> markers =[];

  List<BitmapDescriptor> mapIcons = [];

  // setCustomMapPin(TeamModel mod) async {
  //   //Get profile picture using the ID from graph API
  //   //TODO: GET https://graph.microsoft.com/v1.0/users/{id | userPrincipalName}
  //
  //   // mod.userId
  //
  //   pinLocationIcon = await BitmapDescriptor.fromAssetImage(
  //       const ImageConfiguration(devicePixelRatio: 1.5), 'assets/marker.png');
  //
  //   return pinLocationIcon;
  // }

  setCustomMapPininitially() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 1.5), 'assets/marker.png');
  }

  // setCustomMapPin(String imgUrl) async {
  //   var bytes;
  //   try{
  //      bytes =
  //     (await http.get(
  //       Uri.parse(imgUrl),
  //       headers: {
  //         "Authorization": "Bearer $token",
  //       },
  //     ));
  //   }catch(e){
  //            print('error${e}');
  //   }
  //   Uint8List imageBytes =  bytes.bodyBytes.buffer.asUint8List();
  //
  //   //
  //   // Uint8List imageBytes =  bytes.bodyBytes.buffer.asUint8List();
  //   //   debugPrint('profiler$imageBytes');
  //   //   var img = IMG.decodeImage(imageBytes);
  //   //   debugPrint('profilepic$img');
  //   //   debugPrint('imgUrl profile$imgUrl');
  //   // late Uint8List resizedData;
  //   // if(img !=null){
  //   //     IMG.Image resized = IMG.copyResize(img, width: 50, height: 50);
  //   //      resizedData = Uint8List.fromList(IMG.encodePng(resized));
  //   //      pinLocationIcon = BitmapDescriptor.fromBytes(imageBytes);
  //   //   }
  //   pinLocationIcon = BitmapDescriptor.fromBytes(imageBytes);
  //     mapIcons.add(pinLocationIcon);
  //     setState(() {
  //       debugPrint('mapIcons${mapIcons.length}');
  //     });
  //
  // }

  setCustomMapPin(List<TeamModel> data) async {

    debugPrint('token${token}');
    for(var i = 0;i<data.length;i++){

      debugPrint('imgUrl${data[i].imgUrl}');
      http.Response response = await http.get(
        Uri.parse(data[i].imgUrl),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      debugPrint('response${response.statusCode}');
      debugPrint('response${response.bodyBytes.buffer.asUint8List()}');
      if(response.statusCode==200){
        Uint8List imageBytes =  response.bodyBytes.buffer.asUint8List();
        var img = IMG.decodeImage(imageBytes);
        IMG.Image resized = IMG.copyResize(img!, width: 80, height: 80);
        Uint8List resizedData = Uint8List.fromList(IMG.encodePng(resized));
        pinLocationIcon = BitmapDescriptor.fromBytes(resizedData);
        mapIcons.add(pinLocationIcon);
      }
      else{
        mapIcons.add(BitmapDescriptor.defaultMarker);
      }

    }
    // Uint8List imageBytes =  bytes.bodyBytes.buffer.asUint8List();
    //   debugPrint('profiler$imageBytes');
    //   var img = IMG.decodeImage(imageBytes);
    //   debugPrint('profilepic$img');
    //   debugPrint('imgUrl profile$imgUrl');
    // late Uint8List resizedData;
    // if(img !=null){
    //     IMG.Image resized = IMG.copyResize(img, width: 50, height: 50);
    //      resizedData = Uint8List.fromList(IMG.encodePng(resized));
    //      pinLocationIcon = BitmapDescriptor.fromBytes(imageBytes);
    //   }
    // pinLocationIcon = BitmapDescriptor.fromBytes(imageBytes);
    // mapIcons.add(pinLocationIcon);
    setState(() {
      debugPrint('mapIcons${mapIcons.length}');
    });

  }


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

  final Location location = Location();
  LocationData? _location;

  PermissionStatus? _permissionGranted;

  Future<void> _checkPermissions() async {
    final PermissionStatus permissionGrantedResult =
        await location.hasPermission();
    setState(() {
      _permissionGranted = permissionGrantedResult;
    });
    switch (permissionGrantedResult) {
      case PermissionStatus.denied:
      case PermissionStatus.deniedForever:
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text('Puppy needs your location'),
                  content: const Text(
                      'This app collects location data to provide GPS information to the Smart-tech portal in the background even when the app is closed or not in use'),
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

  Future<void> _requestPermission() async {
    if (_permissionGranted != PermissionStatus.granted) {
      final PermissionStatus permissionRequestedResult =
          await location.requestPermission();
      setState(() {
        _permissionGranted = permissionRequestedResult;
      });
      Navigator.of(context).pop();
    }
  }

  LatLng _center = const LatLng(-37.9716929, 144.7729576);

  Future<void> _getLocation() async {
    try {
      final LocationData _locationResult = await location.getLocation();
      _location = _locationResult;
      setState(() {
        _center = LatLng(_location!.latitude!, _location!.longitude!);
      });

      print("============> " +
          _location!.latitude.toString() +
          "  " +
          _location!.longitude.toString());
    } on PlatformException catch (err) {
      print("============> " + err.code);
    }
  }



  @override
  void initState() {
    super.initState();
    _checkPermissions();
    setCustomMapPininitially();
    getToken();
    TeamService().getTeamLocation().then((value) =>
    {teamModel = value,
      setCustomMapPin(teamModel).then((value){
        _createMarker(teamModel);
      }),
    }
    );

  }
  void getToken(){
    final user_data = Provider.of<UserProvider>(context,listen: false);
    token = user_data.post.odataContext;
  }

  _createMarker(List<TeamModel> marker)   {
    for(var i = 0;i<marker.length;i++){
      final latlng = marker[i].inLatLng.split(",");
      String lat = latlng[0];
      String lng = latlng[1];
      markers.add( Marker(
            markerId: MarkerId(marker[i].siteId),
            position: LatLng(double.parse(lat), double.parse(lng)),
            // infoWindow: InfoWindow(title: data.siteAddress),
            // icon: setCustomMapPin(data)??pinLocationIcon,
            icon: mapIcons[i],
            consumeTapEvents: true,
            onTap: () {
              FocusScope.of(context).unfocus();
              showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  isDismissible: true,
                  context: context,
                  builder: (context) => DetailSheet(
                    teamModel: marker[i],
                  )).then((value) => print("data"));
            }));
      debugPrint('markers position${markers[i].position}');

    }
    setState(() {
    debugPrint('markers${markers.length}');
    _controller.animateCamera(CameraUpdate.newLatLngBounds(_bounds(markers.toSet()), 50));
    });
    // return marker.map((TeamModel data) {
    //   final latlng = data.inLatLng.split(",");
    //   String lat = latlng[0];
    //   String lng = latlng[1];
    //   setCustomMapPin(data);
    //   return
    //     Marker(
    //       markerId: MarkerId(data.siteId),
    //       position: LatLng(double.parse(lat), double.parse(lng)),
    //       // infoWindow: InfoWindow(title: data.siteAddress),
    //       // icon: setCustomMapPin(data)??pinLocationIcon,
    //       icon: pinLocationIcon,
    //       consumeTapEvents: true,
    //       onTap: () {
    //         FocusScope.of(context).unfocus();
    //         showModalBottomSheet(
    //             backgroundColor: Colors.transparent,
    //             isDismissible: true,
    //             context: context,
    //             builder: (context) => DetailSheet(
    //                   teamModel: data,
    //                 )).then((value) => print("data"));
    //       });
    // }).toSet();

  }

  LatLngBounds _createBounds(List<LatLng> positions) {

    print('positions bound${positions.length}');
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
    print('markers bound${markers.length}');
    return _createBounds(markers.map((m) => m.position).toList());
  }

  Set<Marker> _mainMarker() {
    return <Marker>{
      Marker(
          markerId: const MarkerId("Empty"),
          position: _center,
          infoWindow: InfoWindow(title: "Please select the organization"),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          consumeTapEvents: true,
          onTap: () {})
    };
  }

  @override
  Widget build(BuildContext context) {
    final user_data = Provider.of<UserProvider>(context);
    token = user_data.post.odataContext;
    return Scaffold(
      appBar: TopBar(
        title: 'Teams',
        appBar: AppBar(),
      ),
      body: SafeArea(
        child:
        GoogleMap(
          myLocationEnabled: true,
          trafficEnabled: true,
          // markers: teamModel == [] ? _mainMarker() : _createMarker(teamModel),
          markers: teamModel == [] ? _mainMarker() : markers.toSet(),
          // markers:  _createMarker(teamModel),
          scrollGesturesEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 10.0,
          ),
        )
        // const Center(child: CircularProgressIndicator(),),
      ),
    );
  }
}
/*
GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 10.0,
          ),
        )
* */

class DetailSheet extends StatefulWidget {
  final TeamModel teamModel;

  const DetailSheet({Key? key, required this.teamModel}) : super(key: key);

  @override
  _DetailSheetState createState() => _DetailSheetState();
}

class _DetailSheetState extends State<DetailSheet> {
  @override
  Widget build(BuildContext context) {
    final user_data = Provider.of<UserProvider>(context);
    final token = user_data.post.odataContext;
    final userID = user_data.post.id;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 16.0),
              height: 4,
              width: 48,
              decoration: BoxDecoration(
                  color: secondaryLite,
                  borderRadius: BorderRadius.circular(4.0)),
            ),
          ),
          user_data.loading
              ? const Center(child: CircularProgressIndicator())
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user_data.post.displayName,
                          style: title.copyWith(
                              color: black, fontWeight: FontWeight.w700),
                        ),
                        Space(size: 8),
                        Text(user_data.post.jobTitle,
                            style: body1.copyWith(
                                color: subTextColor,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(56),
                      child: FadeInImage(
                        image: NetworkImage(
                          "https://graph.microsoft.com/v1.0/users/$userID/photo/\$value",
                          headers: {
                            "Authorization": "Bearer $token",
                          },
                        ),
                        imageErrorBuilder: (BuildContext context,
                            Object exception, StackTrace? stackTrace) {
                          return Image.asset('assets/images/404.png');
                        },
                        placeholder: AssetImage("assets/images/404.png"),
                        height: 56,
                        width: 56,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ],
                ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.teamModel.orgName,
                style:
                    title.copyWith(color: black, fontWeight: FontWeight.w700),
              ),
              status(widget.teamModel.inBreak)
            ],
          ),
          Space(size: 4),
          Text(widget.teamModel.siteAddress,
              style: body1.copyWith(
                  color: subTextColor, fontWeight: FontWeight.w500)),
          Space(size: 16),
          Text(widget.teamModel.typeName,
              style: body1.copyWith(color: black, fontWeight: FontWeight.w500)),
          Space(size: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              timings("Time In", widget.teamModel.inTime),
              Container(
                width: 1,
                height: 50,
                color: Colors.grey,
              ),
              // timings("Time Out", widget.teamModel.outTime),
              // Container(
              //   width: 1,
              //   height: 50,
              //   color: Colors.grey,
              // ),
              timings("Duration", widget.teamModel.totalTime)
            ],
          ),
          Space(size: 16),
        ],
      ),
    );
  }

  Container timings(String label, String time) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              body1.copyWith(color: subTextColor, fontWeight: FontWeight.w500),
        ),
        Space(size: 8.0),
        Text(
          time,
          style: body1.copyWith(color: black, fontWeight: FontWeight.w500),
        ),
      ],
    ));
  }

  Container status(String id) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: id == '0'
              ? green.withOpacity(0.1)
              : primaryDark.withOpacity(0.1)),
      child: Text(
        id == '0' ? "Active" : "Inactive",
        style: body2.copyWith(
            color: id == '0' ? green : primaryDark,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false);
    user.getUserByID(context, widget.teamModel.userId);
  }
}
