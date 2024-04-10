import 'package:storepedia/model/user_model.dart';
import 'package:storepedia/repository/firestore_operaions.dart';
import 'package:storepedia/constants/string_constants.dart' as StringConstants;

class UserRepository extends FirestoreOperations {
  //operations to get and edit user information
  Future<UserModel> getUser(String userId) async {
    return await readDocument(StringConstants.userCollection, userId)
        .then((snapshot) => snapshot.exists
            ? UserModel.fromMap(snapshot: snapshot)
            : UserModel())
        .onError(
            (error, stackTrace) => Future.error(error.toString(), stackTrace));
  }

  Future<void> addUserProfile(String userId, UserModel userData) async {
    return await editDocument(
            StringConstants.userCollection, userId, userData.toMap)
        .onError(
            (error, stackTrace) => Future.error(error.toString(), stackTrace));
  }
}
