import 'package:bitirme_mobile/core/enums/error_strings_enum.dart';

/// [FirebaseAuthException.code] için kullanıcıya gösterilecek mesaj.
String firebaseAuthCodeToMessage(String code) {
  switch (code) {
    case 'email-already-in-use':
      return ErrorStringsEnum.authEmailInUse.value;
    case 'weak-password':
      return ErrorStringsEnum.authWeakPassword.value;
    case 'invalid-email':
      return ErrorStringsEnum.authInvalidEmail.value;
    case 'user-not-found':
      return ErrorStringsEnum.authUserNotFound.value;
    case 'wrong-password':
      return ErrorStringsEnum.authWrongPassword.value;
    case 'invalid-credential':
    case 'invalid-login-credentials':
      return ErrorStringsEnum.authInvalidCredential.value;
    case 'user-disabled':
      return ErrorStringsEnum.authUserDisabled.value;
    case 'too-many-requests':
      return ErrorStringsEnum.authTooManyRequests.value;
    case 'operation-not-allowed':
      return ErrorStringsEnum.authOperationNotAllowed.value;
    default:
      return ErrorStringsEnum.auth.value;
  }
}
