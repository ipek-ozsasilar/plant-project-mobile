import 'package:bitirme_mobile/core/env/env.dart';
import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Google hesabı ile Firebase kimlik doğrulama.
class GoogleSignInService {
  GoogleSignInService({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;
  GoogleSignIn? _googleSignIn;

  GoogleSignIn _client() {
    if (_googleSignIn != null) return _googleSignIn!;

    final String webId = Env.googleWebClientId.trim();
    if (webId.isEmpty) {
      _logger.w('Env.googleWebClientId is empty. This will cause null idToken on Android.');
    }
    
    _googleSignIn = GoogleSignIn(
      scopes: <String>['email', 'profile'],
      serverClientId: webId.isEmpty ? null : webId,
    );
    return _googleSignIn!;
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
        final String errorMsg = 
            'Google idToken alınamadı! Olası nedenler:\n'
            '1- Firebase Console\'da SHA-1 parmak izi ekli değil.\n'
            '2- Google Cloud Console\'daki Web Client ID, Env.googleWebClientId ile eşleşmiyor.\n'
            '3- Google Sign-In, Firebase Auth panelinde etkinleştirilmemiş.';
        _logger.e(errorMsg);
        throw FirebaseAuthException(
          code: 'invalid-credential',
          message: errorMsg,
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
