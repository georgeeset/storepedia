import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:storepedia/model/part.dart';
import 'package:storepedia/repository/part_operations_repository.dart';
import 'package:storepedia/constants/number_constants.dart' as NumberConstants;

part 'partuploadwizard_event.dart';
part 'partuploadwizard_state.dart';

class PartuploadwizardBloc
    extends Bloc<PartuploadwizardEvent, PartuploadwizardState> {
  PartuploadwizardBloc() : super(PartuploadwizardIdleState()) {
    final PartOperationsRepository partOperationsRepository =
        PartOperationsRepository();
    // @override
    // Stream<PartuploadwizardState> mapEventToState(
    //   PartuploadwizardEvent event,
    // ) async* {
    on<UploadPartEvent>((event, emit) async {
      emit(PartuploadwizardLoadingState());
      if (event.part.photo != null &&
          event.score > NumberConstants.minimumScore) {
        print(event.part.partUid);
        if (event.part.partUid != null) {
          await partOperationsRepository
              .editPart(event.part)
              .then((value) => emit(PartuploadwizardLoadedState()))
              .onError(
                (error, stackTrace) => emit(
                  PartuploadwizardErrorState(message: error.toString()),
                ),
              );
        } else {
          print('New Part');
          await partOperationsRepository
              .addPart(event.part)
              .then((value) => emit(PartuploadwizardLoadedState()))
              .onError(
                (error, stackTrace) => emit(PartuploadwizardErrorState(
                  message: error.toString(),
                )),
              );
        }
      } else {
        emit(const PartuploadwizardErrorState(message: 'Form is not yet complete!'));
      }
    });

    on<DeletePartEvent>((event, emit) async {
      emit(PartuploadwizardLoadingState());

      partOperationsRepository
          .deletePart(partId: event.partId)
          .then((value) => emit(PartuploadwizardLoadedState()))
          .onError((error, stackTrace) =>
              emit(PartuploadwizardErrorState(message: error.toString())));
    });
  }

  @override
  void onChange(Change<PartuploadwizardState> change) {
    print(change.nextState);
    var nxt = change.nextState;
    if (nxt is PartuploadwizardErrorState) {
      print(nxt.message);
    }
    super.onChange(change);
  }
}
