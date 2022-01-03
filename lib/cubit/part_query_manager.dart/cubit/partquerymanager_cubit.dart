import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:store_pedia/model/part.dart';
import 'package:store_pedia/repository/part_query.dart';

import 'package:store_pedia/constants/number_constants.dart' as NumberConstants;

part 'partquerymanager_state.dart';

class PartqueryManagerCubit extends Cubit<PartqueryManagerState> {
  PartqueryManagerCubit() : super(PartqueryManagerState());
  final PartQuery partQueryRepository = PartQuery();

  void attemptQuery(String query) {
    if (query.length > 3) {
      emit(state.copyWith(queryStatus: QueryStatus.loading));
      partQueryRepository.searchPart(searchString: query).then((value) {
        print('${value?.length}');

        if (value == null) {
          emit(state.copyWith(queryStatus: QueryStatus.noResult));
        } else {
          // marked parts for delete are removed here if user level is Not admin
          // value.removeWhere((element) => element.markedBadByUid!=null);

          if (value.length < NumberConstants.maximumSearchResult) {
            emit(state.copyWith(
              queryStatus: QueryStatus.loaded,
              paginationLoading: false,
              hasReachedMax: true,
              searchString: query,
              response: value,
            ));
          } else {
            emit(state.copyWith(
              queryStatus: QueryStatus.loaded,
              hasReachedMax: false,
              searchString: query,
              response: value,
            ));
          }
        }
      }).onError((error, stackTrace) {
        emit(state.copyWith(
            queryStatus: QueryStatus.error, errorMessage: error.toString()));
      });
    }
  }

  void moreResult() async {
    if (state.queryStatus != QueryStatus.loaded ||
        state.hasReachedMax ||
        state.paginationLoading) {
      return;
    }

    state.copyWith(paginationLoading: true);

    print('requresting more');
    await partQueryRepository
        .searchPart(searchString: state.searchString, newSearch: false)
        .then((value) {
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
  // @override
  // void onChange(Change<PartqueryManagerState> change) {
  //   print(change.nextState);
  //   super.onChange(change);
  // }
}
