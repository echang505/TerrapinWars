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
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue[200],
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/map': (context) => const MapPage(),
        '/register': (context) => const RegisterPage(),

      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      if (userCredential.user != null) {
        // Navigate to the map page if login is successful
        Navigator.pushReplacementNamed(context, '/map');
      }
    } catch (e) {
      print('Login error: $e');
      // Show error message or handle login failure
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _register() {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              child: _isLoading ? const CircularProgressIndicator() : const Text('Login'),
            ),
            TextButton(
              onPressed: _register,
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _register() async {
    // Implement your registration logic here
    // For example, you can use FirebaseAuth to register a new user
    // This is just a placeholder function
    // Replace it with your actual registration logic
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    // Add your registration logic here
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    // User registered successfully
    // You can access the user information from userCredential.user
      print('User registered: ${userCredential.user?.uid}');
    } catch (e) {
      print('Error registering user: $e');
    // Handle registration failure
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}


class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
  
}

class _MapPageState extends State<MapPage> {
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