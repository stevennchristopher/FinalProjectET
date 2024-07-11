class PetInAdopt {
  final int id;
  String jenis;
  String name;
  String description;
  String status;

   PetInAdopt(
      {required this.id,
      required this.jenis,
      required this.name,
      required this.description,
      required this.status});

  factory PetInAdopt.fromJson(Map<String, dynamic> json) {
    return PetInAdopt(
      id: json['id'] as int,
      jenis: json['jenis'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      status: json['status'] as String);
  }
}