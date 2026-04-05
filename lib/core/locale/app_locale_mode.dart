import 'package:flutter/material.dart';

/// Dil tercihi: ilk kurulum, sistem veya sabit [Locale].
sealed class AppLocaleMode {
  const AppLocaleMode();
}

/// Henüz dil seçilmedi (ilk açılış); [MaterialApp] geçici olarak Türkçe yükler.
final class AppLocaleUnset extends AppLocaleMode {
  const AppLocaleUnset();
}

/// İşletim sistemi diline uy (desteklenenler: tr, en).
final class AppLocaleFollowSystem extends AppLocaleMode {
  const AppLocaleFollowSystem();
}

/// Kullanıcının seçtiği sabit dil.
final class AppLocaleFixed extends AppLocaleMode {
  const AppLocaleFixed(this.locale);

  final Locale locale;
}

/// [MaterialApp.locale]; sistem modunda `null`.
Locale? materialLocaleFor(AppLocaleMode mode) {
  return switch (mode) {
    AppLocaleUnset() => const Locale('tr'),
    AppLocaleFollowSystem() => null,
    AppLocaleFixed(:final Locale locale) => locale,
  };
}
