import 'translation_keys.dart';

const Map<String, String> fr = {
  // General
  Tr.appName: 'MediBook',
  Tr.tagline: 'Votre santé, notre priorité',
  Tr.error: 'Erreur',
  Tr.confirm: 'Confirmer',
  Tr.yes: 'Oui',
  Tr.no: 'Non',
  Tr.cancel: 'Annuler',
  Tr.name: 'Nom',
  Tr.information: 'Informations',
  Tr.notSpecified: 'Non spécifié',
  Tr.notifications: 'Notifications',

  // Auth
  Tr.login: 'Connexion',
  Tr.email: 'Email',
  Tr.password: 'Mot de passe',
  Tr.connect: 'Se connecter',
  Tr.welcome: 'Bienvenue !',
  Tr.welcomeMessage: 'Votre santé, notre priorité',
  Tr.welcomeSubtitle: 'Connectez-vous pour prendre\nvos rendez-vous médicaux',
  Tr.featuredDoctors: 'Médecins en vedette',
  Tr.getStarted: 'Commencer',
  Tr.skip: 'Passer',
  Tr.fillAllFields: 'Veuillez remplir tous les champs obligatoires',
  Tr.loginSuccess: 'Connexion réussie',
  Tr.register: 'Inscription',
  Tr.firstName: 'Prénom',
  Tr.lastName: 'Nom',
  Tr.phoneNumber: 'Téléphone',
  Tr.confirmPassword: 'Confirmer le mot de passe',
  Tr.createAccount: 'Créer un compte',
  Tr.alreadyHaveAccount: 'Vous avez déjà un compte ?',
  Tr.noAccount: 'Pas encore de compte ?',
  Tr.registerSuccess: 'Inscription réussie',
  Tr.passwordMismatch: 'Les mots de passe ne correspondent pas',
  Tr.loginFailed:
      'L\'email ou le mot de passe est incorrect. Vérifiez vos identifiants et réessayez.',
  Tr.connectionError:
      'Impossible de contacter le serveur. Vérifiez votre connexion internet.',
  Tr.registerError:
      'L\'inscription a échoué. Cette adresse email est peut-être déjà utilisée.',
  Tr.disconnectConfirm: 'Êtes-vous sûr de vouloir vous déconnecter ?',
  Tr.disconnect: 'Déconnexion',
  Tr.forgotPassword: 'Mot de passe oublié ?',
  Tr.forgotPasswordHint:
      'Contactez votre cabinet médical pour réinitialiser votre mot de passe.',

  // Navigation
  Tr.home: 'Accueil',
  Tr.appointments: 'Rendez-vous',
  Tr.search: 'Recherche',
  Tr.profile: 'Profil',

  // Home
  Tr.hello: 'Bonjour',
  Tr.howAreYou: 'Comment allez-vous aujourd\'hui ?',
  Tr.searchDoctorSpecialty: 'Rechercher un médecin, spécialité...',
  Tr.searchDoctorCabinet: 'Rechercher un médecin, cabinet...',
  Tr.nextAppointment: 'Prochain rendez-vous',
  Tr.seeAll: 'Voir tout',
  Tr.quickAccess: 'Accès rapide',
  Tr.myProfile: 'Mon profil',
  Tr.myAppointments: 'Mes rendez-vous',
  Tr.settings: 'Paramètres',
  Tr.logout: 'Se déconnecter',

  // Cabinets
  Tr.cabinets: 'Cabinets',
  Tr.medicalCabinets: 'Cabinets médicaux',
  Tr.cabinet: 'Cabinet',
  Tr.findNearby: 'Trouver un cabinet proche',
  Tr.noCabinets: 'Aucun cabinet trouvé',
  Tr.comeBackLater: 'Revenez plus tard',
  Tr.address: 'Adresse',
  Tr.phone: 'Téléphone',

  // Specialties
  Tr.specialties: 'Spécialités',
  Tr.browseBySpecialty: 'Parcourir par spécialité',
  Tr.noSpecialties: 'Aucune spécialité trouvée',

  // Doctors
  Tr.doctors: 'Médecins',
  Tr.doctor: 'Médecin',
  Tr.allAvailableDoctors: 'Tous les médecins disponibles',
  Tr.noDoctors: 'Aucun médecin trouvé',
  Tr.tryAnotherFilter: 'Essayez un autre filtre',
  Tr.seeDoctors: 'Voir les médecins',

  // Booking
  Tr.book: 'Réserver',
  Tr.chooseDate: 'Choisir une date',
  Tr.availableSlots: 'Créneaux disponibles',
  Tr.selectDate: 'Sélectionnez une date',
  Tr.selectSlot: 'Sélectionnez un créneau',
  Tr.selectSlotError: 'Veuillez sélectionner un créneau',
  Tr.enterReasonError: 'Veuillez saisir un motif de consultation',
  Tr.consultationReason: 'Motif de consultation',
  Tr.describeReason: 'Décrivez le motif de votre consultation...',
  Tr.reasonHint: 'Motif de la consultation',
  Tr.confirmBooking: 'Confirmer la réservation',
  Tr.confirmAppointment: 'Confirmer le rendez-vous',
  Tr.bookingSuccess: 'Rendez-vous réservé avec succès !',
  Tr.appointmentConfirmed: 'Rendez-vous confirmé !',
  Tr.appointmentConfirmedMsg: 'Votre rendez-vous a été pris avec succès',
  Tr.noSlots: 'Aucun créneau disponible',
  Tr.noSlotsThisWeek: 'Aucun créneau disponible cette semaine',
  Tr.tryAnotherDate: 'Essayez une autre date',
  Tr.weekOf: 'Semaine du',
  Tr.previousWeek: 'Semaine précédente',
  Tr.nextWeek: 'Semaine suivante',

  // Appointments
  Tr.all: 'Tous',
  Tr.pending: 'En attente',
  Tr.confirmed: 'Confirmés',
  Tr.history: 'Historique',
  Tr.date: 'Date',
  Tr.time: 'Heure',
  Tr.reason: 'Motif',
  Tr.status: 'Statut',
  Tr.appointmentDetails: 'Détails du rendez-vous',
  Tr.noAppointments: 'Aucun rendez-vous',
  Tr.bookFirstAppointment: 'Prenez votre premier rendez-vous !',
  Tr.cancelAppointment: 'Annuler le rendez-vous',
  Tr.cancelConfirm: 'Êtes-vous sûr de vouloir annuler ce rendez-vous ?',
  Tr.cancelIrreversible:
      'Êtes-vous sûr de vouloir annuler ce rendez-vous ? Cette action est irréversible.',
  Tr.cancelRdv: 'Annuler le RDV',
  Tr.noKeep: 'Non, garder',
  Tr.yesCancel: 'Oui, annuler',
  Tr.appointmentCancelled: 'Rendez-vous annulé',
  Tr.appointmentCancelledMsg: 'Le rendez-vous a été annulé avec succès',
  Tr.appointmentCancelledText: 'Ce rendez-vous a été annulé',
  Tr.appointmentNotFound: 'Rendez-vous non trouvé',
  Tr.dateAndTime: 'Date & Heure',

  // Status labels
  Tr.statusPending: 'En attente',
  Tr.statusConfirmed: 'Confirmé',
  Tr.statusCompleted: 'Terminé',
  Tr.statusCancelled: 'Annulé',

  // Profile
  Tr.editProfile: 'Modifier le profil',
  Tr.save: 'Enregistrer',
  Tr.success: 'Succès',
  Tr.profileUpdated: 'Profil mis à jour avec succès',
  Tr.profileUpdateError:
      'La mise à jour du profil a échoué. Veuillez réessayer.',

  // Validation erreurs précises
  Tr.emailRequired: 'Veuillez saisir votre adresse email',
  Tr.emailInvalid: "L'adresse email n'est pas valide (ex: nom@email.com)",
  Tr.passwordRequired: 'Veuillez saisir votre mot de passe',
  Tr.passwordTooShort: 'Le mot de passe doit contenir au moins 6 caractères',
  Tr.firstNameRequired: 'Veuillez saisir votre prénom',
  Tr.lastNameRequired: 'Veuillez saisir votre nom de famille',
  Tr.phoneRequired: 'Veuillez saisir votre numéro de téléphone',
  Tr.phoneInvalid: "Le numéro de téléphone n'est pas valide (ex: 77 123 45 67)",
  Tr.motifTooShort:
      'Le motif de consultation doit contenir au moins 3 caractères',

  // Erreurs réseau précises
  Tr.networkError:
      'Pas de connexion internet. Vérifiez votre Wi-Fi ou vos données mobiles.',
  Tr.serverError:
      'Le serveur rencontre un problème. Veuillez réessayer dans quelques instants.',
  Tr.timeoutError:
      'La requête a pris trop de temps. Vérifiez votre connexion et réessayez.',
  Tr.sessionExpired: 'Votre session a expiré. Veuillez vous reconnecter.',
  Tr.emailAlreadyUsed:
      "Cette adresse email est déjà utilisée par un autre compte.",
  Tr.phoneAlreadyUsed:
      "Ce numéro de téléphone est déjà utilisé par un autre compte.",
  Tr.accountNotFound: 'Aucun compte ne correspond à cette adresse email.',
  Tr.wrongPassword: 'Le mot de passe est incorrect. Vérifiez et réessayez.',
  Tr.slotAlreadyTaken:
      "Ce créneau vient d'être réservé par un autre patient. Choisissez un autre horaire.",
  Tr.cannotCancelPast: "Impossible d'annuler un rendez-vous déjà passé.",

  // Error messages (viewmodels)
  Tr.loadingError:
      'Impossible de charger les données. Vérifiez votre connexion.',
  Tr.loadingCabinetsError:
      'Impossible de charger la liste des cabinets. Vérifiez votre connexion.',
  Tr.loadingSpecialtiesError:
      'Impossible de charger les spécialités. Vérifiez votre connexion.',
  Tr.loadingDoctorsError:
      'Impossible de charger la liste des médecins. Vérifiez votre connexion.',
  Tr.loadingDoctorError: "Impossible de charger les informations du médecin.",
  Tr.loadingSlotsError:
      'Impossible de charger les créneaux disponibles. Essayez une autre date.',
  Tr.loadingAppointmentsError:
      'Impossible de charger vos rendez-vous. Vérifiez votre connexion.',
  Tr.createAppointmentError:
      "La prise de rendez-vous a échoué. Ce créneau n'est peut-être plus disponible.",
  Tr.cancelAppointmentError:
      "L'annulation du rendez-vous a échoué. Veuillez réessayer.",
  Tr.noResults: 'Aucun résultat',
  Tr.allFilter: 'Toutes',

  // Forgot / Reset password
  Tr.forgotPasswordTitle: 'Mot de passe oublié',
  Tr.forgotPasswordDesc:
      'Entrez votre adresse email. Vous recevrez un code de réinitialisation.',
  Tr.sendCode: 'Envoyer le code',
  Tr.resetCodeSent: 'Un code de 6 chiffres a été envoyé à votre email.',
  Tr.resetCode: 'Code de réinitialisation',
  Tr.resetCodeHint: 'Entrez le code à 6 chiffres reçu par email',
  Tr.resetCodeInvalid: 'Le code doit contenir 6 chiffres.',
  Tr.newPassword: 'Nouveau mot de passe',
  Tr.confirmNewPassword: 'Confirmer le nouveau mot de passe',
  Tr.resetPassword: 'Réinitialiser',
  Tr.passwordResetSuccess:
      'Mot de passe réinitialisé avec succès. Connectez-vous.',
  Tr.forgotPasswordError: "Impossible d'envoyer le code. Vérifiez votre email.",
  Tr.resetPasswordError: 'Échec de la réinitialisation. Vérifiez votre code.',
  Tr.backToLogin: 'Retour à la connexion',
  Tr.darkMode: 'Mode sombre',

  // Photo upload
  Tr.changePhoto: 'Changer la photo',
  Tr.photoUploadSuccess: 'Photo de profil mise à jour',
  Tr.photoUploadError: 'Échec du téléchargement de la photo',
  Tr.choosePhotoSource: 'Source de la photo',
  Tr.camera: 'Caméra',
  Tr.gallery: 'Galerie',
};
