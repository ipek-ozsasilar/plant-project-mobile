import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/services/plantnet_species_name_repository.dart';
import 'package:bitirme_mobile/core/services/species_label_formatter.dart';
import 'package:bitirme_mobile/l10n/app_localizations.dart';
import 'package:bitirme_mobile/models/inference_result_model.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:flutter/widgets.dart';

/// Model sınıf anahtarı (`plantnet__…`, `leafsnap__…`) → kullanıcıya gösterilecek metin.
String speciesClassDisplayForExport(AppLocalizations l10n, String rawClass) {
  final String raw = rawClass.trim();
  if (raw.isEmpty) {
    return '';
  }
  final Map<String, String> map = sl<PlantnetSpeciesNameRepository>().snapshot;
  // Eski kayıtlarda yalnızca sayısal ID saklanmış olabilir.
  final String effectiveRaw =
      RegExp(r'^\d+$').hasMatch(raw) ? 'plantnet__$raw' : raw;
  if (effectiveRaw.startsWith('plantnet__')) {
    final String id = effectiveRaw.split('__').last;
    final String? n = map[id];
    if (n != null && n.trim().isNotEmpty) {
      return n.trim();
    }
    return l10n.speciesPlantNetUnmapped(id);
  }
  return formatSpeciesRawLabel(effectiveRaw, plantnetMap: map);
}

/// [BuildContext] ile: tarama sonucu satırı için görünen ad.
String speciesInferenceTopForUi(BuildContext context, InferenceClassScoreModel score) {
  final String raw = score.rawKey ?? score.label;
  return speciesClassDisplayForExport(context.l10n, raw);
}

/// Kayıtlı ham etiket (geçmiş, liste) → ekranda gösterim.
String speciesClassDisplayForRaw(BuildContext context, String rawClass) {
  return speciesClassDisplayForExport(context.l10n, rawClass);
}
