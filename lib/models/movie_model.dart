class Movie {
  final String title;
  final String poster;
  final String year;
  final String imdbID;
  final String type;

  Movie({
    required this.title,
    required this.poster,
    required this.year,
    required this.imdbID,
    required this.type,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'] ?? '',
      poster: json['Poster'] ?? '',
      year: json['Year'] ?? '',
      imdbID: json['imdbID'] ?? '',
      type: json['Type'] ?? '',
    );
  }
}