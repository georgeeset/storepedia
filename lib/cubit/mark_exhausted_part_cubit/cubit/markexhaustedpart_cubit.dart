import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storepedia/model/part.dart';
import 'package:storepedia/repository/firestore_operaions.dart';

enum MarkexhaustedpartState { idle, loading, loaded }

class MarkexhaustedpartCubit extends Cubit<MarkexhaustedpartState> {
  MarkexhaustedpartCubit() : super(MarkexhaustedpartState.idle);

  final FirestoreOperations _firestoreOperations = FirestoreOperations();

  makrExhausted({
    required bool data,
    required Part part,
    required String companyName,
  }) async {
    part = part.copyWith(
      isExhausted: data,
      markExhaustedTime: DateTime.now().millisecondsSinceEpoch,
    );
    emit(MarkexhaustedpartState.loading);

    await _firestoreOperations
        .editDocument(companyName, part.partUid!, part.toMap())
        .then((_) => emit(MarkexhaustedpartState.loaded))
        .onError((error, stackTrace) => emit(MarkexhaustedpartState.idle));
  }
}
