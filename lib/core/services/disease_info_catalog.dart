import 'package:bitirme_mobile/l10n/app_localizations.dart';

final class DiseaseInfoCatalog {
  const DiseaseInfoCatalog();

  DiseaseInfo get(String diseaseKey, AppLocalizations l10n) {
    switch (diseaseKey) {
      case 'bacterial':
        return DiseaseInfo(
          description: l10n.diseaseDetailDescriptionBacterial,
          causes: l10n.diseaseDetailCausesBacterial,
          treatment: l10n.diseaseDetailTreatmentBacterial,
          prevention: l10n.diseaseDetailPreventionBacterial,
        );
      case 'blight':
        return DiseaseInfo(
          description: l10n.diseaseDetailDescriptionBlight,
          causes: l10n.diseaseDetailCausesBlight,
          treatment: l10n.diseaseDetailTreatmentBlight,
          prevention: l10n.diseaseDetailPreventionBlight,
        );
      case 'healthy':
        return DiseaseInfo(
          description: l10n.diseaseDetailDescriptionHealthy,
          causes: l10n.diseaseDetailCausesHealthy,
          treatment: l10n.diseaseDetailTreatmentHealthy,
          prevention: l10n.diseaseDetailPreventionHealthy,
        );
      case 'leaf_spot':
        return DiseaseInfo(
          description: l10n.diseaseDetailDescriptionLeafSpot,
          causes: l10n.diseaseDetailCausesLeafSpot,
          treatment: l10n.diseaseDetailTreatmentLeafSpot,
          prevention: l10n.diseaseDetailPreventionLeafSpot,
        );
      case 'mold':
        return DiseaseInfo(
          description: l10n.diseaseDetailDescriptionMold,
          causes: l10n.diseaseDetailCausesMold,
          treatment: l10n.diseaseDetailTreatmentMold,
          prevention: l10n.diseaseDetailPreventionMold,
        );
      case 'pest_damage':
        return DiseaseInfo(
          description: l10n.diseaseDetailDescriptionPestDamage,
          causes: l10n.diseaseDetailCausesPestDamage,
          treatment: l10n.diseaseDetailTreatmentPestDamage,
          prevention: l10n.diseaseDetailPreventionPestDamage,
        );
      case 'powdery_mildew':
        return DiseaseInfo(
          description: l10n.diseaseDetailDescriptionPowderyMildew,
          causes: l10n.diseaseDetailCausesPowderyMildew,
          treatment: l10n.diseaseDetailTreatmentPowderyMildew,
          prevention: l10n.diseaseDetailPreventionPowderyMildew,
        );
      case 'rot':
        return DiseaseInfo(
          description: l10n.diseaseDetailDescriptionRot,
          causes: l10n.diseaseDetailCausesRot,
          treatment: l10n.diseaseDetailTreatmentRot,
          prevention: l10n.diseaseDetailPreventionRot,
        );
      case 'rust':
        return DiseaseInfo(
          description: l10n.diseaseDetailDescriptionRust,
          causes: l10n.diseaseDetailCausesRust,
          treatment: l10n.diseaseDetailTreatmentRust,
          prevention: l10n.diseaseDetailPreventionRust,
        );
      case 'viral':
        return DiseaseInfo(
          description: l10n.diseaseDetailDescriptionViral,
          causes: l10n.diseaseDetailCausesViral,
          treatment: l10n.diseaseDetailTreatmentViral,
          prevention: l10n.diseaseDetailPreventionViral,
        );
      default:
        return DiseaseInfo(
          description: l10n.diseaseDetailDescriptionGeneric,
          causes: l10n.diseaseDetailCausesGeneric,
          treatment: l10n.diseaseDetailTreatmentGeneric,
          prevention: l10n.diseaseDetailPreventionGeneric,
        );
    }
  }
}

final class DiseaseInfo {
  const DiseaseInfo({
    required this.description,
    required this.causes,
    required this.treatment,
    required this.prevention,
  });

  final String description;
  final String causes;
  final String treatment;
  final String prevention;
}

