import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'LoginPage.dart';
import 'RegisterPages.dart';
import 'MyHomePage.dart';
import 'WelcomePage.dart';
import 'Products.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const firebaseConfig = FirebaseOptions(
    apiKey: "AIzaSyAMW1rg1MMnKAUSFT48zNUkkFdNUV67bBg",
    authDomain: "sprint0-806bb.firebaseapp.com",
    projectId: "sprint0-806bb",
    storageBucket: "sprint0-806bb.appspot.com",
    messagingSenderId: "1003937310468",
    appId: "1:1003937310468:web:AOG3mzT1QITIiH47vChH",
  );

  await Firebase.initializeApp(options: firebaseConfig);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase CRUD',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const WelcomePage(),
    );
  }
}
