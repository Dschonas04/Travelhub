import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'trips_list_screen.dart';
import 'search_hub_screen.dart';
import 'chat_list_screen.dart';
import 'profile_screen.dart';

/// Pendant zu MainTabView.swift – 4 Tabs: Reisen, Entdecken, Chat, Einstellungen
class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _index = 0;

  final _screens = const [
    TripsListScreen(),
    SearchHubScreen(),
    ChatListScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        indicatorColor: AppColors.primary.withOpacity(0.15),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.flight), selectedIcon: Icon(Icons.flight, color: AppColors.primary), label: 'Reisen'),
          NavigationDestination(icon: Icon(Icons.explore), selectedIcon: Icon(Icons.explore, color: AppColors.primary), label: 'Entdecken'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble, color: AppColors.primary), label: 'Chat'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings, color: AppColors.primary), label: 'Einstellungen'),
        ],
      ),
    );
  }
}
