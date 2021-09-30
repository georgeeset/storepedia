part of 'signinoption_bloc.dart';

abstract class SigninoptionState extends Equatable {
  const SigninoptionState();
  
  @override
  List<Object> get props => [];
}

class SigninState extends SigninoptionState {
  @override
  String toString() {
    return 'SigninState';
  }
  @override
  List<Object> get props => super.props;
}

class RegisterState extends SigninoptionState{
  @override
  String toString() {
    return 'RegisterState';
  }
  @override
  List<Object> get props => super.props;
}

class ForgotPasswordState extends SigninoptionState{
  @override
  String toString() {
    return 'ForgotPasswordState';
  }
  @override
  List<Object> get props => super.props;
}
