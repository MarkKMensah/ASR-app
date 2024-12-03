import 'package:asr_data/screens/briefing.dart';
import 'package:asr_data/screens/home.dart';
import 'package:asr_data/screens/intro.dart';
import 'package:asr_data/screens/legonintro.dart';
import 'package:asr_data/screens/login.dart';
import 'package:asr_data/screens/secondIntro.dart';
import 'package:asr_data/screens/sessions.dart';
import 'package:asr_data/screens/signup.dart';
import 'package:asr_data/screens/splashScreen.dart';
import 'package:asr_data/screens/terms.dart';
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
        '/': (context) => SplashScreen(),
        '/splash': (context) => SplashScreen(),
        '/welcome': (context) => WelcomeScreen(),
        '/intro' : (context) => IntroScreen(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/brief' : (context) => BriefingPage(),
        '/home': (context) => HomeScreen(),
        '/session': (context) => SessionScreen(),
        '/terms': (context) => TermsPage(),
        '/legon': (context) => LegonintroPage()

      },
    );
  }
}
