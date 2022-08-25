import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:store_pedia/repository/plant_list_loader.dart';

import '../../model/plant_model.dart';

part 'plant_selector_state.dart';

class PlantSelectorCubit extends Cubit<PlantSelectorState> {
  PlantSelectorCubit() : super(PlantSelectorLoading()) {
    //load list of plants here and change state depending on download result.
    PlantListLoader plantListLoader = PlantListLoader();
    emit(PlantSelectorLoading());
    plantListLoader
        .getPlants()
        .then((value) => emit(PlantSelectorLoaded(plantList: value)))
        .onError(
          (error, stackTrace) => emit(
            PlantSelectorError(
                errorMessage: error.toString(), stackTrace: stackTrace),
          ),
        );
  }

  selectPlant(Plant selectedPlant) {
    emit(PlantSelected(selectedPlant: selectedPlant));
  }
}
