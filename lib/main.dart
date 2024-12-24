import 'dart:async';
import 'package:asr_data/screens/briefing.dart';
import 'package:asr_data/screens/home.dart';
import 'package:asr_data/screens/intro.dart';
import 'package:asr_data/screens/legonintro.dart';
import 'package:asr_data/screens/login.dart';
import 'package:asr_data/screens/secondIntro.dart';
import 'package:asr_data/screens/sessions.dart';
import 'package:asr_data/screens/signup.dart';
import 'package:asr_data/screens/survey.dart';
import 'package:asr_data/screens/terms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/welcome', // Initial route
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/firstintro': (context) => const FirstWelcomeScreen(),
        '/intro': (context) => const IntroScreen(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/brief': (context) => const BriefingPage(),
        '/home': (context) => const HomeScreen(),
        '/session': (context) => const SessionScreen(),
        '/terms': (context) => const TermsPage(),
        '/legon': (context) => const LegonintroPage(),
        '/survey': (context) => const SurveyForm(),
      },
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

Future<void> _navigateNext() async {
  String? accessToken = await _storage.read(key: 'accessToken');
  if (accessToken != null) {
    Navigator.pushReplacementNamed(context, '/home');
  } else {
    Navigator.pushReplacementNamed(context, '/firstintro');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          
        ), // Show a loading indicator while waiting
      ),
    );
  }
}
