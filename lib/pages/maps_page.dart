import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MyMap extends StatefulWidget {
  const MyMap({Key? key}) : super(key: key);

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(0.0451, 32.4427);

  final Set<Marker> _markers = <Marker>{
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(0.0451, 32.4427),
        infoWindow: InfoWindow(
          title: 'Entebbe Toll',
        )),
        
  };

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    // print("this is the position ${position}");
    _markers.add(Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(
          title: 'You',
        )),);

    setState(() {});

    return position;
  }

  // Position position =  Geolocator.getCurrentPosition();

  // LatLng currentLatLng;
  // Completer<GoogleMapController> _controller = Completer();

  LocationData? currentLocation;

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );
    // print("Reached herer");
    // print(currentLocation);
  }

  void initState() {
    // getPolyPoints();
    _determinePosition();
    getCurrentLocation();
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    print("the markers are");
    print(_markers);
    int count = 0;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: Container(
          width: 25,
          height: 25,
          margin: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(25))),
          child: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () =>
                Navigator.of(context).popUntil((_) => count++ >= 2),
          ),
        ),
        // title: Text("Map"),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        // markers: {
        //   const Marker(
        //       markerId: MarkerId('1'),
        //       position: LatLng(0.0451, 32.4427),
        //       infoWindow: InfoWindow(
        //         title: 'Entebbe Toll',
        //       )),
        //   const Marker(
        //       markerId: MarkerId('2'),
        //       position: LatLng(0.0351, 32.4427),
        //       infoWindow: InfoWindow(
        //         title: 'Entebbe Toll',
        //       )),
        // },
        markers: _markers,
        myLocationEnabled: true,
        compassEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
      ),
    );
  }
}
