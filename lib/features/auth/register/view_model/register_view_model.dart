import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:bitirme_mobile/features/auth/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Kayıt ekranı iş kuralları.
class RegisterViewModel {
  RegisterViewModel({required this.ref});

  final WidgetRef ref;

  Future<void> submit({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    final String trimmedName = name.trim();
    final String trimmedEmail = email.trim();
    if (trimmedName.isEmpty || trimmedEmail.isEmpty || password.isEmpty) {
      return;
    }
    await ref.read(authProvider.notifier).saveSession(email: trimmedEmail, name: trimmedName);
    if (context.mounted) {
      context.go(AppPaths.home);
    }
  }
}
