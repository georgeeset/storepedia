part of 'partuploadwizard_bloc.dart';

abstract class PartuploadwizardState extends Equatable {
  const PartuploadwizardState();
  
  @override
  List<Object> get props => [];
}

class PartuploadwizardIdleState extends PartuploadwizardState {
  @override
  String toString() {
    return 'PartuploadWizardIdle';
  }
}

class PartuploadwizardLoadingState extends PartuploadwizardState{

  @override
  String toString() {
    return 'PartuploadwizardLoading';
  }
}

class PartuploadwizardLoadedState extends PartuploadwizardState{
  
  @override
  String toString() {
    return 'PartUploadWizardLoaded';
  }
}

class PartuploadwizardErrorState extends PartuploadwizardState{
  final String message;
  PartuploadwizardErrorState({required this.message});

  @override
  String toString() {
    return 'PartUploadWizardErrorState';
  }
}