part of 'exhausteditemsmanager_cubit.dart';

enum QueryStatus { initial, loading, loaded, noResult, error }

class ExhausteditemsmanagerState extends Equatable {
  const ExhausteditemsmanagerState({
    this.response = const <Part>[],
    this.searchString = '',
    this.hasReachedMax = false,
    this.paginationLoading = false,
    this.queryStatus = QueryStatus.initial,
    this.errorMessage = '',
  });

  final List<Part> response;
  final String searchString;
  final bool hasReachedMax;
  final bool paginationLoading;
  final QueryStatus queryStatus;
  final String errorMessage;

  ExhausteditemsmanagerState copyWith({
    List<Part>? response,
    bool? hasReachedMax,
    bool? paginationLoading,
    String? searchString,
    QueryStatus? queryStatus,
    String? errorMessage,
  }) {
    return ExhausteditemsmanagerState(
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
