part of 'partuploadwizard_bloc.dart';

abstract class PartuploadwizardEvent extends Equatable {
  const PartuploadwizardEvent();

  @override
  List<Object> get props => [];
}

class UploadPartEvent extends PartuploadwizardEvent{
  final Part part;
  final int score;
  const UploadPartEvent({required this.part,required this.score});
    
  @override
  List<Object> get props => [part,score];
}

class DeletePartEvent extends PartuploadwizardEvent{
  final String partId;
  const DeletePartEvent({required this.partId});
}
