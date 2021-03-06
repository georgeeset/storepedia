import 'package:bloc/bloc.dart';
import 'package:store_pedia/model/part.dart';
import 'package:store_pedia/repository/firestore_operaions.dart';
import 'package:store_pedia/constants/string_constants.dart' as StringConstants;

enum MarkexhaustedpartState { idle, loading, loaded }

class MarkexhaustedpartCubit extends Cubit<MarkexhaustedpartState> {
  MarkexhaustedpartCubit() : super(MarkexhaustedpartState.idle);

  final FirestoreOperations _firestoreOperations = FirestoreOperations();

  makrExhausted({required bool data, required Part part}) async {
    part = part.copyWith(
      isExhausted: data,
      markExhaustedTime: DateTime.now().millisecondsSinceEpoch,
    );
    emit(MarkexhaustedpartState.loading);

    await _firestoreOperations
        .editDocument(
            StringConstants.partsCollection, part.partUid!, part.toMap())
        .then((_) => emit(MarkexhaustedpartState.loaded))
        .onError((error, stackTrace) => emit(MarkexhaustedpartState.idle));
  }
}
