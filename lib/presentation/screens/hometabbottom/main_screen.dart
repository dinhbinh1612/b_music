import 'package:flutter/material.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/home/home_screen.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/library_screen.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/trend/hot_screen.dart';
import 'package:spotify_b/presentation/widgets/mini_player.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    HotScreen(),
    // ExploreScreen(),
    LibraryScreen(),
  ];

  void _onTabTapped(int index) {
    if (_currentIndex == index) return; // tránh setState lại cùng index
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MiniPlayer(),
          BottomNavigationBar(
            currentIndex: _currentIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            backgroundColor: const Color(0xFF1D1D1D),
            type: BottomNavigationBarType.fixed,
            onTap: _onTabTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Trang chủ',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.trending_up),
                label: 'Xu hướng',
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.explore),
              //   label: 'Khám phá',
              // ),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_music),
                label: 'Thư viện',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
