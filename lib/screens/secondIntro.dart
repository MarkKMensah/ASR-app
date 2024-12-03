import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // Add this package

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // PageView
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              // First Page
              IntroPage(
                image: 'assets/ghana.png', // Add your Ghana map image
                title: 'Did you know?',
                description: 'Akan is spoken by over 9 million people, yet most speech-to-text tools struggle to understand it!',
                buttonText: 'I want to help',
              ),

              // Second Page
              IntroPage(
                image: 'assets/ladyanim.png', // Add your recording illustration
                title: 'Why Your Voice Matters',
                description: 'By recording your voice, you\'re helping create an Akan-to-English model that will save lives',
                buttonText: 'I want to help',
              ),

              // Third Page
              IntroPage(
                image: 'assets/ranking.png', // Add your podium image
                title: 'Let\'s Make It Fun',
                description: 'Earn badges, track your contributions, and challenge friends while making a difference',
                buttonText: 'I want to help',
              ),
            ],
          ),

          // Page Indicator
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 3,
                effect: const ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 8,
                  activeDotColor: Colors.black,
                  dotColor: Colors.grey,
                ),
              ),
            ),
          ),

          // Next/Get Started Button
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_currentPage < 2) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  } else {
                    Navigator.pushReplacementNamed(context, '/signup');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'I want to help',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Individual page widget
class IntroPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final String buttonText;

  const IntroPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 250,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 40),
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 100), // Space for dots and button
        ],
      ),
    );
  }
}