import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storepedia/model/user_model.dart';
import 'package:storepedia/repository/user_repository.dart';

part 'usermanager_state.dart';

class UserManagerCubit extends Cubit<UserManagerState> {
  UserManagerCubit() : super(UserManagerInitial());

  final UserRepository userRepository = UserRepository();
  late User user;

  getUser(User user) async {
    this.user = user;
    // call user managerRepository and ask for user with the information gotten from Auth
    emit(UserLoadingState());
    userRepository.getUser(user.uid).then((value) {
      // print(value.hasName());
      emit(UserLoadedState(userData: value));
    }).catchError(
      ((error, stackTrace) {
        // print('error observed from getUser... $error');
        emit(UserLoadingErrorState(error: error));
      }),
    );
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
            UserLoadedState(userData: nameAdded),
          ),
        )
        .onError(
          (error, stackTrace) => emit(
            UserLoadingErrorState(
                error: error.toString(), stackTrace: stackTrace),
          ),
        );
  }

  updateCompanyName({
    required UserModel userData,
    required String companyName,
  }) async {
    emit(UserLoadingState());
    UserModel companyAdded = userData.copyWith(company: companyName);

    await userRepository
        .addUserProfile(user.uid, companyAdded)
        .then(
          (value) => emit(
            UserLoadedState(userData: companyAdded),
          ),
        )
        .onError(
          (error, stackTrace) => emit(
            UserLoadingErrorState(
                error: error.toString(), stackTrace: stackTrace),
          ),
        );
  }

  updateCompanyBranch({
    required UserModel userData,
    required String companyBranch,
  }) async {
    emit(UserLoadingState());
    UserModel companyBranched = userData.copyWith(branch: companyBranch);

    await userRepository
        .addUserProfile(user.uid, companyBranched)
        .then(
          (value) => emit(
            UserLoadedState(userData: companyBranched),
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
