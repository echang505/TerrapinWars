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
        '/registrationWeakPasswordPage': (context) => const RegistrationWeakPasswordPage(),
        '/registrationUserExists': (context) => const RegistrationUserExists(),
        '/registrationUnknownError': (context) => const RegistrationUnknownError(),
        '/registrationBadFormat': (context) => const RegistrationBadFormat(),
        '/registrationSuccess': (context) => const RegistrationSuccess(),
        
      },
    );
  }
}

// stores email key for each log in -> used for queries. 
String emailKey = "";

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
        emailKey = _emailController.text.trim();
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
class RegistrationWeakPasswordPage extends StatefulWidget {
  const RegistrationWeakPasswordPage({Key? key}) : super(key: key);

  @override
  _RegistrationWeakPasswordPageState createState() => _RegistrationWeakPasswordPageState();
}

class _RegistrationWeakPasswordPageState extends State<RegistrationWeakPasswordPage> {
  void _register() {
    Navigator.pushNamed(context, '/register');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Password is TOO WEAK. Enter a password with 8 characters'),
        ),
        body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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

class RegistrationBadFormat extends StatefulWidget {
  const RegistrationBadFormat({Key? key}) : super(key: key);

  @override
  _RegistrationBadFormatState createState() => _RegistrationBadFormatState();
}

class _RegistrationBadFormatState extends State<RegistrationBadFormat> {
  void _register() {
    Navigator.pushNamed(context, '/register');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email is badly formatted. Please Try again.'),
        ),
        body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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

class RegistrationUserExists extends StatefulWidget {
  const RegistrationUserExists({Key? key}) : super(key: key);

  @override
  _RegistrationUserExistsState createState() => _RegistrationUserExistsState();
}

class _RegistrationUserExistsState extends State<RegistrationUserExists> {
  void _register() {
    Navigator.pushNamed(context, '/register');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The email you entered is already in use. Please try again'),
        ),
        body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
class RegistrationUnknownError extends StatefulWidget {
  const RegistrationUnknownError({Key? key}) : super(key: key);

  @override
  _RegistrationUnknownErrorState createState() => _RegistrationUnknownErrorState();
}

class _RegistrationUnknownErrorState extends State<RegistrationUnknownError> {
  void _register() {
    Navigator.pushNamed(context, '/register');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unknown registration error. Please try again.'),
        ),
        body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
class RegistrationSuccess extends StatefulWidget {
  const RegistrationSuccess({Key? key}) : super(key: key);

  @override
  _RegistrationSuccessState createState() => _RegistrationSuccessState();
}

class _RegistrationSuccessState extends State<RegistrationSuccess> {
  void _returnToLogin() {
    Navigator.pushNamed(context, '/');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Successfully Registered New User'),
        ),
        body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _returnToLogin,
              child: const Text('Log In'),
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
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

    // User registered successfully
      print('User registered: ${userCredential.user?.uid}');
      Navigator.pushNamed(context, '/registrationSuccess');

    } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
          Navigator.pushNamed(context, '/registrationWeakPasswordPage');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
          Navigator.pushNamed(context, '/registrationUserExists');
        } else if (e.code == 'invalid-email') {
          print('email is badly formatted');
          Navigator.pushNamed(context, '/registrationBadFormat');
        } else {
          print(e);
          Navigator.pushNamed(context, '/registrationUnknownError');
        }
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

  Future<void> _capturePoint_mckeldin() async {
      // get current time
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      String pointQueryString = 'points/mckeldin';
      // DatabaseReference markersRef = _databaseReference.child('points');
      try {
        final ref = FirebaseDatabase.instance.ref();
        final snapshot = await ref.child(pointQueryString).get();
        
        if (snapshot.exists) {
          // Access the data from the snapshot
          print(snapshot.value);
        } else {
          print("No Data Available");
        };
      } catch (e) {
        print('Error fetching data: $e');
      }

      // fetch data for current holder of point

      // fetch time captured
      // go to current holder of point and add points to totalPoints
      // go to current holder of point and remove current point from pointsHeld
      // update point with new holder (email)
      // update point with new time
      // update new user as point holder



  }

  Location location = Location(); // Initialize location

  final Set<Marker> _markers = {
    const Marker(
        markerId: MarkerId('mckeldin'),
        position: LatLng(38.985946, -76.944600),
        icon: BitmapDescriptor.defaultMarker,
        // onTap: (MarkerId markerId) {
        //   _capturePoint(markerId.value());
        // },
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
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100, 
          title: const Center(
            child: Text(
              'Terrapin Wars',
              style: TextStyle(fontSize: 50),
            ),
          ),
          elevation: 10,
          backgroundColor: Colors.red[50],
          foregroundColor: Colors.red,
          actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.scoreboard, color: Colors.red, size: 50.0,),
            tooltip: 'Scoreboard',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      toolbarHeight: 100, 
                      title: const Center(
                        child: Text(
                          'Scoreboard',
                          style: TextStyle(fontSize: 50),
                        ),
                      ),
                      scrolledUnderElevation: scrolledUnderElevation,
                      backgroundColor: Colors.red[50],
                      foregroundColor: Colors.red,
                    ),
                    body: GridView.builder(
                      itemCount: _items.length,
                      padding: const EdgeInsets.all(30.0),
                      gridDelegate: const
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 7.0,
                        mainAxisSpacing: 20.0,
                        crossAxisSpacing: 10.0,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.amber,
                          ),
                          child: Text('Player $index', style: TextStyle(fontSize: 40),
                          ),
                        );
                      },
                      ),
                      bottomNavigationBar: BottomAppBar(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: OverflowBar(
                            overflowAlignment: OverflowBarAlignment.center,
                            alignment: MainAxisAlignment.center,
                            overflowSpacing: 5.0
                          )
                        )
                      )
                    );
                  },
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.sensor_occupied, color: Colors.red, size: 50.0,),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      toolbarHeight: 100, 
                      title: const Center(
                        child: Text(
                        'Profile',
                        style: TextStyle(fontSize: 50),
                        ),
                      ),
                      backgroundColor: Colors.red[50],
                      foregroundColor: Colors.red,
                    ),
                    body: Column(
                      children: <Widget>[
                        Positioned.fill(
                          child: Align(
                          alignment: Alignment.center,
                          child: Container(width: 300, height: 300, margin: EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.amber,
                            ),
                          ),),
                        ),
                        Positioned.fill(
                          child: Align(
                          alignment: Alignment.center,
                          child: Container(width: 700, margin: EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.amber,
                            ),
                          ),),
                        ),
                      ],
                      ),
                    );
                },
              ));
            },
          ),
          ],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 15.5,
          ),
          markers: {
            const Marker(
            markerId: MarkerId('Default'),
            position: LatLng(38.9869, -76.9426),
            infoWindow: InfoWindow(
               title: "Sydney",
               snippet: "Capital of New South Wales",
            ), // InfoWindow
            )
          },
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
