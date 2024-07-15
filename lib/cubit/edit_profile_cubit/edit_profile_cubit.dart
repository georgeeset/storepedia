import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:storepedia/model/user_model.dart';

class EditProfileCubit extends Cubit<UserModel> {
  late UserModel user;
  EditProfileCubit() : super(UserModel());

  updateUser(UserModel user) {
    this.user = user;
    emit(user);
  }

  editFullName(String fullName) {
    emit(state.copyWith(userName: fullName));
  }

  editCompanyName(String companyName) {
    emit(state.copyWith(company: companyName));
  }

  editBranch(String branch) {
    emit(state.copyWith(branch: branch));
  }

  UserModel fromJson(Map<String, dynamic> json) {
    return UserModel.fromMap(userData: json);
  }

  Map<String, dynamic> toJson(UserModel state) {
    return state.toMap;
  }

  @override
  void onChange(Change<UserModel> change) {
    // TODO: implement onChange
    print("New Edit profile state: => ${change.nextState.userName}");
    super.onChange(change);
  }
}
