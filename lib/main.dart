import 'package:flutter/material.dart';
import 'package:pedidos/screens/login_screen.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/services/user_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const VerdantGrowthApp());
}

class VerdantGrowthApp extends StatelessWidget {
  const VerdantGrowthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VerdantGrowth',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system,
      home: const LoginScreen(),
    );
  }
}