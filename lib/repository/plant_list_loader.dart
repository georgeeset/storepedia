import 'package:store_pedia/model/plant_model.dart';
import 'package:store_pedia/repository/firestore_operaions.dart';
import 'package:store_pedia/constants/string_constants.dart' as StringConstants;

class PlantListLoader {
  FirestoreOperations _firestoreOperations = FirestoreOperations();

  Future<List<Plant>> getPlants() {
    return _firestoreOperations
        .readDocsInCollection(StringConstants.plantscollection)
        .then(
          (value) => value.map((e) => Plant.fromMap(snapshot: e)).toList(),
        )
        .onError(
          (error, stackTrace) => Future.error(
            error.toString(),
            stackTrace,
          ),
        );
  }
}
