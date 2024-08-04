part of 'partquerymanager_cubit.dart';

enum QueryStatus { initial, loading, loaded, noResult, error }

class PartqueryManagerState extends Equatable {
  final List<Part> response;
  final String searchString;
  final bool hasReachedMax;
  final bool paginationLoading;
  final QueryStatus queryStatus;
  final String errorMessage;
  final bool locationFilter;
  const PartqueryManagerState({
    this.response = const <Part>[],
    this.searchString = '',
    this.hasReachedMax = false,
    this.paginationLoading = false,
    this.queryStatus = QueryStatus.initial,
    this.errorMessage = '',
    this.locationFilter = true,
  });

  PartqueryManagerState copyWith(
      {List<Part>? response,
      bool? hasReachedMax,
      bool? paginationLoading,
      String? searchString,
      QueryStatus? queryStatus,
      String? errorMessage,
      bool? locationFilter}) {
    return PartqueryManagerState(
      searchString: searchString ?? this.searchString,
      response: response ?? this.response,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      paginationLoading: paginationLoading ?? this.paginationLoading,
      queryStatus: queryStatus ?? this.queryStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      locationFilter: locationFilter ?? this.locationFilter,
    );
  }

  @override
  String toString() {
    return 'queryStatus: $queryStatus,\nhasReachedMax $hasReachedMax,\nresponse: ${response.toString()},\npaginationLoading: $paginationLoading,\nerrorMessage: $errorMessage,\nlocationFilter:$locationFilter';
  }

  @override
  List<Object> get props => [
        response,
        searchString,
        errorMessage,
        queryStatus,
        paginationLoading,
        hasReachedMax,
        locationFilter,
      ];
}

// class NopartfoundState extends PartquerymanagerState {
//   @override
//   String toString() {
//     return 'NopartfoundState';
//   }
// }

// class PartqueryerrorState extends PartquerymanagerState {
//   const PartqueryerrorState({required this.message, this.stackTrace});
//   final String message;
//   final StackTrace? stackTrace;

//   @override
//   String toString() {
//     return 'PartqueryerrorState';
//   }
// }
