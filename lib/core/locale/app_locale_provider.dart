import 'package:bitirme_mobile/core/constants/preference_keys.dart';
import 'package:bitirme_mobile/core/locale/app_locale_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Kalıcı dil tercihi ve ilk kurulum bayrağı.
class AppLocaleNotifier extends Notifier<AppLocaleMode> {
  static late AppLocaleMode _boot;

  /// [main] / [AppInitializers] içinde [runApp] öncesi çağrılmalıdır.
  static Future<void> preloadFromDisk() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool done = prefs.getBool(PreferenceKeys.languageSelectionDone) ?? false;
    final String? code = prefs.getString(PreferenceKeys.localeCode);
    if (!done) {
      _boot = const AppLocaleUnset();
    } else if (code == null || code == 'system') {
      _boot = const AppLocaleFollowSystem();
    } else if (code == 'en') {
      _boot = const AppLocaleFixed(Locale('en'));
    } else {
      _boot = const AppLocaleFixed(Locale('tr'));
    }
  }

  @override
  AppLocaleMode build() {
    return _boot;
  }

  Future<void> _persist({required String code, required bool markSelectionDone}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(PreferenceKeys.localeCode, code);
    if (markSelectionDone) {
      await prefs.setBool(PreferenceKeys.languageSelectionDone, true);
    }
  }

  /// İlk kurulum dil seçimi: Türkçe.
  Future<void> selectTurkishFirstRun() async {
    await _persist(code: 'tr', markSelectionDone: true);
    state = const AppLocaleFixed(Locale('tr'));
  }

  /// İlk kurulum dil seçimi: İngilizce.
  Future<void> selectEnglishFirstRun() async {
    await _persist(code: 'en', markSelectionDone: true);
    state = const AppLocaleFixed(Locale('en'));
  }

  /// Ayarlardan: sistem dili.
  Future<void> setFollowSystem() async {
    await _persist(code: 'system', markSelectionDone: false);
    state = const AppLocaleFollowSystem();
  }

  /// Ayarlardan: Türkçe.
  Future<void> setTurkish() async {
    await _persist(code: 'tr', markSelectionDone: false);
    state = const AppLocaleFixed(Locale('tr'));
  }

  /// Ayarlardan: İngilizce.
  Future<void> setEnglish() async {
    await _persist(code: 'en', markSelectionDone: false);
    state = const AppLocaleFixed(Locale('en'));
  }
}

final NotifierProvider<AppLocaleNotifier, AppLocaleMode> appLocaleProvider =
    NotifierProvider<AppLocaleNotifier, AppLocaleMode>(AppLocaleNotifier.new);
