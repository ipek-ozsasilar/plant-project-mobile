import 'package:bitirme_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

extension L10nBuildContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
