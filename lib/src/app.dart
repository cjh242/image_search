// lib/app.dart
import 'package:flutter/material.dart';
import 'package:image_search/src/features/home/screens/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Search App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
      },
    );
  }
}
