import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:news_app/constants/app_strings.dart';
import 'package:news_app/features/core/local/auth_local_storage.dart';

final authStorageProvider = Provider((ref) => AuthLocalStorage());

class AuthState {
  final bool loading;
  final String? error;

  const AuthState({this.loading = false, this.error});

  AuthState copyWith({
    bool? loading,
    String? error,
    bool clearError = false,
  }) =>
      AuthState(
        loading: loading ?? this.loading,
        error: clearError ? null : (error ?? this.error),
      );
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthLocalStorage storage;

  AuthNotifier(this.storage) : super(const AuthState());

  void clearError() {
    state = const AuthState();
  }

  Future<bool> register(String email, String pass) async {
    state = state.copyWith(loading: true, clearError: true);

    final success = await storage.register(email, pass);

    if (!success) {
      state = const AuthState(error: AppStrings.emailAlreadyExists);
      return false;
    }

    state = const AuthState();
    return true;
  }

  Future<bool> login(String email, String pass) async {
    state = state.copyWith(loading: true, clearError: true);

    final success = storage.login(email, pass);

    if (success) {
      await storage.saveSession(email);
      state = const AuthState();
      return true;
    } else {
      state = const AuthState(error: AppStrings.invalidCredentials);
      return false;
    }
  }

  Future<void> resetPassword(String email, String newPass) async {
    state = state.copyWith(loading: true, clearError: true);

    final success = await storage.updatePassword(email, newPass);

    if (!success) {
      state = const AuthState(error: AppStrings.emailNotFound);
      return;
    }

    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authStorageProvider));
});
