import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:store_pedia/model/part.dart';
import 'package:store_pedia/model/user_model.dart';
import 'package:store_pedia/repository/string_processor.dart';

class EditItemCubit extends HydratedCubit<Part> {
  late Part part;
  EditItemCubit() : super(Part()) {
    // part = Part();
    print('buildef-------------');
  }

  editPartName(String partName) {
    emit(state.copyWith(partName: partName));
  }

  editPartDescription(String partDescription) {
    emit(state.copyWith(partDescription: partDescription));
  }

  editPartNumber(String partNumber) {
    emit(state.copyWith(partNumber: partNumber));
  }

  editStoreid(String storeId) {
    emit(state.copyWith(storeId: storeId));
  }

  editStoreLocation(String storeLocation) {
    emit(state.copyWith(storeLocation: storeLocation));
  }

  editSection(String section) {
    emit(state.copyWith(section: section));
  }

  editBrand(String brand) {
    emit(state.copyWith(brand: brand));
  }

  editCommonlyUsed(bool choice) {
    emit(state.copyWith(commonlyUsed: choice));
  }

  editPhoto(String photo) {
    emit(state.copyWith(photo: photo));
  }

  clearPart() {
    emit(state.clear());
  }

  jumpEdit(Part newPart) {
    state.clear();
    emit(state.copyWith(
      partName: newPart.partName,
      partDescription: newPart.partDescription,
      partNumber: newPart.partNumber,
      storeId: newPart.storeId,
      storeLocation: newPart.storeLocation,
      addedBy: newPart.addedBy,
      addedById: newPart.addedById,
      dateAdded: newPart.dateAdded,
      lastEditedBy: newPart.lastEditedBy,
      section: newPart.section,
      brand: newPart.brand,
      likesCount: newPart.likesCount,
      photo: newPart.photo,
      markedBadByUid: newPart.markedBadByUid,
      reasonForMarkingBad: newPart.reasonForMarkingBad,
      searchKeywords: newPart.searchKeywords,
      partUid: newPart.partUid,
    ));
  }

  updateTheRestInfo(UserModel user) {
    //  required String addedBy,
    //  required String addedById,
    //  required String dateAdded,
    //  required searchKeywords,
    var combinedString =
        '${state.partDescription ?? ''} ${state.partName ?? ''}  ${state.partNumber ?? ''} ${state.partNumber?.substring(0, 3)} ${state.storeId ?? ''} ${state.storeLocation ?? ''}';
    StringProcessor stringProcessor = StringProcessor();
    print(state.partUid);
    if (state.partUid == null) {
      emit(
        state.copyWith(
          addedBy: user.userName,
          addedById: user.userId,
          dateAdded: DateTime.now().millisecondsSinceEpoch,
          searchKeywords: stringProcessor.searchKeywords(combinedString),
        ),
      );
    } else {
      emit(state.copyWith(
        lastEditedBy: user.userName,
        searchKeywords: stringProcessor.searchKeywords(combinedString),
      ));
    }
  }

  @override
  Part? fromJson(Map<String, dynamic> json) {
    return Part.fromMap(mapFormat: json['value']);
  }

  @override
  Map<String, dynamic>? toJson(Part state) {
    return {'value': state.toMap()};
  }
}
