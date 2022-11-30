import 'package:flutter/material.dart';

import 'screens/screens.dart';

class AppRouter {
  static Map<String, Widget Function(BuildContext)> routes = {
    SplashScreen.name: (context) => const SplashScreen(),
    LoginScreen.name: (context) => const LoginScreen(),
    RootScreen.name: (context) => const RootScreen(),
    CheckIn.name: (context) => const CheckIn(),
    CheckOut.name: (context) => const CheckOut(),
    Settings.name: (context) => Settings(),
    PrintTask.name: (context) => const PrintTask(),
    AdminLoginScreen.name: (context) => const AdminLoginScreen(),
    TestScreen.name: (context) => const TestScreen(),
  };
}
