import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_pedia/constants/string_constants.dart' as StringConstants;

class Plant {
  String? companyId;
  String? location;
  String? partCollection;

  Plant({
    this.companyId,
    this.location,
    this.partCollection,
  });

  Plant.fromMap({required DocumentSnapshot snapshot}) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    companyId = data[StringConstants.companyId];
    location = data[StringConstants.location];
    partCollection = data[StringConstants.partCollection];
  }

  Map<String, dynamic> get toMap => {
        StringConstants.companyId: companyId,
        StringConstants.location: location,
        StringConstants.partCollection: partCollection,
      };

  copyWith({
    String? companyId,
    String? location,
    String? partCollection,
  }) {
    return Plant(
      companyId: companyId ?? this.companyId,
      location: location ?? this.location,
      partCollection: partCollection ?? this.partCollection,
    );
  }
}
