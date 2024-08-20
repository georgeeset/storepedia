import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storepedia/model/part.dart';
import 'package:storepedia/repository/exhausted_items_repository.dart';
import 'package:storepedia/constants/number_constants.dart' as number_constants;

part 'exhausteditemsmanager_state.dart';

class ExhausteditemsmanagerCubit extends Cubit<ExhausteditemsmanagerState> {
  ExhausteditemsmanagerCubit() : super(const ExhausteditemsmanagerState());
  final ExhaustedItemsRepository partQueryRepository =
      ExhaustedItemsRepository();
  late String company;
  late String branch;

  void getExhaustedItems({
    required String companyName,
    required String branch,
  }) async {
    company = companyName;
    this.branch = branch;
    emit(state.copyWith(queryStatus: QueryStatus.loading));
    await partQueryRepository.search(company: company).then((value) {
      print('${value?.length}');

      if (value == null) {
        emit(state.copyWith(queryStatus: QueryStatus.noResult));
      } else {
        // marked parts for delete are removed here if user level is Not admin
        // value.removeWhere((element) => element.markedBadByUid!=null);

        if (state.locationFilter && companyName != 'parts') {
          value.removeWhere((element) => element.branch != branch);
        }

        emit(state.copyWith(
          queryStatus: QueryStatus.loaded,
          paginationLoading: false,
          hasReachedMax: value.length < number_constants.maximumSearchResult
              ? true
              : false,
          response: value,
        ));
      }
    }).onError((error, stackTrace) {
      emit(state.copyWith(
          queryStatus: QueryStatus.error, errorMessage: error.toString()));
    });
  }

  Future<void> moreExhaustedItems() async {
    if (state.queryStatus != QueryStatus.loaded ||
        state.hasReachedMax ||
        state.paginationLoading) {
      return;
    }

    state.copyWith(paginationLoading: true);

    print('requresting more');
    await partQueryRepository.search(company: company).then((value) {
      print('${value?.length}');
      if (value == null) {
        emit(state.copyWith(hasReachedMax: true, paginationLoading: false));
      } else {
        if (state.locationFilter) {
          value.removeWhere((element) => element.branch != branch);
        }

        emit(state.copyWith(
          paginationLoading: false,
          hasReachedMax: value.length < number_constants.maximumSearchResult
              ? true
              : false,
          response: List.of(state.response)..addAll(value),
        ));
      }
    });
    // state.copyWith(paginationLoading: false);
  }
}
