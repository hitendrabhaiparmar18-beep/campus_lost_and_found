import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'campus_map_screen.dart';
import 'found_items_screen.dart';
import 'home_screen.dart';
import 'lost_items_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const MainNavigationScreen({super.key, required this.onToggleTheme});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final pages = [
      HomeScreen(onToggleTheme: widget.onToggleTheme),
      const LostItemsScreen(),
      const FoundItemsScreen(),
      const CampusMapScreen(),
      ProfileScreen(onToggleTheme: widget.onToggleTheme),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: isDark ? AppTheme.cardDark : Colors.white,
        indicatorColor: AppTheme.primaryColor.withValues(alpha: 0.18),
        elevation: 8,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded, color: AppTheme.primaryColor),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search_rounded, color: AppTheme.lostColor),
            label: 'Lost Items',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome_rounded, color: AppTheme.foundColor),
            label: 'Found Items',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map_rounded, color: AppTheme.primaryColor),
            label: 'Campus Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person_rounded, color: AppTheme.primaryColor),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
