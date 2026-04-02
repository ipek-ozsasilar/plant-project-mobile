import 'package:bitirme_mobile/core/services/auth_storage_service.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Oturum durumu.
class AuthState {
  const AuthState({this.email, this.displayName});

  final String? email;
  final String? displayName;

  bool get isAuthenticated => email != null && email!.isNotEmpty;
}

/// Oturum ve yerel kullanıcı bilgisi.
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  Future<void> hydrate() async {
    final AuthStorageService svc = sl<AuthStorageService>();
    final String? email = await svc.getEmail();
    final String? name = await svc.getName();
    state = AuthState(email: email, displayName: name);
  }

  Future<void> saveSession({required String email, required String name}) async {
    final AuthStorageService svc = sl<AuthStorageService>();
    await svc.saveUser(email: email, name: name);
    state = AuthState(email: email, displayName: name);
  }

  Future<void> logout() async {
    final AuthStorageService svc = sl<AuthStorageService>();
    await svc.clearUser();
    state = const AuthState();
  }
}

final NotifierProvider<AuthNotifier, AuthState> authProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
