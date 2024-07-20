import 'package:storepedia/model/part.dart';
import 'package:storepedia/repository/firestore_operaions.dart';

class PartOperationsRepository extends FirestoreOperations {
  PartOperationsRepository({required this.partsCollection});
  final String partsCollection;

  Future<void> storePart(Part part) async {
    return addDocument(partsCollection, part.toMap());
  }

  Future<void> editPart(Part part) async {
    /// Update an existing part document
    return editDocument(partsCollection, part.partUid!, part.toMap()).onError(
      (error, stackTrace) => Future.error(error.toString(), stackTrace),
    );
  }

  Future<void> addPart(Part part) async {
    /// Add new part document
    return addDocument(partsCollection, part.toMap()).onError(
      (error, stackTrace) => Future.error(error.toString(), stackTrace),
    );
  }

  Future<void> deletePart({required partId}) {
    /// Delete part document
    return deleteDocumentLevel1(partsCollection, partId).onError(
        (error, stackTrace) => Future.error(error.toString(), stackTrace));
  }
}
