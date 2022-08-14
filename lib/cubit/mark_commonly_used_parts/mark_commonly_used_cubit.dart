import 'package:store_pedia/model/part.dart';
import 'package:store_pedia/repository/firestore_operaions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_pedia/constants/string_constants.dart' as StringConstants;

enum MarkCommonlyUsedState { idle, loading, loaded }

class MarkCommonlyusedCubit extends Cubit<MarkCommonlyUsedState> {
  MarkCommonlyusedCubit() : super(MarkCommonlyUsedState.idle);

  final FirestoreOperations _firestoreOperations = FirestoreOperations();

  makrCommonlyused({required bool data, required Part part}) async {
    part = part.copyWith(
      commonlyUsed: data,
    );
    emit(MarkCommonlyUsedState.loading);

    //update part info to database
    await _firestoreOperations
        .editDocument(
            StringConstants.partsCollection, part.partUid!, part.toMap())
        .then((_) => emit(MarkCommonlyUsedState.loaded))
        .onError((error, stackTrace) => emit(MarkCommonlyUsedState.idle));
  }
}
