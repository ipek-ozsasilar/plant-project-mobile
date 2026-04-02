import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:bitirme_mobile/features/auth/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Giriş ekranı iş kuralları.
class LoginViewModel {
  LoginViewModel({required this.ref});

  final WidgetRef ref;

  Future<void> submit({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    final String trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty || password.isEmpty) {
      return;
    }
    final String name = trimmedEmail.split('@').first;
    await ref.read(authProvider.notifier).saveSession(email: trimmedEmail, name: name);
    if (context.mounted) {
      context.go(AppPaths.home);
    }
  }
}
