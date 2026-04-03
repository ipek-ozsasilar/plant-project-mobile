import 'package:bitirme_mobile/features/auth/provider/auth_provider.dart';
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
        );
  }
}
