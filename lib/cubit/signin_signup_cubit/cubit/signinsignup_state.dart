part of 'signinsignup_cubit.dart';

abstract class SigninsignupState extends Equatable {
  const SigninsignupState();

  @override
  List<Object> get props => [];
}

class SigninState extends SigninsignupState {
  @override
  String toString() {
    return 'SigninState';
  }
}

class SignupState extends SigninsignupState{
  
  @override
  String toString() {
    return 'SitnupState';
  }
}
