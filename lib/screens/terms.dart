import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

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

            Image.asset(
              'assets/record.jpg',
              height: 250,
              fit: BoxFit.contain,
              alignment: Alignment.center,

            ),
            const SizedBox(height: 10),
            Text(
              "Your Privacy Matters",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10),
            Text(
              "All data collected will be used solely for research purposes. We are committed to ensuring your privacy and security.",
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
              "Anonymity Guaranteed",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 18),
            Text(
              "Your recordings will be anonymized and stored securely. No personally identifiable information will be associated with the data." ,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 30),
            Text(
              "By proceeding, you consent to your data being used for research in strict adherence to legal and ethical standards.",
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
                Navigator.pushNamed(context, '/legon');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                backgroundColor: Colors.black, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'I Understand and Agree',
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
