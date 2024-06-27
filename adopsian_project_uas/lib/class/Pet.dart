class Pet { //final itu hanya bisa diisi sekali disini
  final int id;
  String jenis;
  String name;
  String status;
  String description;
  int ownerId;
  int adopterId;

   Pet(
      {required this.id,
      required this.jenis,
      required this.name,
      required this.status,
      required this.description,
      required this.ownerId,
      required this.adopterId});

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] as int,
      jenis: json['jenis'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
      description: json['description'] as String,
      ownerId: json['users_id'] as int,
      adopterId: json['fix_adopter_id'] as int);
  }
}