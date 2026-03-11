class SpecialiteModel {
  final int? id;
  final String? nom;
  final String? description;
  final int? cabinetId;
  final String? cabinetNom;

  SpecialiteModel({
    this.id,
    this.nom,
    this.description,
    this.cabinetId,
    this.cabinetNom,
  });

  factory SpecialiteModel.fromJson(Map<String, dynamic> json) {
    return SpecialiteModel(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
      cabinetId: json['cabinetId'],
      cabinetNom: json['cabinetNom'],
    );
  }
}
