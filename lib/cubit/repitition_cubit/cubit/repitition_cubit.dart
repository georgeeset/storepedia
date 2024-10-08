import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:storepedia/model/part.dart';
import 'package:storepedia/repository/part_query.dart';

part 'repitition_state.dart';

class RepititionCubit extends Cubit<RepititionCubitState> {
  RepititionCubit() : super(RepititionInitialState());

  ///Pick the important search strings and search for repitition on the DB
  searchDB(
      {String? partNumber,
      String? storageLocation,
      required String companyName,
      String? storeid}) {
    PartQuery partQuery = PartQuery();
    partQuery
        .searchPart(
      searchString: '${storageLocation ?? ''} ${storeid ?? ''}',
      company: companyName,
    )
        .then((value) {
      if (value == null) {
        emit(RepititionNotFoundState());
      } else {
        emit(RepititionFoundState(partsFound: value));
      }
    }).onError((error, stackTrace) {
      emit(RepititionSearchError(
          errorMessage: error.toString(), stackTrace: stackTrace));
    });
  }

  @override
  void onChange(Change<RepititionCubitState> change) {
    print('Repitition Cubit State=> ${change.nextState}');
    super.onChange(change);
  }
}
