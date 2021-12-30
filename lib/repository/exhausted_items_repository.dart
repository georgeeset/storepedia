import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_pedia/model/part.dart';
import 'package:store_pedia/repository/firestore_operaions.dart';

import 'package:store_pedia/constants/string_constants.dart' as StringConstants;
import 'package:store_pedia/constants/number_constants.dart' as NumberConstants;

class ExhaustedItemsRepository {
  final FirestoreOperations _firestoreOperations = FirestoreOperations();

  DocumentSnapshot? lastDoc;

  Future<List<Part>?> search() async {
    List<DocumentSnapshot> queryResult;
    if (lastDoc != null) {
      queryResult = await _firestoreOperations
          .paginateQueryWithValue(
            StringConstants.partsCollection,
            StringConstants.isExhausted,
            true,
            NumberConstants.maximumSearchResult,
            StringConstants.markExhaustedTime,
            lastDoc!,
          )
          .onError(
            (error, stackTrace) => Future.error(error.toString(), stackTrace),
          );
    } else {
      queryResult = await _firestoreOperations
          .queryWithValue(
            StringConstants.partsCollection,
            StringConstants.isExhausted,
            true,
            NumberConstants.maximumSearchResult,
            StringConstants.markExhaustedTime,
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
