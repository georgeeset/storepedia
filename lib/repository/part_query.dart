import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storepedia/model/part.dart';
import 'package:storepedia/repository/firestore_operaions.dart';
import 'package:storepedia/repository/string_processor.dart';
import 'package:storepedia/constants/string_constants.dart' as string_constants;
import 'package:storepedia/constants/number_constants.dart' as number_constants;

class PartQuery {
  final FirestoreOperations _firestoreOperations = FirestoreOperations();
  final StringProcessor _stringProcessor = StringProcessor();

  DocumentSnapshot? lastDoc;
  DocumentSnapshot? exhaustedLastDoc;

  ///returns null if query yields no result.
  ///returns List of parts if qurey yeild result.
  ///if newSearch is false, dont forget to add the last document
  Future<List<Part>?> searchPart(
      {required String searchString,
      required String company,
      bool newSearch = true,
      String? branch}) async {
    //keywords form here...
    var keywords = _stringProcessor.searchKeywords(searchString);

    if (keywords.isEmpty) {
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
              company,
              string_constants.searchKeywords,
              number_constants.maximumSearchResult,
              string_constants.likesCount,
              lastDoc!)
          .onError(
            (error, stackTrace) => Future.error(error.toString(), stackTrace),
          );
    } else {
      queryResult = await _firestoreOperations
          .queryWithListKeywords(
              keywords,
              company,
              string_constants.searchKeywords,
              number_constants.maximumSearchResult,
              string_constants.likesCount)
          .onError(
            (error, stackTrace) => Future.error(error.toString(), stackTrace),
          );
    }

    lastDoc = queryResult.isEmpty
        ? null
        : queryResult
            .last; // keep the last document in case we need to paginate.

    var partList =
        queryResult.map((data) => Part.fromMap(snapshot: data)).toList();
    if (partList.isEmpty) return partList;

    partList.sort((a, b) {
      return relevanceCalc(keywords, b.searchKeywords ?? [])
          .compareTo(relevanceCalc(keywords, a.searchKeywords ?? []));
    });

    return partList;
  }

  int relevanceCalc(List<String> searchKeywords, List<String> itemKeywords) {
    final skw = searchKeywords.toSet();
    final ikw = itemKeywords.toSet();
    return ikw.intersection(skw).length;
  }
}
