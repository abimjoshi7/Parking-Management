import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smartparking/app_router.dart';

import './screens/screens.dart';
import 'constants/theme.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CustomTheme.kThemeData(),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.name,
      routes: AppRouter.routes,
    );
  }
}
