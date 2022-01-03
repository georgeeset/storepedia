import 'package:bloc/bloc.dart';
import 'package:store_pedia/model/part.dart';
import 'package:store_pedia/repository/firestore_operaions.dart';
import 'package:store_pedia/constants/string_constants.dart' as StringConstants;

enum MarkpartState { idle, loading, loaded }

class MarkpartCubit extends Cubit<MarkpartState> {
  MarkpartCubit() : super(MarkpartState.idle);
  final FirestoreOperations _firestoreOperations = FirestoreOperations();

  markBad(
      {required Part part,
      required String reason,
      required String userId}) async {
    part = part.copyWith(reasonForMarkingBad: reason, markedBadByUid: userId);
    emit(MarkpartState.loading);
    await _firestoreOperations
        .editDocument(
            StringConstants.partsCollection, part.partUid!, part.toMap())
        .then((_) => emit(MarkpartState.loaded))
        .onError((error, stackTrace) => emit(MarkpartState.idle));
  }
}
