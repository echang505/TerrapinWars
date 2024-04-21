import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:location/location.dart';


void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(38.9869, -76.9426);

  Location location = Location(); // Initialize location

  Set<Marker> _markers = {}; // Set to hold markers

  @override
  void initState() {
    super.initState();
    // Request location permission
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    var status = await location.requestPermission();
    if (status == PermissionStatus.denied) {
      // Handle denied permission
      // You can show a dialog to inform the user
      print('Location permission denied');
    } else if (status == PermissionStatus.granted) {
      // Permission granted, get current location
      _updateLocation();
    }
  }

  Future<void> _updateLocation() async {
    try {
      // Get current location
      LocationData? locationData = await location.getLocation();
      if (locationData != null) {
        // Update map camera position
        mapController.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(locationData.latitude!, locationData.longitude!),
          15.0,
        ));
        // Add a dot marker at current location
        setState(() {
          _markers.clear(); // Clear existing markers
          _markers.add(
            Marker(
              markerId: const MarkerId('currentLocation'),
              position: LatLng(locationData.latitude!, locationData.longitude!),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            ),
          );
        });
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue[200],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Terrapin Wars'),
          elevation: 10,
          backgroundColor: Color(0xCD5C5C),
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 15.5,
          ),
          markers: _markers,
          myLocationEnabled: true, // Enable current location button
        ),
      ),
    );
  }
}