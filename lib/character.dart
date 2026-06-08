class DisneyCharacter {
  final int id;
  final String name;
  final String imageUrl;
  final List<dynamic> films;
  final List<dynamic> tvShows;

  DisneyCharacter({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.films,
    required this.tvShows,
  });

  factory DisneyCharacter.fromJson(Map<String, dynamic> json) {
    return DisneyCharacter(
      id: json['_id'],
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      films: json['films'] ?? [],
      tvShows: json['tvShows'] ?? [],
    );
  }
}

