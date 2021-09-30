part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class EmailPasswordSigninEvent extends AuthenticationEvent{
  final String email;
  final String password;
  EmailPasswordSigninEvent({required this.email, required this.password});
  @override
  String toString() {
    return 'SigninEvent';
  }
}

class SignOutEvent extends AuthenticationEvent{

  @override
  String toString() {
    return 'SignoutEvent';
  }
}

class RegisterEvent extends AuthenticationEvent{

  final String email;
  final String password1;
  final String password2;
  const RegisterEvent({required this.email, required this.password1, required this.password2});

  @override
  String toString() {
    return 'RegisterEvent';
  }
}