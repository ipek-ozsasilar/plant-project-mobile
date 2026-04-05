import 'package:bitirme_mobile/l10n/app_localizations.dart';

/// [ScanFlowNotifier] `@@anahtar` biçimindeki mesajları [AppLocalizations] ile çözer.
String localizedScanFlowError(String message, AppLocalizations l10n) {
  if (!message.startsWith('@@')) {
    return message;
  }
  switch (message.substring(2)) {
    case 'scanRegionsSelectPrompt':
      return l10n.scanRegionsSelectPrompt;
    case 'errorCrop':
      return l10n.errorCrop;
    case 'errorInference':
      return l10n.errorInference;
    default:
      return message;
  }
}
