import 'package:flutter/material.dart';

class LegonintroPage extends StatelessWidget {
  const LegonintroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Image.asset(
              'assets/record.jpg',
              height: 250,
              fit: BoxFit.contain,
              alignment: Alignment.center,

            ),
            const SizedBox(height: 10),
            Text(
              "Who We Are",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10),
            Text(
              "This project is led by the HCI-LAB at the Department of Computer Science, University of Ghana. Our lab specializes in Human-Computer Interaction, leveraging cutting-edge technology to address real-world challenges.",
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
              "Meet the Team",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 18),
            Text(
              "The project is spearheaded by Mark Mensah, a PhD researcher at the HCI-LAB, under the expert guidance of Prof. Isaac Wiafe. The team also includes passionate MSc students and researchers dedicated to advancing impactful solutions" ,
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
              "Our Mission",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 18),
            Text(
              "We strive to improve healthcare accessibility for Akan-speaking communities by developing innovative technology that bridges critical language barriers in healthcare settings",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 18),
            Text(
                  "By combining research, technology, and community engagement, we aim to transform communication between patients and healthcare providers, ensuring better care for all.",
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
                padding: EdgeInsets.symmetric(horizontal: 90, vertical: 16),
                backgroundColor: Colors.black, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'How do I contribute?',
                softWrap: false,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
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
