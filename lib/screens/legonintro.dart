import 'package:flutter/material.dart';

class LegonintroPage extends StatelessWidget {
  const LegonintroPage({super.key});

  Widget _buildSection({
    required String imagePath,
    required String title,
    required String content,
    String? additionalContent,
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
        const SizedBox(height: 10),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        if (additionalContent != null) ...[
          const SizedBox(height: 18),
          Text(
            additionalContent,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
        const SizedBox(height: 30),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            _buildSection(
              imagePath: 'assets/legon.png',
              title: 'Who We Are',
              content: 'This project is led by the HCI-LAB at the Department of Computer Science, University of Ghana. Our lab specializes in Human-Computer Interaction, leveraging cutting-edge technology to address real-world challenges.',
            ),
            _buildSection(
              imagePath: 'assets/team.png',
              title: 'Meet the Team',
              content: 'The project is spearheaded by Mark Mensah, a PhD researcher at the HCI-LAB, under the expert guidance of Prof. Isaac Wiafe. The team also includes passionate MSc students and researchers dedicated to advancing impactful solutions',
            ),
            _buildSection(
              imagePath: 'assets/progress.png',
              title: 'Our Mission',
              content: 'We strive to improve healthcare accessibility for Akan-speaking communities by developing innovative technology that bridges critical language barriers in healthcare settings',
              additionalContent: 'By combining research, technology, and community engagement, we aim to transform communication between patients and healthcare providers, ensuring better care for all.',
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/survey'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'How do I contribute?',
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