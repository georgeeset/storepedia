import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:store_pedia/model/user_model.dart';
import 'package:store_pedia/repository/device_info.dart';
import 'package:store_pedia/repository/user_repository.dart';

part 'usermanager_state.dart';

class UserManagerCubit extends Cubit<UserManagerState> {
  UserManagerCubit() : super(UserManagerInitial());

  final UserRepository userRepository = UserRepository();
  late User user;

  DeveiceInfo deviceInfo = DeveiceInfo();
  late String deviceValue;

  getUser(User user) async {
    this.user = user;
    await deviceInfo.androidDeviceInfo().then((value) => deviceValue = value);
    // call user managerRepository and ask for user with the information gotten from Auth
    emit(UserLoadingState());
    userRepository.getUser(user.uid).then((value) {
      print(value.hasName());
      emit(UserLoadedState(userData: value, actualDeviceInfo: deviceValue));
    }).catchError(((error, stackTrace) {
      print('error observed from getUser... $error');
      emit(UserLoadingErrorState(error: error));
    }));
    // emit user loading

    // emit user loaded when done
  }

  retryLoading() {
    getUser(user);
  }

  updateUserName({
    required UserModel userData,
    required String fullName,
  }) async {
    //update The rest
    UserModel nameAdded = userData.copyWith(
      userName: fullName,
      userId: user.uid,
      email: user.email,
    );

    //upload the document
    emit(UserLoadingState());
    await userRepository
        .addUserProfile(user.uid, nameAdded)
        .then(
          (value) => emit(
            UserLoadedState(userData: nameAdded, actualDeviceInfo: deviceValue),
          ),
        )
        .onError(
          (error, stackTrace) => emit(
            UserLoadingErrorState(
                error: error.toString(), stackTrace: stackTrace),
          ),
        );
  }

  verifyEmail() async {
    emit(UserLoadingState());
    await user
        .sendEmailVerification()
        .then((value) => emit(EmailVerificationSentState(user.email!)));
  }

  @override
  void onChange(Change<UserManagerState> change) {
    print(change.nextState);
    super.onChange(change);
  }
}
