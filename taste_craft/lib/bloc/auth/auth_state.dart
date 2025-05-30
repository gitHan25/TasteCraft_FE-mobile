import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final Map<String, dynamic> userData;

  const AuthAuthenticated({required this.userData});

  @override
  List<Object?> get props => [userData];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthSuccess extends AuthState {
  final String message;
  final Map<String, dynamic>? data;

  const AuthSuccess({
    required this.message,
    this.data,
  });

  @override
  List<Object?> get props => [message, data];
}

class AuthFailed extends AuthState {
  final String e;
  const AuthFailed({required this.e});
  @override
  List<Object?> get props => [e];
}

extension AuthStateX on AuthState {
  String? get firstName => this is AuthAuthenticated
      ? (this as AuthAuthenticated).userData['first_name']
      : null;

  String? get lastName => this is AuthAuthenticated
      ? (this as AuthAuthenticated).userData['last_name']
      : null;

  String? get email => this is AuthAuthenticated
      ? (this as AuthAuthenticated).userData['email']
      : null;
}
