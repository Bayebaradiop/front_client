class AuthModel {
  final int? id;
  final String? prenom;
  final String? nom;
  final String? email;
  final String? role;

  AuthModel({
    this.id,
    this.prenom,
    this.nom,
    this.email,
    this.role,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      id: json['id'],
      prenom: json['prenom'],
      nom: json['nom'],
      email: json['email'],
      role: json['role'],
    );
  }
}
