import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

/// Classe de localisation personnalisée pour MaBoutique.ma
/// Supporte 4 langues : Arabe (ar), Français (fr), Darija (tz), Amazigh (am)
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// Récupère l’instance de localisation dans le contexte actuel
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // Dictionnaire statique des traductions
  static final Map<String, Map<String, String>> _localizedValues = {
    'ar': {
      'appTitle': 'ما بوتيك',
      'welcomeMessage': 'مرحبًا بك في MaBoutique.ma',
      'locationPermission': 'يرجى تفعيل مشاركة الموقع للسماح للتطبيق بالوصول إلى موقعك.',
      'enableLocation': 'تفعيل الموقع',
    },
    'fr': {
      'appTitle': 'MaBoutique',
      'welcomeMessage': 'Bienvenue sur MaBoutique.ma',
      'locationPermission': 'Veuillez activer le partage de position pour permettre l\'accès à votre localisation.',
      'enableLocation': 'Activer la localisation',
    },
    'tz': {
      'appTitle': 'MaBoutique',
      'welcomeMessage': 'مرحبا بك في MaBoutique.ma (الدارجة)',
      'locationPermission': 'عفاك فعل مشاركة الموقع باش التطبيق يقدر يوصل لموقعك.',
      'enableLocation': 'فعل الموقع',
    },
    'am': {
      'appTitle': 'MaBoutique',
      'welcomeMessage': 'ⵣⴰⵢⵢⴰⵔ ⵏ MaBoutique.ma',
      'locationPermission': 'ⵣⵓⵍⴰⵢ ⵏ ⵍⵎⵓⵙⴻⵏ ⵏ ⵡⴰⵢⵢⵓ ⵓⴷⵔⴰ ⵢⵏ ⴰⵙⵙⵓⵍ ⴷ MaBoutique.ma.',
      'enableLocation': 'ⴰⵣⵓⵍ ⵏ ⵡⴰⵢⵢⵓ',
    },
  };

  /// Méthode générique pour récupérer une traduction par clé
  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  /// Clés les plus utilisées
  String get appTitle => translate('appTitle');
  String get welcomeMessage => translate('welcomeMessage');
  String get locationPermission => translate('locationPermission');
  String get enableLocation => translate('enableLocation');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ar', 'fr', 'tz', 'am'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    // Chargement synchrone ici
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
