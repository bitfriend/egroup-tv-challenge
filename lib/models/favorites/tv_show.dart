class TvShow {
  final String? backdrop_path;
  final List<CreatedBy> created_by;
  final List<int> episode_run_time;
  final String first_air_date;
  final List<Genre> genres;
  final String homepage;
  final int id;
  final bool in_production;
  final List<String> languages;
  final String last_air_date;
  final Episode last_episode_to_air;
  final String name;
  final Episode? next_episode_to_air;
  final List<Company> networks;
  final int number_of_episodes;
  final int number_of_seasons;
  final List<String> origin_country;
  final String original_language;
  final String original_name;
  final String overview;
  final double popularity;
  final String poster_path;
  final List<Company> production_companies;
  final List<Country> production_countries;
  final List<Season> seasons;
  final List<SpokenLanguage> spoken_languages;
  final String status;
  final String tagline;
  final String type;
  final double vote_average;
  final int vote_count;

  const TvShow({
    this.backdrop_path,
    required this.created_by,
    required this.episode_run_time,
    required this.first_air_date,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.in_production,
    required this.languages,
    required this.last_air_date,
    required this.last_episode_to_air,
    required this.name,
    this.next_episode_to_air,
    required this.networks,
    required this.number_of_episodes,
    required this.number_of_seasons,
    required this.origin_country,
    required this.original_language,
    required this.original_name,
    required this.overview,
    required this.popularity,
    required this.poster_path,
    required this.production_companies,
    required this.production_countries,
    required this.seasons,
    required this.spoken_languages,
    required this.status,
    required this.tagline,
    required this.type,
    required this.vote_average,
    required this.vote_count,
  });

  factory TvShow.fromJson(Map<String, dynamic> json) {
    return TvShow(
      backdrop_path: json['backdrop_path'],
      created_by: (json['created_by'] as List).map((data) => CreatedBy.fromJson(data)).toList(),
      episode_run_time: (json['episode_run_time'] as List).cast<int>(),
      first_air_date: json['first_air_date'],
      genres: (json['genres'] as List).map((data) => Genre.fromJson(data)).toList(),
      homepage: json['homepage'],
      id: json['id'],
      in_production: json['in_production'],
      languages: (json['languages'] as List).cast<String>(),
      last_air_date: json['last_air_date'],
      last_episode_to_air: Episode.fromJson(json['last_episode_to_air']),
      name: json['name'],
      next_episode_to_air: json['next_episode_to_air'] == null ? null : Episode.fromJson(json['next_episode_to_air']),
      networks: (json['networks'] as List).map((data) => Company.fromJson(data)).toList(),
      number_of_episodes: json['number_of_episodes'],
      number_of_seasons: json['number_of_seasons'],
      origin_country: (json['origin_country'] as List).map((item) => item as String).toList(),
      original_language: json['original_language'],
      original_name: json['original_name'],
      overview: json['overview'],
      popularity: json['popularity'],
      poster_path: json['poster_path'],
      production_companies: (json['production_companies'] as List).map((data) => Company.fromJson(data)).toList(),
      production_countries: (json['production_countries'] as List).map((data) => Country.fromJson(data)).toList(),
      seasons: (json['seasons'] as List).map((data) => Season.fromJson(data)).toList(),
      spoken_languages: (json['spoken_languages'] as List).map((data) => SpokenLanguage.fromJson(data)).toList(),
      status: json['status'],
      tagline: json['tagline'],
      type: json['type'],
      vote_average: json['vote_average'].toDouble(),
      vote_count: json['vote_count'],
    );
  }
}

class CreatedBy {
  final int id;
  final String credit_id;
  final String name;
  final int gender;
  final String? profile_path;

  CreatedBy({
    required this.id,
    required this.credit_id,
    required this.name,
    required this.gender,
    this.profile_path,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json['id'],
      credit_id: json['credit_id'],
      name: json['name'],
      gender: json['gender'],
      profile_path: json['profile_path'],
    );
  }
}

class Genre {
  final int id;
  final String name;

  Genre({
    required this.id,
    required this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Episode {
  final String air_date;
  final int episode_number;
  final int id;
  final String name;
  final String overview;
  final String production_code;
  final int? runtime;
  final int season_number;
  final String? still_path;
  final double vote_average;
  final int vote_count;

  Episode({
    required this.air_date,
    required this.episode_number,
    required this.id,
    required this.name,
    required this.overview,
    required this.production_code,
    this.runtime,
    required this.season_number,
    this.still_path,
    required this.vote_average,
    required this.vote_count,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      air_date: json['air_date'],
      episode_number: json['episode_number'],
      id: json['id'],
      name: json['name'],
      overview: json['overview'],
      production_code: json['production_code'],
      runtime: json['runtime'],
      season_number: json['season_number'],
      still_path: json['still_path'],
      vote_average: json['vote_average'],
      vote_count: json['vote_count'],
    );
  }
}

class Company {
  final String name;
  final int id;
  final String? logo_path;
  final String origin_country;

  Company({
    required this.name,
    required this.id,
    this.logo_path,
    required this.origin_country,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'],
      id: json['id'],
      logo_path: json['logo_path'],
      origin_country: json['origin_country'],
    );
  }
}

class Country {
  final String iso_3166_1;
  final String name;

  Country({
    required this.iso_3166_1,
    required this.name,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      iso_3166_1: json['iso_3166_1'],
      name: json['name'],
    );
  }
}

class Season {
  final String air_date;
  final int episode_count;
  final int id;
  final String name;
  final String overview;
  final String? poster_path;
  final int season_number;

  Season({
    required this.air_date,
    required this.episode_count,
    required this.id,
    required this.name,
    required this.overview,
    this.poster_path,
    required this.season_number,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      air_date: json['air_date'],
      episode_count: json['episode_count'],
      id: json['id'],
      name: json['name'],
      overview: json['overview'],
      poster_path: json['poster_path'],
      season_number: json['season_number'],
    );
  }
}

class SpokenLanguage {
  final String english_name;
  final String iso_639_1;
  final String name;

  SpokenLanguage({
    required this.english_name,
    required this.iso_639_1,
    required this.name,
  });

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) {
    return SpokenLanguage(
      english_name: json['english_name'],
      iso_639_1: json['iso_639_1'],
      name: json['name'],
    );
  }
}
