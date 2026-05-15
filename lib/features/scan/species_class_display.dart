import 'package:flutter/material.dart';
import 'package:bitirme_mobile/l10n/app_localizations.dart';
import 'package:bitirme_mobile/models/inference_result_model.dart';

// Bu harita, tür ID'lerini yaygın adlara eşler.
// Uygulamanızdaki tüm türler için bu haritayı genişletmeniz gerekmektedir.
// İdeal olarak, bu veriler bir JSON dosyasından veya bir veritabanından yüklenmelidir.
const Map<String, String> _speciesCommonNames = {
  'plantnet__1389307': 'Sedum pachyphyllum',
  'plantnet__1369960': 'Tradescantia spathacea',
  'plantnet__1385937': 'Zamioculcas zamiifolia',
  'plantnet__1372016': 'Morinda citrifolia',
  'plantnet__1391963': 'Epipactis palustris',
  'plantnet__1359525': 'Fragaria vesca',
  'plantnet__1389297': 'Cereus jamacaru',
  'plantnet__1391797': 'Dryas octopetala',
  'plantnet__1393241': 'Hypericum calycinum',
  'plantnet__1363490': 'Agave americana',
  'plantnet__1391483': 'Cucurbita maxima',
  'plantnet__1391192': 'Cirsium eriophorum',
  'plantnet__1363110': 'Ceanothus thyrsiflorus',
  'plantnet__1359517': 'Trifolium pratense',
  'plantnet__1363336': 'Jasminum officinale',
  'plantnet__1391226': 'Cirsium oleraceum',
  'plantnet__1374048': 'Tagetes erecta',
  'plantnet__1392695': 'Hebe salicifolia',
  'plantnet__1363740': 'Trifolium repens',
  'plantnet__1364099': 'Centranthus ruber',
  'plantnet__1361823': 'Magnolia kobus',
  'plantnet__1360998': 'Callistemon citrinus',
  'plantnet__1392777': 'Hippophae rhamnoides',
  'plantnet__1363778': 'Acacia retinodes',
  'plantnet__1392654': 'Gomphocarpus physocarpus',
  'plantnet__1357330': 'Pinus sylvestris',
  'plantnet__1363021': 'Pistacia lentiscus',
  'plantnet__1361847': 'Liriodendron tulipifera',
  'plantnet__1355868': 'Rosa canina',
  'plantnet__1359669': 'Wisteria sinensis',
  // ... Diğer türleri buraya ekleyin
};

/// Ham tür etiketini (örneğin 'plantnet__1389307') görüntülenebilir yaygın bir ada dönüştürür.
/// Yaygın ad bulunamazsa ham etiketi döndürür.
String speciesClassDisplayForRaw(BuildContext context, String rawSpeciesLabel) {
  final AppLocalizations l10n = AppLocalizations.of(context)!;

  // 'Tanınmadı' veya 'unknown' gibi özel durumları kontrol et
  if (rawSpeciesLabel.toLowerCase().contains('unknown') ||
      rawSpeciesLabel.toLowerCase().contains('tanınmadı')) {
    return l10n.scanUnrecognizedTitle;
  }

  // Hardcoded haritada yaygın adı ara
  final String? commonName = _speciesCommonNames[rawSpeciesLabel];
  if (commonName != null) {
    return commonName;
  }

  // Bulunamazsa, son çare olarak ham etiketi döndür.
  return rawSpeciesLabel;
}

/// UI gösterimi için ham tür etiketini dönüştürür, yerelleştirilmiş adları kullanabilir.
/// Bu fonksiyon özellikle `InferenceClassScoreModel` nesneleri içindir.
String speciesInferenceTopForUi(
  BuildContext context,
  InferenceClassScoreModel top,
) {
  final AppLocalizations l10n = AppLocalizations.of(context)!;
  final String rawLabel = top.rawKey ?? top.label;

  if (rawLabel.toLowerCase().contains('unknown') ||
      rawLabel.toLowerCase().contains('tanınmadı')) {
    return l10n.scanUnrecognizedTitle;
  }

  final String? commonName = _speciesCommonNames[rawLabel];
  if (commonName != null) {
    return commonName;
  }

  return top.label;
}

/// PDF gibi dışa aktarım amaçları için ham tür etiketini dönüştürür.
/// Yaygın ad bulunamazsa ham etiketi döndürür.
String speciesClassDisplayForExport(
  AppLocalizations l10n,
  String rawSpeciesLabel,
) {
  return speciesClassDisplayForRaw(
    null as BuildContext,
    rawSpeciesLabel,
  ); // Context'e ihtiyaç duymayan bir versiyon için
  // veya doğrudan _speciesCommonNames haritasını kullanabilirsiniz.
}
