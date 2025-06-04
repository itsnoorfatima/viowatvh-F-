import 'package:flutter/material.dart';
import 'package:viowatch/screens/home_screen.dart';

void main() {
  runApp(const VioWatchApp());
}

class VioWatchApp extends StatelessWidget {
  const VioWatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Viowatch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo, fontFamily: 'Roboto'),
      home: const HomeScreen(), // Sets the home screen
    );
  }
}
