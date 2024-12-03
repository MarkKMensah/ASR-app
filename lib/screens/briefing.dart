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
            const SizedBox(height: 10),
            Text(
              "What is this project about?",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10),
            Text(
              "We are creating a speech recognition system for the Akan language, tailored for healthcare settings. Your participation helps us bridge language barriers in healthcare delivery.",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 30),
            Image.asset(
              'assets/record.jpg',
              height: 250,
              fit: BoxFit.contain,
              alignment: Alignment.center,

            ),
            const SizedBox(height: 10),
            Text(
              "How does it work?",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 18),
            Text(
              "You’ll read selected healthcare-related text phrases in Akan, record your voice, and submit the recordings through this app. These recordings will be used to train our speech recognition model." ,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 30),
            Image.asset(
              'assets/record.jpg',
              height: 250,
              fit: BoxFit.contain,
              alignment: Alignment.center,

            ),
            const SizedBox(height: 10),
            Text(
              "Why is it important?",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 18),
            Text(
              "This project will help improve communication between patients and healthcare providers, making healthcare services more accessible and effective for Akan speakers.",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.left,
            ),


            SizedBox(height: 30), // Spacing
            // Sign Me Up Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/terms');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 150, vertical: 16),
                backgroundColor: Colors.black, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Next',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),

    );
  }
}
