import 'package:store_pedia/model/part.dart';
import 'package:store_pedia/repository/firestore_operaions.dart';
import 'package:store_pedia/constants/firebase_constants.dart' as DBConstants;

class PartOperationsRepository extends FirestoreOperations {
  PartOperationsRepository();

  Future<void> storePart(Part part) async {
    return addDocument(DBConstants.parts, part.toMap());
  }

  Future<void> editPart(Part part) async {
    return editDocument(DBConstants.parts, part.partUid!, part.toMap()).onError(
      (error, stackTrace) => Future.error(error.toString(), stackTrace),
    );
  }

  Future<void> addPart(Part part) async {
    return addDocument(DBConstants.parts, part.toMap()).onError(
      (error, stackTrace) => Future.error(error.toString(), stackTrace),
    );
  }
}
