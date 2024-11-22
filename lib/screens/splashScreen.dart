import 'dart:async';

import 'package:flutter/material.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, '/login'); // Navigate to login
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8), // Adds spacing between the two lines
            Text(
              'ASR',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w500,
                color: Colors.black// You can customize the color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
