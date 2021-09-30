import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:store_pedia/model/part.dart';
import 'package:store_pedia/repository/part_query.dart';

part 'partquerymanager_state.dart';

class PartquerymanagerCubit extends Cubit<PartquerymanagerState> {
  PartquerymanagerCubit() : super(PartquerymanagerInitialState());
  final PartQuery partQueryRepository=PartQuery();

  attemptQuery(String query){

    if(query.length>3 && query.contains(' ')){
      emit(PartqueryloadingState());
      partQueryRepository.searchPart(searchString: query).then((value) {
        if(value==null){
          emit(NopartfoundState());
        }
        else{
          emit( PartqueryloadedState(response:value) );
        }
      }).onError((error, stackTrace) {
        emit(PartqueryerrorState(message: error.toString(),stackTrace: stackTrace));
      });

    }
  }


  @override
  void onChange(Change<PartquerymanagerState> change) {
    print(change.nextState);
    var msg=change.nextState;
    // if(msg is PartqueryerrorState){
    //   print(msg.stackTrace);
    // }
    super.onChange(change);
  }
}
