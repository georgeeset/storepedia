import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_pedia/model/part.dart';
import 'package:store_pedia/repository/firestore_operaions.dart';
import 'package:store_pedia/repository/string_processor.dart';
import 'package:store_pedia/constants/string_constants.dart' as StringConstants;
import 'package:store_pedia/constants/number_constants.dart' as NumberConstants;

class PartQuery {
  final FirestoreOperations _firestoreOperations = FirestoreOperations();
  final StringProcessor _stringProcessor = StringProcessor();

  DocumentSnapshot? lastDoc;
  DocumentSnapshot? exhaustedLastDoc;

  ///returns null if query yields no result.
  ///returns List of parts if qurey yeild result.
  ///if newSearch is false, dont forget to add the last document
  Future<List<Part>?> searchPart(
      {required String searchString, bool newSearch = true}) async {
    //keywords form here...
    var keywords = _stringProcessor.searchKeywords(searchString);

    if (keywords.length < 1) {
      print('No KEYWORD');
      return null;
    }
    if (keywords.length > 10) {
      print('keywords too many');
      keywords.removeRange(10, keywords.length);
      print('trimed to..${keywords.length}');
    }
    List<DocumentSnapshot> queryResult;
    if (!newSearch && lastDoc != null) {
      queryResult = await _firestoreOperations
          .pagenateQueryWithListKeywords(
              keywords,
              StringConstants.partsCollection,
              StringConstants.searchKeywords,
              NumberConstants.maximumSearchResult,
              StringConstants.likesCount,
              lastDoc!)
          .onError(
            (error, stackTrace) => Future.error(error.toString(), stackTrace),
          );
    } else {
      queryResult = await _firestoreOperations
          .queryWithListKeywords(
              keywords,
              StringConstants.partsCollection,
              StringConstants.searchKeywords,
              NumberConstants.maximumSearchResult,
              StringConstants.likesCount)
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
