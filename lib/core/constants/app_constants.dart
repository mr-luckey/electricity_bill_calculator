class AppConstants {
  static const discos = [
    'LESCO',
    'PESCO',
    'IESCO',
    'MEPCO',
    'GEPCO',
    'FESCO',
    'HESCO',
    'SEPCO',
    'QESCO',
    'TESCO',
    'HAZECO',
    'K-Electric',
  ];

  static const feedbackWhatsappNumber = '+923178831523';
  static const feedbackEmail = 'contact@appwaretech.com';
  static const privacyPolicyUrl =
      'https://drive.google.com/file/d/1VxKfrv1y1eiPkmT1RSF18p_XM2F48oza/view?usp=sharing';
  static const playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.appwaretech.meter.app';

  static const ratesStaleDays = 30;
}

enum ConsumerCategory { protected, unprotected }

enum AuthMethod { google, phone, email, guest, none }

enum AppThemeMode { light, dark, system }

enum LoginStatus { unknown, authenticated, unauthenticated }

extension ConsumerCategoryX on ConsumerCategory {
  String get key =>
      this == ConsumerCategory.protected ? 'protected' : 'unprotected';
}
