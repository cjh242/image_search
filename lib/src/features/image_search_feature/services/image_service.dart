// services/image_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_search/src/features/image_search_feature/models/images_results.dart';

class ImageService {
  final String apiKey;

  ImageService(this.apiKey);

  Future<List<ImagesResults>> fetchImagesFromApi(String query, int page) async {
    final url = Uri.parse(
        //url with the query and the page
        'https://api.pexels.com/v1/search?query=$query&page=$page&per_page=80');

    //add the apikey as a header
    final response = await http.get(
      url,
      headers: {
        'Authorization': apiKey,
      },
    );

    //if the response is ookay decode it and map to our objects
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<ImagesResults> images = (data['photos'] as List)
          .map((image) => ImagesResults.fromJson(image))
          .toList();
      return images;
    } else {
      throw Exception('Failed to load images');
    }
  }
}
