/// A placeholder class that represents an entity or model.
class ImagesResults {
  ImagesResults({required this.id, required this.url, required this.text});

  final int id;
  final String url;
  final String text;

  factory ImagesResults.fromJson(Map<String, dynamic> json) {
    return ImagesResults(
      id: json['id'],
      url: json['src']?['medium'] ?? "",
      text: json['alt'] ?? "No Description Found",
    );
  }
}
