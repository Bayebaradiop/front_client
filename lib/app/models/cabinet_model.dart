class CabinetModel {
  final int? id;
  final String? nom;
  final String? logo;
  final String? adresse;
  final String? telephone;
  final String? email;
  final String? couleurPrimaire;
  final String? couleurSecondaire;

  CabinetModel({
    this.id,
    this.nom,
    this.logo,
    this.adresse,
    this.telephone,
    this.email,
    this.couleurPrimaire,
    this.couleurSecondaire,
  });

  factory CabinetModel.fromJson(Map<String, dynamic> json) {
    return CabinetModel(
      id: json['id'],
      nom: json['nom'],
      logo: json['logo'],
      adresse: json['adresse'],
      telephone: json['telephone'],
      email: json['email'],
      couleurPrimaire: json['couleurPrimaire'],
      couleurSecondaire: json['couleurSecondaire'],
    );
  }

}
