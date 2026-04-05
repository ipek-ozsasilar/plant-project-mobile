import 'package:bitirme_mobile/features/auth/provider/auth_provider.dart';
import 'package:bitirme_mobile/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Giriş ekranı iş kuralları.
class LoginViewModel {
  LoginViewModel({required this.ref});

  final WidgetRef ref;

  /// Başarıda `null`, hata mesajı string olarak döner.
  Future<String?> submit({
    required String email,
    required String password,
    required AppLocalizations l10n,
  }) async {
    final String trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty || password.isEmpty) {
      return null;
    }
    return ref.read(authProvider.notifier).signInWithEmailPassword(trimmedEmail, password, l10n);
  }
}
