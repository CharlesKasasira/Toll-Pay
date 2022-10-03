import 'package:flutter/material.dart';
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

  LocationData? currentLocation;

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );
    print("Reached herer");
    print(currentLocation);
  }

  void initState() {
    // getPolyPoints();
    getCurrentLocation();
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  final List<Marker> _markers = <Marker>[
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(0.0451, 32.4427),
        infoWindow: InfoWindow(
          title: 'Entebbe Toll',
        )),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: const BackButton(
          color: Colors.black, // <-- SEE HERE
          // onPressed: () { Scaffold.of(context).openDrawer(); }
        ),
        title: Text("Map"),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        markers: {
          const Marker(
              markerId: MarkerId('1'),
              position: LatLng(0.0451, 32.4427),
              infoWindow: InfoWindow(
                title: 'Entebbe Toll',
              ))
        },
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
