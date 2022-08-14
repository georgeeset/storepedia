import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_pedia/repository/firestore_operaions.dart';
import 'package:store_pedia/constants/string_constants.dart' as StringConstants;
import 'package:store_pedia/constants/number_constants.dart' as NumberConstants;

import '../model/part.dart';

class CommonitemRepository {
  final FirestoreOperations _firestoreOperations = FirestoreOperations();

  DocumentSnapshot? lastDoc;

  Future<List<Part>?> search(String department) async {
    List<DocumentSnapshot> queryResult;
    if (lastDoc != null) {
      queryResult = await _firestoreOperations
          .paginateQueryWithTwoValues(
              StringConstants.partsCollection,
              StringConstants.commonlyUsed,
              StringConstants.section,
              true,
              department,
              NumberConstants.maximumSearchResult,
              StringConstants.dateAdded,
              lastDoc!)
          .onError(
            (error, stackTrace) => Future.error(error.toString(), stackTrace),
          );
    } else {
      print(department);
      queryResult = await _firestoreOperations.qaueryWithTwoValues(
        StringConstants.partsCollection,
        StringConstants.commonlyUsed,
        StringConstants.section,
        true,
        department,
        NumberConstants.maximumSearchResult,
        StringConstants.dateAdded,
      );
    }

    if (queryResult.isEmpty) {
      print('commonly used query result empty');
      return null;
    }

    lastDoc = queryResult.last;
    return queryResult.map((data) => Part.fromMap(snapshot: data)).toList();
  }

  clearLastDoc() {
    lastDoc = null;
  }
}
