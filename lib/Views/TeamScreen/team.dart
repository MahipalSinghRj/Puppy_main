import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friday_v/model/team.dart';
import 'package:friday_v/provider/ui/rest.dart';
import 'package:friday_v/service/team_service.dart';
import 'package:friday_v/widgets/sizebox_spacer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as IMG;
import '../../Debug/printme.dart';
import '../../widgets/top_bar.dart';
import 'detail_sheet.dart';

class Teams extends StatefulWidget {
  const Teams({super.key});

  @override
  TeamsState createState() => TeamsState();
}

class TeamsState extends State<Teams> {
  late GoogleMapController _controller;

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    changeMapMode();
    debugPrint('markers length${markers.length}');
    Future.delayed(const Duration(seconds: 200), () {
      _controller.animateCamera(CameraUpdate.newLatLngBounds(_bounds(markers.toSet()), 50));
      setState(() {});
    });
    setState(() {});
  }

  late BitmapDescriptor pinLocationIcon;
  String token = "";

  List<TeamModel> teamModel = [];
  List<Marker> markers = [];

  List<BitmapDescriptor> mapIcons = [];

  setCustomMapPininitially() async {
    pinLocationIcon =
        await BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 1.5), 'assets/marker.png');
  }

  setCustomMapPin(List<TeamModel> data) async {
    debugPrint('Token is : $token');
    for (var i = 0; i < data.length; i++) {
      debugPrint('imgUrl${data[i].imgUrl}');
      http.Response response = await http.get(
        Uri.parse(data[i].imgUrl),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      debugPrint('response${response.statusCode}');
      debugPrint('response${response.bodyBytes.buffer.asUint8List()}');
      if (response.statusCode == 200) {
        Uint8List imageBytes = response.bodyBytes.buffer.asUint8List();
        var img = IMG.decodeImage(imageBytes);
        IMG.Image resized = IMG.copyResize(img!, width: 80, height: 80);
        Uint8List resizedData = Uint8List.fromList(IMG.encodePng(resized));
        pinLocationIcon = BitmapDescriptor.fromBytes(resizedData);
        mapIcons.add(pinLocationIcon);
      } else {
        mapIcons.add(BitmapDescriptor.defaultMarker);
      }
    }

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
    final PermissionStatus permissionGrantedResult = await location.hasPermission();
    setState(() {
      _permissionGranted = permissionGrantedResult;
    });

    BuildContext? localContext = context; // Create a local variable to hold the reference to the context

    switch (permissionGrantedResult) {
      case PermissionStatus.denied:
      case PermissionStatus.deniedForever:
        showDialog(
          context: localContext!,
          builder: (BuildContext dialogContext) => AlertDialog(
            title: const Text('Puppy needs your location'),
            content: const Text(
                'This app collects location data to provide GPS information to the Smart-tech portal in the background even when the app is closed or not in use'),
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
        break;
      default:
        _getLocation();
        break;
    }
  }

  Future<void> _requestPermission() async {
    if (_permissionGranted != PermissionStatus.granted) {
      final PermissionStatus permissionRequestedResult = await location.requestPermission();
      setState(() {
        _permissionGranted = permissionRequestedResult;
      });
      Navigator.of(context).pop();
    }
  }

  LatLng _center = const LatLng(-37.9716929, 144.7729576);

  Future<void> _getLocation() async {
    try {
      final LocationData locationResult = await location.getLocation();
      _location = locationResult;
      setState(() {
        _center = LatLng(_location!.latitude!, _location!.longitude!);
      });

      printMe("Location latitude and longitude of team : ${_location!.latitude}  ${_location!.longitude}");
    } on PlatformException catch (err) {
      printMe("Team location error is : ${err.code}");
    }
  }

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    setCustomMapPininitially();
    getToken();
    TeamService().getTeamLocation().then((value) => {
          teamModel = value,
          setCustomMapPin(teamModel).then((value) {
            _createMarker(teamModel);
          }),
        });
  }

  void getToken() {
    final userData = Provider.of<UserProvider>(context, listen: false);
    token = userData.post.odataContext;
  }

  _createMarker(List<TeamModel> marker) {
    for (var i = 0; i < marker.length; i++) {
      final latlng = marker[i].inLatLng.split(",");
      String lat = latlng[0];
      String lng = latlng[1];
      markers.add(Marker(
          markerId: MarkerId(marker[i].siteId),
          position: LatLng(double.parse(lat), double.parse(lng)),
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
                    )).then((value) => printMe("Value is : "));
          }));
      debugPrint('markers position${markers[i].position}');
    }
    setState(() {
      debugPrint('markers${markers.length}');
      _controller.animateCamera(CameraUpdate.newLatLngBounds(_bounds(markers.toSet()), 50));
    });
  }

  LatLngBounds _createBounds(List<LatLng> positions) {
    printMe('Positions bound : ${positions.length}');
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
    printMe('Markers bound is : ${markers.length}');
    return _createBounds(markers.map((m) => m.position).toList());
  }

  Set<Marker> _mainMarker() {
    return <Marker>{
      Marker(
          markerId: const MarkerId("Empty"),
          position: _center,
          infoWindow: const InfoWindow(title: "Please select the organization"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          consumeTapEvents: true,
          onTap: () {})
    };
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context);
    token = userData.post.odataContext;
    return Scaffold(
      appBar: TopBar(
        title: 'Teams',
        appBar: AppBar(),
      ),
      body: SafeArea(
          child: GoogleMap(
        myLocationEnabled: true,
        trafficEnabled: true,
        markers: teamModel == [] ? _mainMarker() : markers.toSet(),
        scrollGesturesEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 10.0,
        ),
      )),
    );
  }
}
