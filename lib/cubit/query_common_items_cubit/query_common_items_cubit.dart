import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:store_pedia/model/part.dart';
import 'package:store_pedia/repository/commonly_used_items_repository.dart';
import 'package:store_pedia/constants/number_constants.dart' as NumberConstants;

part 'query_common_items_state.dart';

class QueryCommonItemsCubit extends Cubit<QueryCommonItemsState> {
  QueryCommonItemsCubit() : super(QueryCommonItemsState());
  final CommonitemRepository commonitemRepository = CommonitemRepository();

  void getCommonItems(String department) async {
    emit(state.copyWith(queryStatus: QueryStatus.loading));
    await commonitemRepository.search(department).then((value) {
      if (value == null) {
        emit(state.copyWith(queryStatus: QueryStatus.noResult));
      } else {
        if (value.length < NumberConstants.maximumSearchResult) {
          emit(state.copyWith(
            queryStatus: QueryStatus.loaded,
            paginationLoading: false,
            hasReachedMax: true,
            response: value,
          ));
          commonitemRepository.clearLastDoc();
        } else {
          emit(state.copyWith(
            queryStatus: QueryStatus.loaded,
            hasReachedMax: false,
            response: value,
          ));
        }
      }
    }).onError((error, stackTrace) {
      emit(state.copyWith(
          queryStatus: QueryStatus.error, errorMessage: error.toString()));
    });
  }

  Future<void> moreCommonItems(department) async {
    if (state.queryStatus != QueryStatus.loaded ||
        state.hasReachedMax ||
        state.paginationLoading) {
      return;
    }

    state.copyWith(queryStatus: QueryStatus.loading);
    print('requresting more');
    await commonitemRepository.search(department).then((value) {
      print('${value?.length}');
      if (value == null) {
        emit(state.copyWith(hasReachedMax: true, paginationLoading: false));
      } else {
        if (value.length < NumberConstants.maximumSearchResult) {
          emit(state.copyWith(
            paginationLoading: false,
            hasReachedMax: true,
            response: List.of(state.response)..addAll(value),
          ));
        } else {
          emit(state.copyWith(
            paginationLoading: false,
            hasReachedMax: false,
            response: List.of(state.response)..addAll(value),
          ));
        }
      }
    });
    // state.copyWith(paginationLoading: false);
  }
}
