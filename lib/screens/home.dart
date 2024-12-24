import 'package:asr_data/screens/history.dart';
import 'package:asr_data/screens/homeContent.dart';
import 'package:asr_data/screens/sessions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomecontentPage(),
    const SessionScreen(),
    const HistoryPage() // Extract your existing home content into a separate widget
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) async {
          // Check if the user has confirmed details stored in secure storage
          String? details = await _secureStorage.read(key: 'details');

          if (details == 'true') {
            // If details are confirmed, update the selected index
            setState(() {
              _selectedIndex = index;
            });
          } else {
            // If details are not confirmed, navigate to the survey page
            Navigator.pushNamed(context, '/survey');
          }
        },
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        iconSize: 30,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.mic), label: 'Record'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }
}
