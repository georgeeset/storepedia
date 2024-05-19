import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:storepedia/model/user_model.dart';
import 'package:storepedia/repository/fellow_users_repository.dart';
import 'package:storepedia/constants/number_constants.dart' as number_constants;

part 'fellow_users_state.dart';

class FellowUsersCubit extends Cubit<FellowUsersState> {
  FellowUsersCubit() : super(const FellowUsersState());

  final FellowUsersRepository fellowUsersRepository = FellowUsersRepository();

  void getFellowUsers(UserModel userModel) async {
    emit(state.copyWith(queryStatus: QueryStatus.loading));
    if (userModel.company == null || userModel.company == '') {
      emit(state.copyWith(
        queryStatus: QueryStatus.error,
        errorMessage: "Your Profile doesn't have a company.",
      ));
      return;
    }

    await fellowUsersRepository.getFellowUsers(userModel).then((value) {
      if (value.isEmpty) {
        emit(state.copyWith(queryStatus: QueryStatus.noResult));
      } else {
        if (value.length < number_constants.maximumSearchResult) {
          emit(state.copyWith(
            queryStatus: QueryStatus.loaded,
            paginationLoading: false,
            hasReachedMax: true,
            response: value,
          ));
        }
      }
    });
  }

  @override
  void onChange(Change<FellowUsersState> change) {
    // TODO: implement onChange
    print(change.currentState);
    print("new state");
    print(change.nextState);

    super.onChange(change);
  }
}
