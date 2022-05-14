class TvShow {
  final String poster_path;
  final double popularity;
  final int id;
  final String? backdrop_path;
  final double vote_average;
  final String overview;
  final String first_air_date;
  final List<String> origin_country;
  final List<int> genre_ids;
  final String original_language;
  final int vote_count;
  final String name;
  final String original_name;
  final bool? checked;

  const TvShow({
    required this.poster_path,
    required this.popularity,
    required this.id,
    this.backdrop_path,
    required this.vote_average,
    required this.overview,
    required this.first_air_date,
    required this.origin_country,
    required this.genre_ids,
    required this.original_language,
    required this.vote_count,
    required this.name,
    required this.original_name,
    this.checked,
  });

  factory TvShow.fromJson(Map<String, dynamic> json) {
    return TvShow(
      poster_path: json['poster_path'],
      popularity: json['popularity'],
      id: json['id'],
      backdrop_path: json['backdrop_path'],
      vote_average: json['vote_average'].toDouble(),
      overview: json['overview'],
      first_air_date: json['first_air_date'],
      origin_country: (json['origin_country'] as List<dynamic>).cast<String>(),
      genre_ids: (json['genre_ids'] as List<dynamic>).cast<int>(),
      original_language: json['original_language'],
      vote_count: json['vote_count'],
      name: json['name'],
      original_name: json['original_name'],
    );
  }
}
