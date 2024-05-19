import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storepedia/model/user_model.dart';

class FirestoreOperations {
  FirestoreOperations() {
    _firebaseFirestore = FirebaseFirestore.instance;
  }

  late FirebaseFirestore _firebaseFirestore;

  Future<DocumentSnapshot> readDocument(
      String collection, String userId) async {
    return _firebaseFirestore.collection(collection).doc(userId).get();
  }

  Future<void> crateDocument(
      String collection, String docId, UserModel userData) async {
    await _firebaseFirestore
        .collection(collection)
        .doc(docId)
        .set(userData.toMap)
        .onError((e, stackTrace) {
      Future.error(e.toString(), stackTrace);
    });
  }

  Future<void> editDocument(String collection, String documentId,
      Map<String, dynamic> document) async {
    await _firebaseFirestore
        .collection(collection)
        .doc(documentId)
        .set(document)
        .onError((e, stackTrace) {
      Future.error(e.toString(), stackTrace);
    });
  }

  Future<void> addDocument(
      String collection, Map<String, dynamic> document) async {
    await _firebaseFirestore
        .collection(collection)
        .add(document)
        .onError((error, stackTrace) => Future.error(
              error.toString(),
              stackTrace,
            ));
  }

  Future<List<DocumentSnapshot>> queryWithListKeywords(
      List<String> keywords,
      String collection,
      String targetField,
      int resultLimit,
      String orderByField) async {
    return _firebaseFirestore
        .collection(collection)
        .where(targetField, arrayContainsAny: keywords)
        //.orderBy(orderByField)
        .limit(resultLimit)
        .get()
        .then((value) => value.docs)
        .onError((error, stackTrace) => Future.error(
              error.toString(),
              stackTrace,
            ));
  }

  Future<List<DocumentSnapshot>> pagenateQueryWithListKeywords(
      List<String> keywords,
      String collection,
      String targetField,
      int resultLimit,
      String orderByField,
      DocumentSnapshot startAfter) {
    return _firebaseFirestore
        .collection(collection)
        .where(targetField, arrayContainsAny: keywords)
        //.orderBy(orderByField)
        .limit(resultLimit)
        .startAfterDocument(startAfter)
        .get()
        .then((value) => value.docs)
        .onError((error, stackTrace) => Future.error(
              error.toString(),
              stackTrace,
            ));
  }

  Future<List<DocumentSnapshot>> paginateQueryWithValue(
      String collection,
      String field,
      bool fieldValue,
      int limit,
      String orderBy,
      DocumentSnapshot startAfter) {
    return _firebaseFirestore
        .collection(collection)
        .where(field, isEqualTo: fieldValue)
        // .orderBy(orderBy)
        .limit(limit)
        .startAfterDocument(startAfter)
        .get()
        .then((value) => value.docs)
        .onError(
            (error, stackTrace) => Future.error(error.toString(), stackTrace));
  }

  Future<List<DocumentSnapshot>> queryWithValue(
    String collection,
    String field,
    bool fieldValue,
    int limit,
    String orderBy,
  ) {
    return _firebaseFirestore
        .collection(collection)
        .where(field, isEqualTo: fieldValue)
        // .orderBy(orderBy)
        .limit(limit)
        .get()
        .then((value) => value.docs)
        .onError(
            (error, stackTrace) => Future.error(error.toString(), stackTrace));
  }

  Future<List<DocumentSnapshot>> paginateQueryWithStringValue(
      String collection,
      String field,
      String fieldValue,
      String field2,
      String field2Value,
      int limit,
      String orderBy,
      {DocumentSnapshot? startAfter}) {
    return startAfter == null
        ? _firebaseFirestore
            .collection(collection)
            .where(field, isEqualTo: fieldValue)
            .where(field2, isEqualTo: field2Value)
            // .orderBy(orderBy)
            .limit(limit)
            .get()
            .then((value) => value.docs)
            .onError((error, stackTrace) =>
                Future.error(error.toString(), stackTrace))
        : _firebaseFirestore
            .collection(collection)
            .where(field, isEqualTo: fieldValue)
            .where(field2, isEqualTo: field2Value)
            // .orderBy(orderBy)
            .limit(limit)
            .startAfterDocument(startAfter)
            .get()
            .then((value) => value.docs)
            .onError((error, stackTrace) =>
                Future.error(error.toString(), stackTrace));
  }

  Stream<List<DocumentSnapshot>> streamRecentDocs(
    String collection,
    String sortField,
    int quantity,
  ) {
    return _firebaseFirestore
        .collection(collection)
        .orderBy(sortField, descending: true)
        .limit(quantity)
        .snapshots()
        .map((event) => event.docs);
  }

  Future<void> deleteDocumentLevel1(String collection, String documentId) {
    return _firebaseFirestore
        .collection(collection)
        .doc(documentId)
        .delete()
        .onError(
            (error, stackTrace) => Future.error(error.toString(), stackTrace));
  }
}
