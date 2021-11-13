import 'package:store_pedia/model/part.dart';
import 'package:store_pedia/repository/firestore_operaions.dart';
import 'package:store_pedia/constants/string_constants.dart' as StringConstants;

class PartOperationsRepository extends FirestoreOperations {
  PartOperationsRepository();

  Future<void> storePart(Part part) async {
    return addDocument(StringConstants.partsCollection, part.toMap());
  }

  Future<void> editPart(Part part) async {
    return editDocument(StringConstants.partsCollection, part.partUid!, part.toMap()).onError(
      (error, stackTrace) => Future.error(error.toString(), stackTrace),
    );
  }

  Future<void> addPart(Part part) async {
    return addDocument(StringConstants.partsCollection, part.toMap()).onError(
      (error, stackTrace) => Future.error(error.toString(), stackTrace),
    );
  }

  Future<void> deletePart({required partId}){
    return deleteDocumentLevel1(StringConstants.partsCollection, partId).onError((error, stackTrace) => Future.error(error.toString(),stackTrace));
  }
}
