import 'package:bloc/bloc.dart';
import 'package:store_pedia/model/part.dart';
import 'package:store_pedia/repository/firestore_operaions.dart';
import 'package:store_pedia/constants/string_constants.dart'as StringConstants;

enum MarkbadpartState{idle, loading, loaded}

class MarkbadpartCubit extends Cubit<MarkbadpartState> {
  MarkbadpartCubit() : super(MarkbadpartState.idle);
  final FirestoreOperations _firestoreOperations=FirestoreOperations();

  markBad({required Part part, required String reason, required String userId}){
    part=part.copyWith(reasonForMarkingBad: reason, markedBadByUid: userId);
    emit(MarkbadpartState.loading);
    _firestoreOperations.editDocument(StringConstants.partsCollection,part.partUid!, part.toMap()).then((_) => emit(MarkbadpartState.loaded));
  }
}
