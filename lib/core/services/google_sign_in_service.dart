import 'package:bitirme_mobile/core/env/env.dart';
import 'package:bitirme_mobile/core/enums/error_strings_enum.dart';
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
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );
      if (auth.idToken == null || auth.idToken!.isEmpty) {
        _logger.w('Google idToken boş — .env içinde GOOGLE_WEB_CLIENT_ID (Web client) gerekli olabilir.');
      }
      return FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e, st) {
      _logger.e(ErrorStringsEnum.googleSignIn.value, e, st);
      rethrow;
    }
  }

  Future<void> signOutGoogle() async {
    try {
      await _client().signOut();
    } catch (e, st) {
      _logger.e(ErrorStringsEnum.googleSignIn.value, e, st);
    }
  }
}
