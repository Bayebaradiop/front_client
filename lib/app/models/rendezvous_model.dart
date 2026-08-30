class RendezVousModel {
  final int? id;
  final String? statut;
  final String? motif;
  final String? date;
  final String? heureDebut;
  final String? heureFin;
  final int? medecinId;
  final String? medecinNom;
  final String? medecinPrenom;
  final String? medecinSpecialite;
  final String? medecinPhoto;
  final int? cabinetId;
  final String? cabinetNom;
  final String? cabinetAdresse;

  RendezVousModel({
    this.id,
    this.statut,
    this.motif,
    this.date,
    this.heureDebut,
    this.heureFin,
    this.medecinId,
    this.medecinNom,
    this.medecinPrenom,
    this.medecinSpecialite,
    this.medecinPhoto,
    this.cabinetId,
    this.cabinetNom,
    this.cabinetAdresse,
  });

  factory RendezVousModel.fromJson(Map<String, dynamic> json) {
    return RendezVousModel(
      id: json['id'],
      statut: json['statut'],
      motif: json['motif'],
      date: json['date'],
      heureDebut: json['heureDebut'],
      heureFin: json['heureFin'],
      medecinId: json['medecinId'],
      medecinNom: json['medecinNom'],
      medecinPrenom: json['medecinPrenom'],
      medecinSpecialite: json['medecinSpecialite'],
      medecinPhoto: json['medecinPhoto'],
      cabinetId: json['cabinetId'],
      cabinetNom: json['cabinetNom'],
      cabinetAdresse: json['cabinetAdresse'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'statut': statut,
      'motif': motif,
      'date': date,
      'heureDebut': heureDebut,
      'heureFin': heureFin,
      'medecinId': medecinId,
      'medecinNom': medecinNom,
      'medecinPrenom': medecinPrenom,
      'medecinSpecialite': medecinSpecialite,
      'medecinPhoto': medecinPhoto,
      'cabinetId': cabinetId,
      'cabinetNom': cabinetNom,
      'cabinetAdresse': cabinetAdresse,
    };
  }
}
