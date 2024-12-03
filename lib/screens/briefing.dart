import 'package:flutter/material.dart';

class BriefingPage extends StatelessWidget {
  const BriefingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Text("Let's get you up to speed:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600
              ),
              textAlign: TextAlign.left,
            ),
            Image.asset(
              'assets/record.jpg',
              height: 250,
              fit: BoxFit.contain,
              alignment: Alignment.center,

            ),
            const SizedBox(height: 40),
            Text(
              "What is this project about?",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 18),
            Text(
              "We are creating a speech recognition system for the Akan language, tailored for healthcare settings. Your participation helps us bridge language barriers in healthcare delivery.",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),

    );
  }
}
