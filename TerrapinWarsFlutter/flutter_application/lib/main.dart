import 'package:flutter/material.dart';
import 'package:flutter_application/firebase_options.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:location/location.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
  
}

class _MyAppState extends State<MyApp> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(38.9869, -76.9426);

  Location location = Location(); // Initialize location

  final Set<Marker> _markers = {
    const Marker(
        markerId: MarkerId('mckeldin'),
        position: LatLng(38.985946, -76.944600),
        icon: BitmapDescriptor.defaultMarker,
      ),
      const Marker(
        markerId: MarkerId('esj'),
        position: LatLng(38.987083, -76.941891),
        icon: BitmapDescriptor.defaultMarker,
      ),
      const Marker(
        markerId: MarkerId('eppley'),
        position: LatLng(38.993310, -76.945089),
        icon: BitmapDescriptor.defaultMarker,
      )
  }; // Set to hold markers

  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference _databaseReference = FirebaseDatabase.instance.ref(); 
  
  @override
  void initState() {
    super.initState();
    // Request location permission
    _requestPermission();
     // ignore: deprecated_member_use
  }

  Future<void> _requestPermission() async {
    var status = await location.requestPermission();
    if (status == PermissionStatus.denied) {
      // Handle denied permission
      // You can show a dialog to inform the user
      print('Location permission denied');
    } else if (status == PermissionStatus.granted) {
      // Permission granted, get current location
      _updateInitLocation();
    }
  }

  Future<void> _updateInitLocation() async {
    try {
      // Get current location
      LocationData? locationData = await location.getLocation();
      if (locationData != null) {
        _logLocationToDatabase(_databaseReference, locationData.latitude!, locationData.longitude!);

        // Update map camera position
        mapController.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(locationData.latitude!, locationData.longitude!),
          15.0,
        ));
        // Add a dot marker at current location
        setState(() {
          // _markers.clear(); // Clear existing markers
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


void _logLocationToDatabase(DatabaseReference _databaseReference, double latitude, double longitude) {
  // Get a reference to the "locations" node in the database
  DatabaseReference locationsRef = _databaseReference.child('locations');

  // Push a new location entry to the database
  locationsRef.push().set({
    'latitude': latitude,
    'longitude': longitude,
  });
}