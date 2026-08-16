import 'translation_keys.dart';

const Map<String, String> en = {
  // General
  Tr.appName: 'MediBook',
  Tr.tagline: 'Your health, our priority',
  Tr.error: 'Error',
  Tr.confirm: 'Confirm',
  Tr.yes: 'Yes',
  Tr.no: 'No',
  Tr.cancel: 'Cancel',
  Tr.name: 'Name',
  Tr.information: 'Information',
  Tr.notSpecified: 'Not specified',
  Tr.notifications: 'Notifications',

  // Auth
  Tr.login: 'Login',
  Tr.email: 'Email',
  Tr.password: 'Password',
  Tr.connect: 'Sign in',
  Tr.welcome: 'Welcome!',
  Tr.welcomeMessage: 'Your health, our priority',
  Tr.welcomeSubtitle: 'Sign in to book\nyour medical appointments',
  Tr.featuredDoctors: 'Featured Doctors',
  Tr.getStarted: 'Get Started',
  Tr.skip: 'Skip',
  Tr.fillAllFields: 'Please fill in all required fields',
  Tr.loginSuccess: 'Login successful',
  Tr.register: 'Register',
  Tr.firstName: 'First name',
  Tr.lastName: 'Last name',
  Tr.phoneNumber: 'Phone number',
  Tr.confirmPassword: 'Confirm password',
  Tr.createAccount: 'Create account',
  Tr.alreadyHaveAccount: 'Already have an account?',
  Tr.noAccount: 'Don\'t have an account?',
  Tr.registerSuccess: 'Registration successful',
  Tr.passwordMismatch: 'Passwords do not match',
  Tr.loginFailed:
      'The email or password is incorrect. Check your credentials and try again.',
  Tr.connectionError:
      'Unable to reach the server. Check your internet connection.',
  Tr.registerError:
      'Registration failed. This email address may already be in use.',
  Tr.disconnectConfirm: 'Are you sure you want to logout?',
  Tr.disconnect: 'Logout',
  Tr.forgotPassword: 'Forgot password?',
  Tr.forgotPasswordHint: 'Contact your medical office to reset your password.',

  // Navigation
  Tr.home: 'Home',
  Tr.appointments: 'Appointments',
  Tr.search: 'Search',
  Tr.profile: 'Profile',

  // Home
  Tr.hello: 'Hello',
  Tr.howAreYou: 'How are you today?',
  Tr.searchDoctorSpecialty: 'Search a doctor, specialty...',
  Tr.searchDoctorCabinet: 'Search a doctor, cabinet...',
  Tr.nextAppointment: 'Next appointment',
  Tr.seeAll: 'See all',
  Tr.quickAccess: 'Quick access',
  Tr.myProfile: 'My profile',
  Tr.myAppointments: 'My appointments',
  Tr.settings: 'Settings',
  Tr.logout: 'Logout',

  // Cabinets
  Tr.cabinets: 'Cabinets',
  Tr.medicalCabinets: 'Medical cabinets',
  Tr.cabinet: 'Cabinet',
  Tr.findNearby: 'Find a nearby cabinet',
  Tr.noCabinets: 'No cabinets found',
  Tr.comeBackLater: 'Come back later',
  Tr.address: 'Address',
  Tr.phone: 'Phone',

  // Specialties
  Tr.specialties: 'Specialties',
  Tr.browseBySpecialty: 'Browse by specialty',
  Tr.noSpecialties: 'No specialties found',

  // Doctors
  Tr.doctors: 'Doctors',
  Tr.doctor: 'Doctor',
  Tr.allAvailableDoctors: 'All available doctors',
  Tr.noDoctors: 'No doctors found',
  Tr.tryAnotherFilter: 'Try another filter',
  Tr.seeDoctors: 'See doctors',

  // Booking
  Tr.book: 'Book',
  Tr.chooseDate: 'Choose a date',
  Tr.availableSlots: 'Available slots',
  Tr.selectDate: 'Select a date',
  Tr.selectSlot: 'Select a time slot',
  Tr.selectSlotError: 'Please select a time slot',
  Tr.enterReasonError: 'Please enter a reason for consultation',
  Tr.consultationReason: 'Reason for consultation',
  Tr.describeReason: 'Describe the reason for your consultation...',
  Tr.reasonHint: 'Reason for consultation',
  Tr.confirmBooking: 'Confirm booking',
  Tr.confirmAppointment: 'Confirm appointment',
  Tr.bookingSuccess: 'Appointment booked successfully!',
  Tr.appointmentConfirmed: 'Appointment confirmed!',
  Tr.appointmentConfirmedMsg: 'Your appointment was confirmed immediately.',
  Tr.noSlots: 'No available slots',
  Tr.noSlotsThisWeek: 'No slots available this week',
  Tr.tryAnotherDate: 'Try another date',
  Tr.weekOf: 'Week of',
  Tr.previousWeek: 'Previous week',
  Tr.nextWeek: 'Next week',

  // Appointments
  Tr.all: 'All',
  Tr.pending: 'Pending',
  Tr.confirmed: 'Confirmed',
  Tr.history: 'History',
  Tr.date: 'Date',
  Tr.time: 'Time',
  Tr.reason: 'Reason',
  Tr.status: 'Status',
  Tr.appointmentDetails: 'Appointment details',
  Tr.noAppointments: 'No appointments',
  Tr.bookFirstAppointment: 'Book your first appointment!',
  Tr.cancelAppointment: 'Cancel appointment',
  Tr.cancelConfirm: 'Are you sure you want to cancel this appointment?',
  Tr.cancelIrreversible:
      'Are you sure you want to cancel this appointment? This action is irreversible.',
  Tr.cancelRdv: 'Cancel appointment',
  Tr.noKeep: 'No, keep it',
  Tr.yesCancel: 'Yes, cancel',
  Tr.appointmentCancelled: 'Appointment cancelled',
  Tr.appointmentCancelledMsg: 'The appointment has been cancelled successfully',
  Tr.appointmentCancelledText: 'This appointment has been cancelled',
  Tr.appointmentNotFound: 'Appointment not found',
  Tr.dateAndTime: 'Date & Time',

  // Status labels
  Tr.statusPending: 'Pending',
  Tr.statusConfirmed: 'Confirmed',
  Tr.statusCompleted: 'Completed',
  Tr.statusCancelled: 'Cancelled',

  // Profile
  Tr.editProfile: 'Edit profile',
  Tr.save: 'Save',
  Tr.success: 'Success',
  Tr.profileUpdated: 'Profile updated successfully',
  Tr.profileUpdateError: 'Profile update failed. Please try again.',

  // Validation errors
  Tr.emailRequired: 'Please enter your email address',
  Tr.emailInvalid: 'The email address is not valid (e.g. name@email.com)',
  Tr.passwordRequired: 'Please enter your password',
  Tr.passwordTooShort: 'Password must be at least 6 characters long',
  Tr.firstNameRequired: 'Please enter your first name',
  Tr.lastNameRequired: 'Please enter your last name',
  Tr.phoneRequired: 'Please enter your phone number',
  Tr.phoneInvalid: 'The phone number is not valid (e.g. 77 123 45 67)',
  Tr.motifTooShort:
      'The consultation reason must be at least 3 characters long',

  // Network errors
  Tr.networkError: 'No internet connection. Check your Wi-Fi or mobile data.',
  Tr.serverError:
      'The server is experiencing issues. Please try again shortly.',
  Tr.timeoutError:
      'The request took too long. Check your connection and try again.',
  Tr.sessionExpired: 'Your session has expired. Please log in again.',
  Tr.emailAlreadyUsed: 'This email address is already used by another account.',
  Tr.phoneAlreadyUsed: 'This phone number is already used by another account.',
  Tr.accountNotFound: 'No account found for this email address.',
  Tr.wrongPassword: 'The password is incorrect. Check and try again.',
  Tr.slotAlreadyTaken:
      'This slot was just booked by another patient. Choose a different time.',
  Tr.cannotCancelPast: 'Cannot cancel an appointment that has already passed.',

  // Error messages (viewmodels)
  Tr.loadingError: 'Unable to load data. Check your connection.',
  Tr.loadingCabinetsError:
      'Unable to load the list of cabinets. Check your connection.',
  Tr.loadingSpecialtiesError:
      'Unable to load specialties. Check your connection.',
  Tr.loadingDoctorsError:
      'Unable to load the list of doctors. Check your connection.',
  Tr.loadingDoctorError: 'Unable to load doctor information.',
  Tr.loadingSlotsError: 'Unable to load available slots. Try a different date.',
  Tr.loadingAppointmentsError:
      'Unable to load your appointments. Check your connection.',
  Tr.createAppointmentError:
      'Booking failed. This slot may no longer be available.',
  Tr.cancelAppointmentError:
      'Appointment cancellation failed. Please try again.',
  Tr.noResults: 'No results',
  Tr.allFilter: 'All',

  // Forgot / Reset password
  Tr.forgotPasswordTitle: 'Forgot Password',
  Tr.forgotPasswordDesc:
      'Enter your email address. You will receive a reset code.',
  Tr.sendCode: 'Send Code',
  Tr.resetCodeSent: 'A 6-digit code has been sent to your email.',
  Tr.resetCode: 'Reset Code',
  Tr.resetCodeHint: 'Enter the 6-digit code received by email',
  Tr.resetCodeInvalid: 'The code must contain 6 digits.',
  Tr.newPassword: 'New Password',
  Tr.confirmNewPassword: 'Confirm New Password',
  Tr.resetPassword: 'Reset Password',
  Tr.passwordResetSuccess: 'Password reset successfully. Please log in.',
  Tr.forgotPasswordError: 'Unable to send code. Check your email address.',
  Tr.resetPasswordError: 'Reset failed. Check your code.',
  Tr.backToLogin: 'Back to Login',
  Tr.darkMode: 'Dark Mode',

  // Photo upload
  Tr.changePhoto: 'Change photo',
  Tr.photoUploadSuccess: 'Profile photo updated',
  Tr.photoUploadError: 'Photo upload failed',
  Tr.choosePhotoSource: 'Photo source',
  Tr.camera: 'Camera',
  Tr.gallery: 'Gallery',
};
