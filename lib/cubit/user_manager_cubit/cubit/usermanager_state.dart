part of 'usermanager_cubit.dart';

abstract class UserManagerState extends Equatable {
  const UserManagerState();

  @override
  List<Object> get props => [];
}

class UserManagerInitial extends UserManagerState {
  @override
  String toString() {
    return 'UserManagerInitial';
  }
}

class UserLoadingState extends UserManagerState {
  @override
  String toString() {
    return 'UserLoadingState';
  }
}

class UserLoadingErrorState extends UserManagerState {
  final String error;
  final Object? stackTrace;
  const UserLoadingErrorState({required this.error, this.stackTrace});

  @override
  String toString() {
    return 'UserLoadingErrorState';
  }

  @override
  List<Object> get props => [error];
}

/// if the loaded widget has data, the
class UserLoadedState extends UserManagerState {
  final UserModel userData;
  const UserLoadedState({required this.userData});

  @override
  String toString() {
    return 'UserLoadedState';
  }

  @override
  List<Object> get props => [userData];
}

class EmailVerificationSentState extends UserManagerState {
  final String email;
  const EmailVerificationSentState(this.email);
  @override
  String toString() {
    return 'EmailVerificationSentState';
  }

  @override
  List<Object> get props => [email];
}
