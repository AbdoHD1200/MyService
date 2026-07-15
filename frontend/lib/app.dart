import 'package:flutter/material.dart';
import 'features/splash/splash_screen.dart';

class MyServiceApp extends StatelessWidget {
  const MyServiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'خدمتي - MyService',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue,
          secondary: Colors.amber,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
