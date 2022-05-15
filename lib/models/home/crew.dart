class Crew {
  final bool adult;
  final int? gender;
  final int id;
  final String known_for_department;
  final String name;
  final String original_name;
  final double popularity;
  final String? profile_path;
  final String credit_id;
  final String department;
  final String job;

  const Crew({
    required this.adult,
    this.gender,
    required this.id,
    required this.known_for_department,
    required this.name,
    required this.original_name,
    required this.popularity,
    this.profile_path,
    required this.credit_id,
    required this.department,
    required this.job,
  });

  factory Crew.fromJson(Map<String, dynamic> json) {
    return Crew(
      adult: json['adult'],
      gender: json['gender'],
      id: json['id'],
      known_for_department: json['known_for_department'],
      name: json['name'],
      original_name: json['original_name'],
      popularity: json['popularity'],
      profile_path: json['profile_path'],
      credit_id: json['credit_id'],
      department: json['department'],
      job: json['job'],
    );
  }
}
