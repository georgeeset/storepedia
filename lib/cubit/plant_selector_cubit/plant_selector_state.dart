part of 'plant_selector_cubit.dart';

abstract class PlantSelectorState extends Equatable {
  @override
  List<Object> get props => [];
}

class PlantSelectorLoading extends PlantSelectorState {
  @override
  String toString() {
    return 'PlantSelectorLoadingState';
  }
}

class PlantSelectorLoaded extends PlantSelectorState {
  PlantSelectorLoaded({required this.plantList});
  final List<Plant> plantList;
  @override
  String toString() {
    return 'PlantSelectorLoadedState';
  }

  @override
  List<Object> get props => [plantList];
}

class PlantSelected extends PlantSelectorState {
  final Plant selectedPlant;
  PlantSelected({required this.selectedPlant});

  @override
  String toString() {
    return 'PlantSelectedState';
  }

  @override
  List<Object> get props => [selectedPlant];
}

class PlantSelectorError extends PlantSelectorState {
  final String errorMessage;
  final StackTrace? stackTrace;
  PlantSelectorError({required this.errorMessage, this.stackTrace});

  @override
  String toString() {
    return 'PlantSelectorErrorState';
  }

  @override
  List<Object> get props => [errorMessage];
}
