import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_pedia/model/user_model.dart';

class FirestoreOperations {
  FirestoreOperations() {
    _firebaseFirestore = FirebaseFirestore.instance;
  }

  late FirebaseFirestore _firebaseFirestore;

  Future<DocumentSnapshot> readDocument(
      String collection, String userId) async {
    print(userId);
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
        .update(document)
        .onError((e, stackTrace) {
      Future.error(e.toString(), stackTrace);
    });
  }

  Future<void> addDocument(
      String collection, Map<String, dynamic> document) async {
    await _firebaseFirestore.collection(collection).add(document).onError(
        (error, stackTrace) => Future.error(error.toString(), stackTrace));
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
        .onError(
            (error, stackTrace) => Future.error(error.toString(), stackTrace));
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
        .onError(
            (error, stackTrace) => Future.error(error.toString(), stackTrace));
  }
}
