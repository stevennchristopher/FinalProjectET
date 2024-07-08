class User {
  final int id;
  String username;
  String email;
  String phone;
  String password;

   User(
      {required this.id,
      required this.username,
      required this.email,
      required this.phone,
      required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      password: json['pass'] as String);
  }
}