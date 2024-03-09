import 'package:camera/camera.dart';
import 'package:chatapp_third/allConstants/app_constants.dart';
import 'package:chatapp_third/helper/firebase_helper.dart';
import 'package:chatapp_third/models/user_model.dart';
import 'package:chatapp_third/ui/home_screen.dart';
import 'package:chatapp_third/ui/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

// bool isWhite = false;
var uuid = Uuid();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    UserModel? userModel =
        await FirebaseHelper.getUserModelById(currentUser.uid);
    if (userModel != null) {
      runApp(MyAppLoggedIn(
        userModel: userModel,
        firebaseUser: currentUser,
        camera: firstCamera,
      ));
    } else {
      runApp(MyApp(
        prefs: prefs,
      ));
    }
  } else {
    runApp(MyApp(
      prefs: prefs,
    ));
  }
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  // final CameraDescription camera;
  MyApp({super.key, required this.prefs});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
        // MultiProvider(
        //   providers: [
        //     ChangeNotifierProvider<AuthProvider>(
        //       create: (_) => AuthProvider(
        //         firebaseAuth: FirebaseAuth.instance,
        //         googleSignIn: GoogleSignIn(),
        //         firebaseFirestore: firebaseFirestore,
        //         prefs: prefs,
        //       ),
        //     ),
        //     Provider<SettingProvider>(
        //       create: (_) => SettingProvider(
        //           prefs: prefs,
        //           firebaseFirestore: firebaseFirestore,
        //           firebaseStorage: firebaseStorage),
        //     )
        //   ],
        //   child:
        MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginScreen(),
      // home: VideoScreen(camera: camera),
    );
    // );
  }
}

class MyAppLoggedIn extends StatelessWidget {
  final UserModel? userModel;
  final User? firebaseUser;
  final CameraDescription camera;
  MyAppLoggedIn(
      {super.key,
      required this.userModel,
      required this.firebaseUser,
      required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(firebaseUser: firebaseUser!, userModel: userModel!),
      // home: VideoScreen(
      //   camera: camera,
      // ),
    );
  }
}
// https://ron-swanson-quotes.herokuapp.com/v2/quotes
// http://jservice.io/api/random  