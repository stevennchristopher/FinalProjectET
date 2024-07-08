class PetInOffer {
  final int id;
  String jenis;
  String name;
  String status;
  String description;
  int ownerId;
  String adopterName;
  int totalProposal;

   PetInOffer(
      {required this.id,
      required this.jenis,
      required this.name,
      required this.status,
      required this.description,
      required this.ownerId,
      required this.adopterName,
      required this.totalProposal});

  factory PetInOffer.fromJson(Map<String, dynamic> json) {
    return PetInOffer(
      id: json['id'] as int,
      jenis: json['jenis'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
      description: json['description'] as String,
      ownerId: json['users_id'] as int,
      adopterName: json['username'] as String,
      totalProposal: json['total_proposals'] as int);
  }
}