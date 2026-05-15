import 'package:bitirme_mobile/l10n/app_localizations.dart';

/// [disease_class_names_5class.json] anahtarını arayüz metnine çevirir.
String diseaseClassKeyToDisplay(String key, AppLocalizations l10n) {
  switch (key) {
    case 'blight':
      return l10n.inferenceDiseaseBlight;
    case 'chlorosis_yellowing':
      return l10n.inferenceDiseaseChlorosisYellowing;
    case 'healthy':
      return l10n.inferenceDiseaseHealthy;
    case 'leaf_damage':
      return l10n.inferenceDiseaseLeafDamage;
    case 'mold':
      return l10n.inferenceDiseaseMold;
    case 'pest_damage':
      return l10n.inferenceDiseasePestDamage;
    case 'powdery_mildew':
      return l10n.inferenceDiseasePowderyMildew;
    case 'rot':
      return l10n.inferenceDiseaseRot;
    case 'rust':
      return l10n.inferenceDiseaseRust;
    case 'scab':
      return l10n.inferenceDiseaseScab;
    case 'viral_mosaic':
      return l10n.inferenceDiseaseViralMosaic;
    default:
      return key.replaceAll('_', ' ');
  }
}

/// Geçmişte Türkçe metin saklanmış kayıtlar için: anahtar biçimindeyse çevir.
String displayStoredDiseaseLabel(String stored, AppLocalizations l10n) {
  if (RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(stored)) {
    return diseaseClassKeyToDisplay(stored, l10n);
  }
  return stored;
}
