import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storepedia/model/part.dart';
import 'package:storepedia/repository/part_query.dart';

import 'package:storepedia/constants/number_constants.dart' as number_constants;

part 'partquerymanager_state.dart';

class PartqueryManagerCubit extends Cubit<PartqueryManagerState> {
  PartqueryManagerCubit() : super(const PartqueryManagerState());
  final PartQuery partQueryRepository = PartQuery();
  late String companyName; // fill in data later
  late String location;
  late String lastQuery;

  void attemptQuery(String query, String companyName, String location) {
    this.location = location;
    this.companyName = companyName; // make available for other functions
    lastQuery = query;
    print(query);
    if (query.length > 2) {
      emit(state.copyWith(queryStatus: QueryStatus.loading));
      partQueryRepository
          .searchPart(searchString: query, company: companyName)
          .then((value) {
        print('${value?.length}');

        if (value == null) {
          emit(state.copyWith(queryStatus: QueryStatus.noResult));
        } else {
          // marked parts for delete are removed here if user level is Not admin
          // value.removeWhere((element) => element.markedBadByUid!=null);

          if (state.locationFilter) {
            value.removeWhere((element) => element.branch != location);
          }

          if (value.length < number_constants.maximumSearchResult) {
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
        .searchPart(
            searchString: state.searchString,
            company: companyName,
            newSearch: false)
        .then((value) {
      print('${value?.length}');
      if (value == null) {
        emit(state.copyWith(hasReachedMax: true, paginationLoading: false));
      } else {
        if (state.locationFilter) {
          value.removeWhere((element) => element.branch != location);
        }

        if (value.length < number_constants.maximumSearchResult) {
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

  changeLocationFilter(value) {
    emit(state.copyWith(locationFilter: value));

    if (state.queryStatus == QueryStatus.loaded) {
      attemptQuery(lastQuery, companyName, location);
    }
  }

  @override
  void onChange(Change<PartqueryManagerState> change) {
    print(change.nextState.toString());
    super.onChange(change);
  }
}
