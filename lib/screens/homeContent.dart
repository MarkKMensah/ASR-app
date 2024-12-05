import 'package:flutter/material.dart';

class HomecontentPage extends StatefulWidget {
  const HomecontentPage({super.key});

  @override
  State<HomecontentPage> createState() => _HomecontentPageState();
}

class _HomecontentPageState extends State<HomecontentPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/micro.jpg'), // Add your image to assets
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
                SizedBox(height: 20),
                Text(
                  'Welcome Emmanuel!',
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Your stats',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      '12 ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 72,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'sessions',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 55,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '96 ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 72,
                          color: Colors.black.withOpacity(0.9),
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'phrases',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 55,
                          color: Colors.black.withOpacity(0.9),
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
