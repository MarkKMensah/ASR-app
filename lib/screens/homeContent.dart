import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class HomecontentPage extends StatefulWidget {
  const HomecontentPage({super.key});

  @override
  State<HomecontentPage> createState() => _HomecontentPageState();
}

class _HomecontentPageState extends State<HomecontentPage> {
  int _sessions = 0;
  int _phrases = 0;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
  try {
    final String? token = await _secureStorage.read(key: 'accessToken');
    final response = await http.get(
      Uri.parse('https://akan-asr-backend-d5ee511bc4b5.herokuapp.com/users/stats'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final int targetSessions = data['sessions'];
      final int targetPhrases = data['phrases_recorded'];

      _startCountUpAnimation(targetSessions, targetPhrases);
    } else {
      if (mounted) {
        setState(() {
          print('Failed to fetch data from server.');
        });
      }
    }
  } catch (e) {
    if (mounted) {
      setState(() {
        print('An error occurred while fetching data: $e');
      });
    }
  }
}

 void _startCountUpAnimation(int targetSessions, int targetPhrases) {
  int currentSessions = 0;
  int currentPhrases = 0;

  final int totalSteps = 50; // Animation will take ~2.5 seconds (50 * 50ms)
  final int sessionStep = (targetSessions / totalSteps).ceil();
  final int phrasesStep = (targetPhrases / totalSteps).ceil();

  Timer.periodic(const Duration(milliseconds: 50), (timer) {
    bool isComplete = true;

    if (currentSessions < targetSessions) {
      currentSessions = (currentSessions + sessionStep).clamp(0, targetSessions);
      isComplete = false;
    }

    if (currentPhrases < targetPhrases) {
      currentPhrases = (currentPhrases + phrasesStep).clamp(0, targetPhrases);
      isComplete = false;
    }

    // Ensure setState is only called when the widget is still mounted
    if (mounted) {
      setState(() {
        _sessions = currentSessions;
        _phrases = currentPhrases;
      });
    }

    if (isComplete) {
      timer.cancel();
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/micro.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.5),
                BlendMode.darken,
              ),
            ),
          ),
        ),

        // Gradient Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.white.withOpacity(0.8),
                Colors.white.withOpacity(0.8),
              ],
            ),
          ),
        ),

        // Content
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Welcome!',
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your stats',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      '$_sessions ',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 72,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      'sessions',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 55,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '$_phrases ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 72,
                        color: Colors.black.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'phrases',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 55,
                        color: Colors.black.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }
}