import 'package:bitirme_mobile/core/constants/preference_keys.dart';
import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Basit oturum ve onboarding bayrakları.
class AuthStorageService {
  AuthStorageService({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;

  Future<bool> isLanguageSelectionComplete() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool(PreferenceKeys.languageSelectionDone) ?? false;
    } catch (e, st) {
      _logger.e('storage_language_flag', e, st);
      return false;
    }
  }

  static const String _keyOnboarding = 'onboarding_done';
  static const String _keyEmail = 'user_email';
  static const String _keyName = 'user_name';
  static const String _keyUid = 'user_uid';

  Future<bool> hasCompletedOnboarding() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyOnboarding) ?? false;
    } catch (e, st) {
      _logger.e('storage', e, st);
      return false;
    }
  }

  Future<void> setOnboardingCompleted() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyOnboarding, true);
    } catch (e, st) {
      _logger.e('storage', e, st);
    }
  }

  Future<String?> getEmail() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyEmail);
    } catch (e, st) {
      _logger.e('storage', e, st);
      return null;
    }
  }

  Future<String?> getUid() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyUid);
    } catch (e, st) {
      _logger.e('storage', e, st);
      return null;
    }
  }

  Future<String?> getName() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyName);
    } catch (e, st) {
      _logger.e('storage', e, st);
      return null;
    }
  }

  Future<void> saveUser({required String uid, required String email, required String name}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUid, uid);
      await prefs.setString(_keyEmail, email);
      await prefs.setString(_keyName, name);
    } catch (e, st) {
      _logger.e('storage', e, st);
    }
  }

  Future<void> clearUser() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyUid);
      await prefs.remove(_keyEmail);
      await prefs.remove(_keyName);
    } catch (e, st) {
      _logger.e('storage', e, st);
    }
  }
}
