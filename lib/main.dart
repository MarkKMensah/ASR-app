import 'package:asr_data/screens/home.dart';
import 'package:asr_data/screens/login.dart';
import 'package:asr_data/screens/sessions.dart';
import 'package:asr_data/screens/signup.dart';
import 'package:asr_data/screens/splashScreen.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash', // Initial route
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomeScreen(),
        '/session': (context) => SessionScreen(),
        '/signup': (context) => SignUpPage(),
      },
    );
  }
}
