import 'package:flutter/material.dart';
import 'package:snake/screens/homepage.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Snake Game from UG',
      theme: ThemeData(),
      home: const HomePage(),
    );
  }
}
