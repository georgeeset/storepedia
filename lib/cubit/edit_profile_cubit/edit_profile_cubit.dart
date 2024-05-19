import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:storepedia/model/user_model.dart';

class EditProfileCubit extends HydratedCubit<UserModel> {
  late UserModel user;
  EditProfileCubit() : super(UserModel());

  editFullName(String fullName) {
    emit(state.copyWith(userName: fullName));
  }

  editCompanyName(String companyName) {
    emit(state.copyWith(company: companyName));
  }

  editBranch(String branch) {
    emit(state.copyWith(branch: branch));
  }

  @override
  UserModel? fromJson(Map<String, dynamic> json) {
    return UserModel.fromMap(userData: json);
  }

  @override
  Map<String, dynamic>? toJson(UserModel state) {
    return state.toMap;
  }
}
