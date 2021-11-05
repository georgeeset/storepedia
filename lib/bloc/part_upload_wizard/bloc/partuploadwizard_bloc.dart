import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:store_pedia/model/part.dart';
import 'package:store_pedia/repository/part_operations_repository.dart';
import 'package:store_pedia/constants/number_constants.dart' as NumberConstants;

part 'partuploadwizard_event.dart';
part 'partuploadwizard_state.dart';

class PartuploadwizardBloc
    extends Bloc<PartuploadwizardEvent, PartuploadwizardState> {
  PartuploadwizardBloc() : super(PartuploadwizardIdleState());
  final PartOperationsRepository partOperationsRepository =
      PartOperationsRepository();
  @override
  Stream<PartuploadwizardState> mapEventToState(
    PartuploadwizardEvent event,
  ) async* {
    if (event is UploadPartEvent) {
      yield(PartuploadwizardLoadingState());
      if (event.part.photo != null && event.score>NumberConstants.minimumScore) {
        print(event.part.partUid);
        if (event.part.partUid != null) {
         
          partOperationsRepository
              .editPart(event.part)
              .then((value) => emit(PartuploadwizardLoadedState()))
              .onError((error, stackTrace) =>
                  emit(PartuploadwizardErrorState(message: error.toString()),),);
        }else {
          print('New Part');
        partOperationsRepository
            .addPart(event.part)
            .then((value) => emit(PartuploadwizardLoadedState()))
            .onError(
              (error, stackTrace) => emit(PartuploadwizardErrorState(
                message: error.toString(),
              )),
            );
      }

      }else{
        yield(PartuploadwizardErrorState(message: 'Form is not yet complete!'));
      }
    }
    
  }
  @override
  void onChange(Change<PartuploadwizardState> change) {
    print(change.nextState);
    var nxt=change.nextState;
    if(nxt  is PartuploadwizardErrorState){
      print(nxt.message);
    }
    super.onChange(change);
  }
}
