import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

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
        Uri.parse('https://akan-asr-backend-d5ee511bc4b5.herokuapp.com/users/login'),
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

        Future<void> _googleSignInHandler() async {
        try {
          setState(() {
            _isLoading = true;
            _errorMessage = '';  // Clear any previous errors
          });

          // Initiate Google Sign-In
          final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
          if (googleUser == null) {
            setState(() {
              _errorMessage = 'Sign-in was cancelled';
            });
            return;
          }

          // Get authentication details
          final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
          
          
          final String? authCode = googleAuth.accessToken;
          if (authCode == null) {
            setState(() {
              _errorMessage = 'Failed to get authorization code';
            });
            return;
          }

          // Make the request to your backend
          final response = await http.get(
            Uri.parse(
              'https://akan-asr-backend-d5ee511bc4b5.herokuapp.com/users/google-callback'
            ).replace(queryParameters: {
              'code': authCode,
            }),
          );

          if (!mounted) return;  // Check if widget is still mounted

          // Handle the response
          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            
            // Validate required fields exist
            if (!data.containsKey('access_token') || 
                !data.containsKey('refresh_token') ||
                !data.containsKey('confirmed_details')) {
              throw Exception('Invalid response format from server');
            }

            // Store tokens securely
            await Future.wait([
              _secureStorage.write(
                key: 'accessToken',
                value: data['access_token'],
              ),
              _secureStorage.write(
                key: 'refreshToken',
                value: data['refresh_token'],
              ),
              _secureStorage.write(
                key: 'details',
                value: data['confirmed_details'].toString(),
              ),
            ]);

            if (!mounted) return;  // Check again before navigation
            
            // Navigate to home screen
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            // Handle different error status codes
            String errorMessage;
            try {
              final errorData = json.decode(response.body);
              errorMessage = errorData['detail'];
            } catch (e) {
              errorMessage = e.toString();
            }
            
            setState(() {
              _errorMessage = errorMessage;
            });
          }
        } on PlatformException catch (e) {
          setState(() {
            _errorMessage = 'Platform error: ${e.message}';
          });
        } on SocketException {
          setState(() {
            _errorMessage = 'Network error. Please check your connection.';
          });
        } catch (e) {
          setState(() {
            _errorMessage = 'An unexpected error occurred: ${e.toString()}';
          });
        } finally {
          if (mounted) {  // Check if widget is still mounted
            setState(() {
              _isLoading = false;
            });
          }
        }
      }

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
              )
            else
              Column(
                children: [
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
                  const SizedBox(height: 8),
              // SizedBox(
              //   width: double.infinity,
              //   child: OutlinedButton(
              //     onPressed: _googleSignInHandler,
              //     style: OutlinedButton.styleFrom(
              //       padding: const EdgeInsets.symmetric(
              //           horizontal: 80, vertical: 16),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //     ),
              //     child: Row(
              //       mainAxisSize: MainAxisSize.min,
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Image.asset(
              //           'assets/google.png',
              //           height: 24,
              //           width: 24,
              //         ),
              //         const SizedBox(width: 12),
              //         const Text(
              //           'Continue with google',
              //           style: TextStyle(
              //             fontSize: 16,
              //             fontWeight: FontWeight.bold,
              //             color: Colors.black,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),)
                ],
              ),
            const SizedBox(height: 16),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            const SizedBox(height: 16),
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
          ],
        ),
      ),
    );
  }
}
