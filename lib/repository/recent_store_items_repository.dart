import 'package:storepedia/model/part.dart';
import 'package:storepedia/repository/firestore_operaions.dart';
import 'package:storepedia/constants/string_constants.dart' as StringConstants;

class RecentStoreItemsRepository {
  final FirestoreOperations _firestoreOperations = FirestoreOperations();

  // Future<List<Part>> getRecentItems() {
  //   return _firestoreOperations
  //       .getRecentDocs(
  //           StringConstants.partsCollection, StringConstants.dateAdded, 10)
  //       .then((value) => value.map((e) => Part.fromMap(e)).toList())
  //       .onError((error, stackTrace) => Future.error(
  //             error.toString(),
  //             stackTrace,
  //           ));
  // }

  Stream<List<Part>> fetchRecentItems() {
    return _firestoreOperations
        .streamRecentDocs(
            StringConstants.partsCollection, StringConstants.dateAdded, 10)
        .map((event) => event.map((e) => Part.fromMap(snapshot: e)).toList());
  }
}
