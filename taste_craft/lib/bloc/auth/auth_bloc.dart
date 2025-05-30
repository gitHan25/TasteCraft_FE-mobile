import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taste_craft/bloc/auth/auth_event.dart';
import 'package:taste_craft/bloc/auth/auth_state.dart';
import 'package:taste_craft/service/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckStatus>(_onCheckStatus);
    on<AuthGetUserProfile>(_onGetUserProfile);
    on<UpdateUserInfo>(_onUpdateUserInfo);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final result = await AuthService.login(
        email: event.email,
        password: event.password,
      );

      if (result['success']) {
        final userProfile = await AuthService.getUserProfile();

        emit(AuthAuthenticated(
          userData: userProfile ?? result['data'] ?? {},
        ));
      } else {
        emit(AuthError(message: result['message'] ?? 'Login failed'));
      }
    } catch (e) {
      emit(AuthError(message: 'An error occurred: $e'));
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final result = await AuthService.register(
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        password: event.password,
        profileImageBase64: event.profileImageBase64,
      );

      if (result['success']) {
        emit(AuthSuccess(
          message: result['message'] ?? 'Registration successful',
          data: result['data'],
        ));
      } else {
        emit(AuthError(message: result['message'] ?? 'Registration failed'));
      }
    } catch (e) {
      emit(AuthError(message: 'An error occurred: $e'));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await AuthService.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: 'Logout failed: $e'));
    }
  }

  Future<void> _onCheckStatus(
    AuthCheckStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      bool isLoggedIn;
      try {
        // Try the full authentication check with network validation
        isLoggedIn = await AuthService.isLoggedIn();
      } catch (e) {
        // Fallback to offline token check
        isLoggedIn = await AuthService.isLoggedInOffline();
      }

      if (isLoggedIn) {
        try {
          final userProfile = await AuthService.getUserProfile();
          emit(AuthAuthenticated(userData: userProfile ?? {}));
        } catch (e) {
          // Even if profile fetch fails, emit authenticated state
          emit(AuthAuthenticated(userData: {}));
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onGetUserProfile(
    AuthGetUserProfile event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final userProfile = await AuthService.getUserProfile();

      if (userProfile != null) {
        emit(AuthAuthenticated(userData: userProfile));
      } else {
        emit(const AuthError(message: 'Failed to get user profile'));
      }
    } catch (e) {
      emit(AuthError(message: 'Error getting user profile: $e'));
    }
  }

  Future<void> _onUpdateUserInfo(
    UpdateUserInfo event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthAuthenticated) {
      final currentState = state as AuthAuthenticated;
      final updatedUserData = Map<String, dynamic>.from(currentState.userData);

      if (event.firstName != null) {
        updatedUserData['first_name'] = event.firstName;
      }
      if (event.lastName != null) {
        updatedUserData['last_name'] = event.lastName;
      }
      if (event.email != null) {
        updatedUserData['email'] = event.email;
      }

      emit(AuthAuthenticated(userData: updatedUserData));
    }
  }
}
