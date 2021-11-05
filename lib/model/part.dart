import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/string_constants.dart' as StringConstants;

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
  
  ///unique ad for part Document
  String? partUid;

  /// search keywords will be updated
  /// whenever the part description and
  /// part name is changed or created
  List<String>? searchKeywords;

  String? photo;
  String? markedBadByUid;
  String? reasonForMarkingBad;

  Part({
    this.partName,
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
    this.photo ,
    this.markedBadByUid,
    this.reasonForMarkingBad,
    this.partUid,
  });


  Part.fromMap({DocumentSnapshot? snapshot, Map<String,dynamic>? mapFormat} ) {
    Map<String,dynamic> data;
    if(mapFormat==null && snapshot!=null){data = snapshot.data() as Map<String,dynamic>;}
    else{
      if(mapFormat!=null){data=mapFormat;}
      else{
        throw('No Valid Input');
      }
    }
    partName= data[StringConstants.partName];
    partDescription= data[StringConstants.partDescription];
    partNumber= data[StringConstants.partNumber];
    storeId= data[StringConstants.storeId];
    storeLocation= data[StringConstants.storeLocation];
    addedBy= data[StringConstants.addedBy];
    addedById= data[StringConstants.addedById];
    dateAdded= data[StringConstants.dateAdded];
    lastEditedBy= data[StringConstants.lastEditedBy];
    section= data[StringConstants.section];
    brand= data[StringConstants.brand];
    likesCount= data[StringConstants.likesCount];
    searchKeywords= List<String>.from(data[StringConstants.searchKeywords]?? []);
    photo= data[StringConstants.photo];
    markedBadByUid= data[StringConstants.markedBadByUid];
    reasonForMarkingBad= data[StringConstants.reasonFormarkingBad];
    partUid=snapshot?.id;
  }


  Map<String,dynamic> toMap()=> {
    StringConstants.partName:partName,
    StringConstants.partDescription: partDescription,
    StringConstants.partNumber: partNumber,
    StringConstants.storeId: storeId,
    StringConstants.storeLocation: storeLocation,
    StringConstants.addedBy: addedBy,
    StringConstants.dateAdded: dateAdded,
    StringConstants.addedById: addedById,
    StringConstants.lastEditedBy: lastEditedBy,
    StringConstants.section: section,
    StringConstants.brand: brand,
    StringConstants.likesCount: likesCount,
    StringConstants.searchKeywords: searchKeywords,
    StringConstants.photo:photo,
    StringConstants.markedBadByUid: markedBadByUid,
    StringConstants.reasonFormarkingBad:reasonForMarkingBad,
  } ;
  

  copyWith({
    String? partName,
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
  }){
    return Part( partName:partName?? this.partName,
    partDescription: partDescription?? this.partDescription,
    partNumber: partNumber?? this.partNumber,
    storeId: storeId?? this.storeId,
    storeLocation: storeLocation?? this.storeLocation,
    addedBy: addedBy?? this.addedBy,
    addedById: addedById?? this.addedById,
    dateAdded: dateAdded?? this.dateAdded,
    lastEditedBy: lastEditedBy?? this.lastEditedBy,
    section: section?? this.section,
    brand: brand?? this.brand,
    likesCount: likesCount?? this.likesCount,
    searchKeywords: searchKeywords?? this.searchKeywords,
    photo: photo?? this.photo,
    markedBadByUid: markedBadByUid?? this.markedBadByUid,
    reasonForMarkingBad: reasonForMarkingBad?? this.reasonForMarkingBad,
    partUid: partUid?? this.partUid,
    );
  }

  clear(){
    return Part();
  }
}