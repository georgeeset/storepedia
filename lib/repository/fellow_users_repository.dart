import 'package:storepedia/model/user_model.dart';
import 'package:storepedia/repository/firestore_operaions.dart';
import 'package:storepedia/constants/string_constants.dart' as string_constants;

class FellowUsersRepository extends FirestoreOperations {
  Future<List<UserModel>> getFellowUsers(UserModel userModel) {
    return queryWithStringValue(
      collection: string_constants.userCollection,
      field: string_constants.company,
      fieldValue: userModel.company ?? '',
      orderBy: string_constants.accessLevel,
    ).then(
        (value) => value.map((e) => UserModel.fromMap(snapshot: e)).toList());
  }
}
