import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storepedia/model/user_model.dart';
import 'package:storepedia/repository/fellow_users_repository.dart';
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
    }).catchError(((error, stackTrace) {
      // print('error observed from getUser... $error');
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

    if (userData.company != null) {
      //user already have a company name
      // perform demotion of user to level 1 if
      // user is not the only one in the company name
      // perform demotion of user to level 5 if the user is
      // among first 3 users in the company

      FellowUsersRepository fellowUsersRepository = FellowUsersRepository();
      var fellowUsers = await fellowUsersRepository.getFellowUsers(userData);

      if (fellowUsers.length > 3) {
        // demote to level 1
        userData.copyWith(accessLevel: 1);
      } else {
        // promote to level 5
        userData.copyWith(accessLevel: 5);
      }
    }

    if (userData.company == companyName) {
      emit(UserLoadedState(userData: userData));
    }

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

  upgradeCoWorker(
      {required UserModel myAccount, required UserModel coWorker}) async {
    ///Increment a co-worker's Access Level
    ///myAccount is the account owner.
    ///coWorker is the user's data who's level is to be upgraded

    if (myAccount.accessLevel <= coWorker.accessLevel) return;

    emit(UserLoadingState());

    UserModel promotedUser =
        coWorker.copyWith(accessLevel: coWorker.accessLevel += 1);

    await userRepository
        .addUserProfile(promotedUser.userId!, promotedUser)
        .then(
          (value) => emit(
            UserLoadedState(userData: myAccount),
          ),
        )
        .onError(
          (error, stackTrace) => emit(
            UserLoadingErrorState(
                error: error.toString(), stackTrace: stackTrace),
          ),
        );
  }

  @override
  void onChange(Change<UserManagerState> change) {
    print(change.nextState);
    super.onChange(change);
  }
}
