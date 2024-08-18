import 'package:flutter/material.dart';
import 'package:image_search/src/features/image_search_feature/models/images_results.dart';

class ImageDetailScreen extends StatelessWidget {
  final ImagesResults image;

  const ImageDetailScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(image.text)),
      body: Center(
        child: Image.network(image.url),
      ),
    );
  }
}
