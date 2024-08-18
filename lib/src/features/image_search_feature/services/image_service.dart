// services/image_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_search/src/features/image_search_feature/models/images_results.dart';

class ImageService {
  final String apiKey;

  ImageService(this.apiKey);

  Future<List<ImagesResults>> fetchImagesFromApi(String query, int page) async {
    final response = await http.get(
      Uri.parse(
          'https://serpapi.com/search?engine=google_images&q=$query&ijn=$page&api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<ImagesResults> images = (data['images_results'] as List)
          .map((image) => ImagesResults.fromJson(image))
          .toList();
      return images;
    } else {
      throw Exception('Failed to load images');
    }
  }
}
