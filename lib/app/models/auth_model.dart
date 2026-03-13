class AuthModel {
  final int? id;
  final String? prenom;
  final String? nom;
  final String? email;
  final String? telephone;
  final String? photo;
  final String? role;

  AuthModel({
    this.id,
    this.prenom,
    this.nom,
    this.email,
    this.telephone,
    this.photo,
    this.role,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      id: json['id'],
      prenom: json['prenom'],
      nom: json['nom'],
      email: json['email'],
      telephone: json['telephone'],
      photo: json['photo'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prenom': prenom,
      'nom': nom,
      'email': email,
      'telephone': telephone,
      'photo': photo,
      'role': role,
    };
  }
}
