import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storepedia/model/part.dart';
import 'package:storepedia/repository/firestore_operaions.dart';

import 'package:storepedia/constants/string_constants.dart' as string_constants;
import 'package:storepedia/constants/number_constants.dart' as number_constants;

class ExhaustedItemsRepository {
  final FirestoreOperations _firestoreOperations = FirestoreOperations();

  DocumentSnapshot? lastDoc;

  Future<List<Part>?> search() async {
    List<DocumentSnapshot> queryResult;
    if (lastDoc != null) {
      queryResult = await _firestoreOperations
          .paginateQueryWithValue(
            string_constants.partsCollection,
            string_constants.isExhausted,
            true,
            number_constants.maximumSearchResult,
            string_constants.markExhaustedTime,
            lastDoc!,
          )
          .onError(
            (error, stackTrace) => Future.error(error.toString(), stackTrace),
          );
    } else {
      queryResult = await _firestoreOperations
          .queryWithValue(
            string_constants.partsCollection,
            string_constants.isExhausted,
            true,
            number_constants.maximumSearchResult,
            string_constants.markExhaustedTime,
          )
          .onError(
            (error, stackTrace) => Future.error(error.toString(), stackTrace),
          );
    }

    if (queryResult.isEmpty) {
      print('Search Result Empty');
      return null;
    }

    lastDoc =
        queryResult.last; // keep the last document in case we need to paginate.

    return queryResult.map((data) => Part.fromMap(snapshot: data)).toList();
  }
}
