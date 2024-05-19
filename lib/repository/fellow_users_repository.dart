import 'package:storepedia/model/user_model.dart';
import 'package:storepedia/repository/firestore_operaions.dart';
import 'package:storepedia/constants/string_constants.dart' as string_constants;
import 'package:storepedia/constants/number_constants.dart' as number_constants;

class FellowUsersRepository extends FirestoreOperations {
  Future<List<UserModel>> getFellowUsers(UserModel userModel) {
    return paginateQueryWithStringValue(
      string_constants.userCollection,
      string_constants.company,
      userModel.company ?? '',
      string_constants.branch,
      userModel.branch ?? '',
      number_constants.maximumSearchResult,
      string_constants.email,
    ).then(
        (value) => value.map((e) => UserModel.fromMap(snapshot: e)).toList());
  }
}
