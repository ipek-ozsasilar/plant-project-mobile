import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:bitirme_mobile/core/services/auth_storage_service.dart';
import 'package:bitirme_mobile/core/services/google_sign_in_service.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Oturum durumu.
class AuthState {
  const AuthState({this.email, this.displayName});

  final String? email;
  final String? displayName;

  bool get isAuthenticated => email != null && email!.isNotEmpty;
}

/// Oturum: Firebase (Google) ve yerel e-posta oturumu.
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  Future<void> hydrate() async {
    final User? fb = FirebaseAuth.instance.currentUser;
    if (fb != null) {
      final String email = fb.email ?? '';
      final String name =
          fb.displayName ?? (email.contains('@') ? email.split('@').first : email);
      state = AuthState(email: email, displayName: name);
      final AuthStorageService svc = sl<AuthStorageService>();
      await svc.saveUser(email: email, name: name);
      return;
    }
    final AuthStorageService svc = sl<AuthStorageService>();
    final String? email = await svc.getEmail();
    final String? name = await svc.getName();
    state = AuthState(email: email, displayName: name);
  }

  Future<void> saveSession({required String email, required String name}) async {
    final AuthStorageService svc = sl<AuthStorageService>();
    await svc.saveUser(email: email, name: name);
    state = AuthState(email: email, displayName: name);
  }

  /// Google ile giriş. İptal veya hata durumunda `false`.
  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInService g = sl<GoogleSignInService>();
      final UserCredential? cred = await g.signInWithFirebase();
      if (cred?.user == null) {
        return false;
      }
      final User u = cred!.user!;
      final String email = u.email ?? '';
      final String name =
          u.displayName ?? (email.contains('@') ? email.split('@').first : email);
      await saveSession(email: email, name: name);
      return true;
    } catch (e, st) {
      sl<AppLogger>().e('Google sign-in', e, st);
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await sl<GoogleSignInService>().signOutGoogle();
      await FirebaseAuth.instance.signOut();
    } catch (e, st) {
      sl<AppLogger>().e('Logout', e, st);
    }
    final AuthStorageService svc = sl<AuthStorageService>();
    await svc.clearUser();
    state = const AuthState();
  }
}

final NotifierProvider<AuthNotifier, AuthState> authProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
