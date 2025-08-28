import 'package:flutter/material.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/explore_screen.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/home/home_screen.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/library_screen.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/trend_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    TrendScreen(),
    ExploreScreen(),
    LibraryScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: Color(0xFF1D1D1D),
        type: BottomNavigationBarType.fixed,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle),
            label: 'Xu hướng',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Khám phá'),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Thư viện',
          ),
        ],
      ),
    );
  }
}
