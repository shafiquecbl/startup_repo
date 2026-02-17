class PromoBanner {
  final String id;
  final String image;
  final String title;
  final String? subtitle;
  final String? actionUrl;

  const PromoBanner({
    required this.id,
    required this.image,
    required this.title,
    this.subtitle,
    this.actionUrl,
  });

  factory PromoBanner.fromJson(Map<String, dynamic> json) {
    return PromoBanner(
      id: json['id'],
      image: json['image'],
      title: json['title'],
      subtitle: json['subtitle'],
      actionUrl: json['action_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'image': image, 'title': title, 'subtitle': subtitle, 'action_url': actionUrl};
  }
}
