class CreneauModel {
  final int? id;
  final String? date;
  final String? heureDebut;
  final String? heureFin;
  final bool? disponible;
  final int? medecinId;
  final String? medecinNom;
  final String? medecinPrenom;

  CreneauModel({
    this.id,
    this.date,
    this.heureDebut,
    this.heureFin,
    this.disponible,
    this.medecinId,
    this.medecinNom,
    this.medecinPrenom,
  });

  factory CreneauModel.fromJson(Map<String, dynamic> json) {
    return CreneauModel(
      id: json['id'],
      date: json['date'],
      heureDebut: json['heureDebut'],
      heureFin: json['heureFin'],
      disponible: json['disponible'],
      medecinId: json['medecinId'],
      medecinNom: json['medecinNom'],
      medecinPrenom: json['medecinPrenom'],
    );
  }
}
