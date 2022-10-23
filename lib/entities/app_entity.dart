class AppEntity {
  final String link;
  final int id;
  AppEntity({required this.link, required this.id});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'link': link,
    };
  }

  factory AppEntity.fromJson(Map<String, dynamic> json) {
    json = json['results'][0];
    return AppEntity(
      id: json['id'] ?? 0,
      link: json['link'] ?? '',
    );
  }
}
