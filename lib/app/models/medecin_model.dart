class MedecinModel {
  final int? id;
  final String? prenom;
  final String? nom;
  final String? photo;
  final String? telephone;
  final String? email;
  final int? specialiteId;
  final String? specialiteNom;
  final int? cabinetId;
  final String? cabinetNom;

  MedecinModel({
    this.id,
    this.prenom,
    this.nom,
    this.photo,
    this.telephone,
    this.email,
    this.specialiteId,
    this.specialiteNom,
    this.cabinetId,
    this.cabinetNom,
  });

  factory MedecinModel.fromJson(Map<String, dynamic> json) {
    return MedecinModel(
      id: json['id'],
      prenom: json['prenom'],
      nom: json['nom'],
      photo: json['photo'],
      telephone: json['telephone'],
      email: json['email'],
      specialiteId: json['specialiteId'],
      specialiteNom: json['specialiteNom'],
      cabinetId: json['cabinetId'],
      cabinetNom: json['cabinetNom'],
    );
  }
}
