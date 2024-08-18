/// A placeholder class that represents an entity or model.
class ImagesResults {
  ImagesResults({
    required this.position,
    required this.thumbnail,
  });

  final int position;
  final String thumbnail;

  factory ImagesResults.fromJson(Map<String, dynamic> json) {
    return ImagesResults(
      position: json['position'],
      thumbnail: json['thumbnail'] ?? "",
    );
  }
}
