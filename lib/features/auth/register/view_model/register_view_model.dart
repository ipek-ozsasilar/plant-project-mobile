import 'package:bitirme_mobile/features/auth/provider/auth_provider.dart';
import 'package:bitirme_mobile/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Kayıt ekranı iş kuralları.
class RegisterViewModel {
  RegisterViewModel({required this.ref});

  final WidgetRef ref;

  /// Başarıda `null`, hata mesajı string olarak döner.
  Future<String?> submit({
    required String name,
    required String email,
    required String password,
    required AppLocalizations l10n,
  }) async {
    final String trimmedName = name.trim();
    final String trimmedEmail = email.trim();
    if (trimmedName.isEmpty || trimmedEmail.isEmpty || password.isEmpty) {
      return null;
    }
    return ref.read(authProvider.notifier).registerWithEmailPassword(
          name: trimmedName,
          email: trimmedEmail,
          password: password,
          l10n: l10n,
        );
  }
}
