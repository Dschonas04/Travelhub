import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/trips_provider.dart';
import 'providers/friends_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/budget_provider.dart';
import 'providers/members_provider.dart';
import 'providers/agreements_provider.dart';
import 'screens/login_screen.dart';
import 'screens/main_tab_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TravelhubApp());
}

/// Pendant zu TravelhubApp.swift + ContentView.swift
/// MultiProvider versorgt die gesamte App mit allen ChangeNotifier-Providern.
class TravelhubApp extends StatelessWidget {
  const TravelhubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TripsProvider()),
        ChangeNotifierProvider(create: (_) => FriendsProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => BudgetProvider()),
        ChangeNotifierProvider(create: (_) => MembersProvider()),
        ChangeNotifierProvider(create: (_) => AgreementsProvider()),
      ],
      child: MaterialApp(
        title: 'Travelhub',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const _AuthGate(),
      ),
    );
  }
}

/// Zeigt LoginScreen oder MainTabScreen je nach Auth-Status
/// (Pendant zu ContentView.swift isLoggedIn-Check)
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return auth.isLoggedIn ? const MainTabScreen() : const LoginScreen();
  }
}
