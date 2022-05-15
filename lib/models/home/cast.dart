class Cast {
  final bool adult;
  final int? gender;
  final int id;
  final String known_for_department;
  final String name;
  final String original_name;
  final double popularity;
  final String? profile_path;
  final String character;
  final String credit_id;
  final int order;

  const Cast({
    required this.adult,
    this.gender,
    required this.id,
    required this.known_for_department,
    required this.name,
    required this.original_name,
    required this.popularity,
    this.profile_path,
    required this.character,
    required this.credit_id,
    required this.order,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      adult: json['adult'],
      gender: json['gender'],
      id: json['id'],
      known_for_department: json['known_for_department'],
      name: json['name'],
      original_name: json['original_name'],
      popularity: json['popularity'],
      profile_path: json['profile_path'],
      character: json['character'],
      credit_id: json['credit_id'],
      order: json['order'],
    );
  }
}
