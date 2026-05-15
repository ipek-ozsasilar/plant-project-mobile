import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:bitirme_mobile/core/services/auth_storage_service.dart';
import 'package:bitirme_mobile/core/services/firebase_auth_error_mapper.dart';
import 'package:bitirme_mobile/core/services/firestore_setup_service.dart';
import 'package:bitirme_mobile/core/services/google_sign_in_service.dart';
import 'package:bitirme_mobile/core/services/user_profile_firestore_service.dart';
import 'package:bitirme_mobile/l10n/app_localizations.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Oturum durumu.
class AuthState {
  const AuthState({this.uid, this.email, this.displayName, this.isInitialized = false});

  final String? uid;
  final String? email;
  final String? displayName;
  final bool isInitialized;

  bool get isAuthenticated => email != null && email!.isNotEmpty;
}

/// Oturum: Firebase (e-posta/şifre, Google) ve yerel önbellek.
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  Future<void> hydrate() async {
    final User? fb = FirebaseAuth.instance.currentUser;
    if (fb != null) {
      final String uid = fb.uid;
      final String email = fb.email ?? '';
      final String name =
          fb.displayName ?? (email.contains('@') ? email.split('@').first : email);
      state = AuthState(uid: uid, email: email, displayName: name, isInitialized: true);
      final AuthStorageService svc = sl<AuthStorageService>();
      await svc.saveUser(uid: uid, email: email, name: name);
      return;
    }
    final AuthStorageService svc = sl<AuthStorageService>();
    final String? savedUid = await svc.getUid();
    final String? savedEmail = await svc.getEmail();
    final String? savedName = await svc.getName();
    state = AuthState(uid: savedUid, email: savedEmail, displayName: savedName, isInitialized: true);
  }

  Future<void> saveSession({required String uid, required String email, required String name}) async {
    final AuthStorageService svc = sl<AuthStorageService>();
    await svc.saveUser(uid: uid, email: email, name: name);
    state = AuthState(uid: uid, email: email, displayName: name);
    state = AuthState(uid: uid, email: email, displayName: name, isInitialized: true);
  }

  /// E-posta/şifre girişi. Başarıda `null`, aksi halde gösterilecek mesaj.
  Future<String?> signInWithEmailPassword(
    String email,
    String password,
    AppLocalizations l10n,
  ) async {
    try {
      final UserCredential cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? u = cred.user;
      if (u == null) {
        return l10n.errorAuth;
      }
      final String uid = u.uid;
      final String e = u.email ?? email;
      final String name =
          u.displayName ?? (e.contains('@') ? e.split('@').first : e);
      await saveSession(uid: uid, email: e, name: name);
      await sl<UserProfileFirestoreService>().upsertFromFirebaseUser(
        u,
        authProvider: 'password',
      );
      // Initialize Firestore for user
      await sl<FirestoreSetupService>().initializeUserData(
        uid: uid,
        email: e,
        displayName: name,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      sl<AppLogger>().w('signInWithEmailPassword', e);
      return firebaseAuthCodeToMessage(e.code, l10n);
    } catch (e, st) {
      sl<AppLogger>().e('signInWithEmailPassword', e, st);
      return l10n.errorGeneric;
    }
  }

  /// E-posta/şifre kaydı. Başarıda `null`, aksi halde gösterilecek mesaj.
  Future<String?> registerWithEmailPassword({
    required String name,
    required String email,
    required String password,
    required AppLocalizations l10n,
  }) async {
    try {
      final UserCredential cred =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? u0 = cred.user;
      if (u0 == null) {
        return l10n.errorAuth;
      }
      await u0.updateDisplayName(name);
      await u0.reload();
      final User? u = FirebaseAuth.instance.currentUser;
      if (u == null) {
        return l10n.errorAuth;
      }
      final String uid = u.uid;
      final String e = u.email ?? email;
      await saveSession(uid: uid, email: e, name: name);
      await sl<UserProfileFirestoreService>().upsertFromFirebaseUser(
        u,
        authProvider: 'password',
      );
      // Yeni kayıt olan kullanıcı için veritabanını hazırla (Örnek bitkiler vb.)
      await sl<FirestoreSetupService>().initializeUserData(
        uid: uid,
        email: e,
        displayName: name,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      sl<AppLogger>().w('registerWithEmailPassword', e);
      return firebaseAuthCodeToMessage(e.code, l10n);
    } catch (e, st) {
      sl<AppLogger>().e('registerWithEmailPassword', e, st);
      return l10n.errorGeneric;
    }
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
      final String uid = u.uid;
      final String email = u.email ?? '';
      final String name =
          u.displayName ?? (email.contains('@') ? email.split('@').first : email);
      await saveSession(uid: uid, email: email, name: name);
      await sl<UserProfileFirestoreService>().upsertFromFirebaseUser(
        u,
        authProvider: 'google.com',
      );
      // Google ile ilk kez giren kullanıcı için veritabanını hazırla
      await sl<FirestoreSetupService>().initializeUserData(
        uid: uid,
        email: email,
        displayName: name,
      );
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
