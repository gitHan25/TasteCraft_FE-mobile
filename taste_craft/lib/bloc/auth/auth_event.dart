import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? profileImageBase64;

  const AuthRegisterRequested({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.profileImageBase64,
  });

  @override
  List<Object> get props => [firstName, lastName, email, password];
}

class AuthLogoutRequested extends AuthEvent {
  final String token;

  const AuthLogoutRequested({
    required this.token,
  });

  @override
  List<Object> get props => [token];
  
}

class AuthCheckStatus extends AuthEvent {}

class AuthGetUserProfile extends AuthEvent {}
