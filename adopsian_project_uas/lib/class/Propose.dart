class Propose {
  final int user_id;
  final String description;
  final String username_user;

   Propose(
      {required this.user_id,
      required this.description,
      required this.username_user});

  factory Propose.fromJson(Map<String, dynamic> json) {
    return Propose(
      user_id: json['users_id'] as int,
      description: json['description'] as String,
      username_user: json['username'] as String);
  }
}