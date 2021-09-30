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

class UserLoadingState extends UserManagerState{
  @override
  String toString() {
    return 'UserLoadingState';
  }
  @override
  List<Object> get props => super.props;
}

class UserLoadingErrorState extends UserManagerState{
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
class UserLoadedState extends UserManagerState{
  final UserModel userData;
  final String actualDeviceInfo;
   UserLoadedState( {required this.userData, required this.actualDeviceInfo,});

   @override
  String toString() {
    return 'UserLoadedState';
  }

  @override
  List<Object> get props => [userData,actualDeviceInfo];
}

class EmailVerificationSentState extends UserManagerState{
  final String email;
  EmailVerificationSentState(this.email);
  @override
  String toString() {
    return 'EmailVerificationSentState';
  }

  @override
  List<Object> get props => [email];
}
