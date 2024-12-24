import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> _login() async {
  setState(() {
    _isLoading = true;
    _errorMessage = '';
  });

  final String email = _emailController.text.trim();
  final String password = _passwordController.text;

  if (email.isEmpty || password.isEmpty) {
    setState(() {
      _isLoading = false;
      _errorMessage = 'Please enter both email and password.';
    });
    return;
  }

  try {
    final response = await http.post(
      Uri.parse('https://akan-recorder-backend-y5er.onrender.com/users/login'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'username': email,
        'password': password,
      },
    );

    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      final String accessToken = data['access_token'];
      final String refreshToken = data['refresh_token'];
      final bool details = data['confirmed_details'];

      await _secureStorage.write(key: 'accessToken', value: accessToken);
      await _secureStorage.write(key: 'refreshToken', value: refreshToken);
      await _secureStorage.write(key: 'details', value: details.toString());

      Navigator.pushNamed(context, '/home');
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Login failed. Please try again.';
      });
    }
  } catch (e) {
    print('Login Error: $e');
    setState(() {
      _isLoading = false;
      _errorMessage = 'An unexpected error occurred.';
    });
  }
}


// Future<void> _routing() async {
//   _login();
//   String? details = await _secureStorage.read(key: 'details');

//   // Ensure the 'details' value is checked correctly
//   if (details == 'true') {
//     Navigator.pushNamed(context, '/home');
//   } else {
//     Navigator.pushNamed(context, '/survey');
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text(
              'Welcome Back!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/asr_logo.jpg', // Replace with your image asset
              height: 80,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ) // Show loading indicator while waiting
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            // Display error message if any
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            const SizedBox(height: 16), // Spacing
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
