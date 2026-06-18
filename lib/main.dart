import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pedidos/screens/login_screen.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:pedidos/providers/theme_provider.dart';
import 'package:pedidos/services/user_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final userPrefs = UserPreferences();
  await userPrefs.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const VerdantGrowthApp(),
    ),
  );
}

class VerdantGrowthApp extends StatelessWidget {
  const VerdantGrowthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'VerdantGrowth',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          themeMode: themeProvider.themeMode,
          home: const LoginScreen(),
        );
      },
    );
  }
}