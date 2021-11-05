part of 'partquerymanager_cubit.dart';

enum QueryStatus { initial, loading, loaded, noResult, error }

// abstract class PartquerymanagerState extends Equatable {
//   const PartquerymanagerState();

//   @override
//   List<Object> get props => [];
// }

// class PartquerymanagerInitialState extends PartquerymanagerState {
//   @override
//   String toString() {
//     return 'PartquerymanagerInitialState';
//   }
// }

// class PartqueryloadingState extends PartquerymanagerState {
//   @override
//   String toString() {
//     return 'Partqueryloadingstate';
//   }
// }

class PartqueryManagerState extends Equatable {
  final List<Part> response;
  final String searchString;
  final bool hasReachedMax;
  final bool paginationLoading;
  final QueryStatus queryStatus;
  final String errorMessage;
  PartqueryManagerState({
    this.response = const <Part>[],
    this.searchString = '',
    this.hasReachedMax = false,
    this.paginationLoading = false,
    this.queryStatus = QueryStatus.initial,
    this.errorMessage = '',
  });

  PartqueryManagerState copyWith({
    List<Part>? response,
    bool? hasReachedMax,
    bool? paginationLoading,
    String? searchString,
    QueryStatus? queryStatus,
    String? errorMessage,
  }) {
    return PartqueryManagerState(
      searchString: searchString ?? this.searchString,
      response: response ?? this.response,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      paginationLoading: paginationLoading ?? this.paginationLoading,
      queryStatus: queryStatus ?? this.queryStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return 'queryStatus: $queryStatus,\nhasReachedMax $hasReachedMax,\nresponse: ${response.toString()},\npaginationLoading: $paginationLoading,\nerrorMessage:$errorMessage';
  }

  @override
  List<Object> get props => [
        response,
        searchString,
        errorMessage,
        queryStatus,
        paginationLoading,
        hasReachedMax,
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
