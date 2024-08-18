/// A placeholder class that represents an entity or model.
class ImagesResults {
  ImagesResults({
    required this.id,
    required this.url,
  });

  final int id;
  final String url;

  factory ImagesResults.fromJson(Map<String, dynamic> json) {
    return ImagesResults(
      id: json['id'],
      url: json['src']?['medium'] ?? "",
    );
  }
}
