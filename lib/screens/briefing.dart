import 'package:flutter/material.dart';

class BriefingPage extends StatelessWidget {
  const BriefingPage({super.key});

  Widget _buildSection({
    required String title,
    required String content,
    required String imagePath,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          imagePath,
          height: 250,
          fit: BoxFit.contain,
          alignment: Alignment.center,
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Text(
              "Let's get you up to speed:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            _buildSection(
              imagePath: 'assets/qna.png',
              title: 'What is this project about?',
              content: 'We are creating a speech recognition system for the Akan language, tailored for healthcare settings. Your participation helps us bridge language barriers in healthcare delivery.',
            ),
            _buildSection(
              imagePath: 'assets/qnatwo.png',
              title: 'How does it work?',
              content: "You'll read selected healthcare-related text phrases in Akan, record your voice, and submit the recordings through this app. These recordings will be used to train our speech recognition model.",
            ),
            _buildSection(
              imagePath: 'assets/qnathree.png',
              title: 'Why is it important?',
              content: 'This project will help improve communication between patients and healthcare providers, making healthcare services more accessible and effective for Akan speakers.',
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/terms'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}