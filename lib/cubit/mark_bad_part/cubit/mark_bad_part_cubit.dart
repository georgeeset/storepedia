import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storepedia/model/part.dart';
import 'package:storepedia/repository/firestore_operaions.dart';

enum MarkpartState { idle, loading, loaded }

class MarkpartCubit extends Cubit<MarkpartState> {
  MarkpartCubit() : super(MarkpartState.idle);
  final FirestoreOperations _firestoreOperations = FirestoreOperations();

  markBad({
    required Part part,
    required String reason,
    required String userId,
    required String companyName,
  }) async {
    part = part.copyWith(reasonForMarkingBad: reason, markedBadByUid: userId);
    emit(MarkpartState.loading);
    await _firestoreOperations
        .editDocument(companyName, part.partUid!, part.toMap())
        .then((_) => emit(MarkpartState.loaded))
        .onError((error, stackTrace) => emit(MarkpartState.idle));
  }
}
