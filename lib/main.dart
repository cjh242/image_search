// lib/main.dart
import 'package:flutter/material.dart';
import 'package:image_search/src/app.dart';
import 'package:image_search/src/features/image_search_feature/providers/images_provider.dart';
import 'package:image_search/src/features/image_search_feature/services/image_service.dart';
import 'package:provider/provider.dart';

void main() async {
  // Initialize the ImageService with your API key
  final imageService =
      ImageService("jrx0Be8upzGn39wHkdu0fu0dq32IDst974CTdMNJl2hMIq5H0XAGhelr");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImagesProvider(imageService)),
      ],
      child: const MyApp(),
    ),
  );
}
