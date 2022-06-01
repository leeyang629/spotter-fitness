import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotter/archives/ListPage.dart';
import 'package:spotter/archives/LocationModel.dart';
import 'package:spotter/archives/PlacesInformationPage.dart';
import 'package:spotter/archives/SearchDeck.dart';
import 'package:spotter/archives/mapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(
    create: (context) => LocationModel(),
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreen();
  }
}

// class MapState extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       initialRoute: '/',
//       routes: {
//         // '/': (context) => HomeScreen(),
//         '/listPage': (context) => ListGymsPage(),
//         '/placesInformationPage': (context) => PlacesInformationPage()
//       },
//       title: 'Spotter',
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

class HomeScreen extends State<MyApp> {
  // Set default `_initialized` and `_error` state to false
  // bool _initialized = false;
  // bool _error = false;
  //
  // // Define an async function to initialize FlutterFire
  // void initializeFlutterFire() async {
  //   try {
  //     // Wait for Firebase to initialize and set `_initialized` state to true
  //     await Firebase.initializeApp();
  //     setState(() {
  //       _initialized = true;
  //     });
  //   } catch (e) {
  //     // Set `_error` state to true if Firebase initialization fails
  //     setState(() {
  //       _error = true;
  //     });
  //   }
  // }

  // @override
  // void initState() {
  //   initializeFlutterFire();
  //   super.initState();
  // }

  // Widget homeP() {
  //   FirebaseAuth.instance.authStateChanges().listen((User user) {
  //     if (user == null) {
  //       print('User is currently signed out!');
  //       return Scaffold(
  //           // appBar: AppBar(title: Text("Welcome to Spotter")),
  //           body: Stack(
  //         // fit: StackFit.expand,
  //         children: <Widget>[Mapper(), SearchDeck()],
  //       ));
  //     } else {
  //       print('User is signed in!');
  //       return Text("Nope");
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    // // Show error message if initialization failed
    // if (_error) {
    //   return FirebaseError();
    // }
    //
    // // Show a loader until FlutterFire is initialized
    // if (!_initialized) {
    //   return Scaffold(body: LoadingIndicator());
    // }

    return MaterialApp(
      initialRoute: '/',
      routes: {
        // '/': (context) => HomeScreen(),
        '/listPage': (context) => ListGymsPage(),
        '/placesInformationPage': (context) => PlacesInformationPage()
      },
      title: 'Spotter',
      home: Stack(
        // fit: StackFit.expand,
        children: <Widget>[Mapper(), SearchDeck()],
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
