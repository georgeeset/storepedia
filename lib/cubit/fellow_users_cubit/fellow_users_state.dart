part of 'fellow_users_cubit.dart';

enum QueryStatus { initial, loading, loaded, noResult, error }

class FellowUsersState extends Equatable {
  const FellowUsersState({
    this.response = const <UserModel>[],
    this.searchString = '',
    this.hasReachedMax = false,
    this.paginationLoading = false,
    this.queryStatus = QueryStatus.initial,
    this.errorMessage = '',
  });

  // List of UserModel objects returned from the API response
  final List<UserModel> response;

  // Search string used for filtering users
  final String searchString;

  // Flag indicating if the maximum number of users has been fetched
  final bool hasReachedMax;

  // Flag indicating if pagination is currently loading
  final bool paginationLoading;

  // Status of the API query (e.g., loading, success, error)
  final QueryStatus queryStatus;

  // Error message in case of an API error
  final String errorMessage;

  FellowUsersState copyWith({
    List<UserModel>? response,
    bool? hasReachedMax,
    bool? paginationLoading,
    String? searchString,
    QueryStatus? queryStatus,
    String? errorMessage,
  }) {
    return FellowUsersState(
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
