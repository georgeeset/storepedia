import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/string_constants.dart' as string_constants;

class Part {
  String? partName;
  String? partDescription;
  String? partNumber;
  String? storeId;
  String? storeLocation;
  String? addedBy;
  String? addedById;
  int? dateAdded;
  String? lastEditedBy;
  String? section;
  String? brand;
  int? likesCount;

  ///if a part is almost finished,
  ///this field should be switched to true
  bool isExhausted = false;

  ///time of marking a store item as exhausted
  ///we will need that to sort exhausted items
  int? markExhaustedTime;

  ///unique ad for part Document
  String? partUid;

  /// search keywords will be updated
  /// whenever the part description and
  /// part name is changed or created
  List<String>? searchKeywords;

  String? photo;
  String? markedBadByUid;
  String? reasonForMarkingBad;

  String? price;
  int? quantity;
  String? company;
  String? branch;

  Part(
      {this.partName,
      this.partDescription,
      this.partNumber,
      this.storeId,
      this.storeLocation,
      this.addedBy,
      this.addedById,
      this.dateAdded,
      this.lastEditedBy,
      this.section,
      this.brand,
      this.likesCount,
      this.searchKeywords,
      this.photo,
      this.markedBadByUid,
      this.reasonForMarkingBad,
      this.partUid,
      this.isExhausted = false,
      this.markExhaustedTime,
      this.price,
      this.quantity,
      this.company,
      this.branch});

  Part.fromMap({DocumentSnapshot? snapshot, Map<String, dynamic>? mapFormat}) {
    Map<String, dynamic> data;
    if (mapFormat == null && snapshot != null) {
      data = snapshot.data() as Map<String, dynamic>;
    } else {
      if (mapFormat != null) {
        data = mapFormat;
      } else {
        throw ('No Valid Input');
      }
    }

    partName = data[string_constants.partName];
    partDescription = data[string_constants.partDescription];
    partNumber = data[string_constants.partNumber];
    storeId = data[string_constants.storeId];
    storeLocation = data[string_constants.storeLocation];
    addedBy = data[string_constants.addedBy];
    addedById = data[string_constants.addedById];
    dateAdded = data[string_constants.dateAdded];
    lastEditedBy = data[string_constants.lastEditedBy];
    section = data[string_constants.section];
    brand = data[string_constants.brand];
    likesCount = data[string_constants.likesCount];
    isExhausted = data[string_constants.isExhausted] ?? false;
    markExhaustedTime = data[string_constants.markExhaustedTime];
    searchKeywords =
        List<String>.from(data[string_constants.searchKeywords] ?? []);
    photo = data[string_constants.photo];
    markedBadByUid = data[string_constants.markedBadByUid];
    reasonForMarkingBad = data[string_constants.reasonFormarkingBad];
    partUid = snapshot?.id;

    price = data[string_constants.price];
    quantity = data[string_constants.quantity];
    company = data[string_constants.company];
    branch = data[string_constants.branch];
  }

  Map<String, dynamic> toMap() => {
        string_constants.partName: partName,
        string_constants.partDescription: partDescription,
        string_constants.partNumber: partNumber,
        string_constants.storeId: storeId,
        string_constants.storeLocation: storeLocation,
        string_constants.addedBy: addedBy,
        string_constants.dateAdded: dateAdded,
        string_constants.addedById: addedById,
        string_constants.lastEditedBy: lastEditedBy,
        string_constants.section: section,
        string_constants.brand: brand,
        string_constants.likesCount: likesCount,
        string_constants.isExhausted: isExhausted,
        string_constants.markExhaustedTime: markExhaustedTime,
        string_constants.searchKeywords: searchKeywords,
        string_constants.photo: photo,
        string_constants.markedBadByUid: markedBadByUid,
        string_constants.reasonFormarkingBad: reasonForMarkingBad,
        string_constants.price: price,
        string_constants.quantity: quantity,
        string_constants.company: company,
        string_constants.branch: branch
      };

  copyWith(
      {String? partName,
      String? partDescription,
      String? partNumber,
      String? storeId,
      String? storeLocation,
      String? addedBy,
      String? addedById,
      int? dateAdded,
      String? lastEditedBy,
      String? section,
      String? brand,
      int? likesCount,
      List<String>? searchKeywords,
      String? photo,
      String? markedBadByUid,
      String? reasonForMarkingBad,
      String? partUid,
      bool? isExhausted,
      int? markExhaustedTime,
      String? price,
      int? quantity,
      String? company,
      String? branch}) {
    return Part(
        partName: partName ?? this.partName,
        partDescription: partDescription ?? this.partDescription,
        partNumber: partNumber ?? this.partNumber,
        storeId: storeId ?? this.storeId,
        storeLocation: storeLocation ?? this.storeLocation,
        addedBy: addedBy ?? this.addedBy,
        addedById: addedById ?? this.addedById,
        dateAdded: dateAdded ?? this.dateAdded,
        lastEditedBy: lastEditedBy ?? this.lastEditedBy,
        section: section ?? this.section,
        brand: brand ?? this.brand,
        likesCount: likesCount ?? this.likesCount,
        searchKeywords: searchKeywords ?? this.searchKeywords,
        photo: photo ?? this.photo,
        markedBadByUid: markedBadByUid ?? this.markedBadByUid,
        reasonForMarkingBad: reasonForMarkingBad ?? this.reasonForMarkingBad,
        partUid: partUid ?? this.partUid,
        isExhausted: isExhausted ?? this.isExhausted,
        markExhaustedTime: markExhaustedTime ?? this.markExhaustedTime,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
        company: company ?? this.company,
        branch: branch ?? this.branch);
  }

  clear() {
    return Part(photo: null);
  }
}
