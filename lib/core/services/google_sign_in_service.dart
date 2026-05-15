import 'package:bitirme_mobile/core/env/env.dart';
import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Google hesabı ile Firebase kimlik doğrulama.
class GoogleSignInService {
  GoogleSignInService({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;

  GoogleSignIn _client() {
    final String webId = Env.googleWebClientId.trim();
    return GoogleSignIn(
      scopes: <String>['email', 'profile'],
      serverClientId: webId.isEmpty ? null : webId,
    );
  }

  /// Kullanıcı iptal ederse `null` döner.
  Future<UserCredential?> signInWithFirebase() async {
    try {
      final GoogleSignIn googleSignIn = _client();
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account == null) {
        return null;
      }
      final GoogleSignInAuthentication auth = await account.authentication;
      if (auth.idToken == null || auth.idToken!.isEmpty) {
        _logger.e(
          'Google idToken boş — Android için Firebase projesinde SHA-1 ve Google Sign-In yapılandırmasını kontrol edin.',
        );
        throw FirebaseAuthException(
          code: 'invalid-credential',
          message: 'Google kimlik doğrulama tokenı alınamadı.',
        );
      }
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );
      return FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e, st) {
      _logger.e('google_sign_in', e, st);
      rethrow;
    }
  }

  Future<void> signOutGoogle() async {
    try {
      await _client().signOut();
    } catch (e, st) {
      _logger.e('google_sign_in', e, st);
    }
  }
}
