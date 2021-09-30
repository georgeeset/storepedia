import 'package:store_pedia/model/user_model.dart';
import 'package:store_pedia/repository/firestore_operaions.dart';
import 'package:store_pedia/constants/firebase_constants.dart' as DBConstants;

class UserRepository extends FirestoreOperations {
  //operations to get and edit user information
  Future<UserModel> getUser(String userId) async {
    return await readDocument(DBConstants.users, userId)
        .then((snapshot) =>
            snapshot.exists ? UserModel.fromMap(snapshot: snapshot) : UserModel())
        .onError((error, stackTrace) => Future.error(error.toString(),stackTrace));
  }

  Future<void> addUserProfile(String userId, UserModel userData) async {
    return await editDocument(DBConstants.users,userId, userData.toMap)
        .onError((error, stackTrace) => Future.error (error.toString(),stackTrace));
  }
}
