import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/theme/app_theme.dart';
import 'ui/view_models/item_provider.dart';
import 'ui/views/main_navigation_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ItemProvider(),
      child: const CampusLostAndFoundApp(),
    ),
  );
}

class CampusLostAndFoundApp extends StatefulWidget {
  const CampusLostAndFoundApp({super.key});

  @override
  State<CampusLostAndFoundApp> createState() => _CampusLostAndFoundAppState();
}

class _CampusLostAndFoundAppState extends State<CampusLostAndFoundApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Lost & Found',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: MainNavigationScreen(
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}
