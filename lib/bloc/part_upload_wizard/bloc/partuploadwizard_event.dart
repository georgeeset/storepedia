part of 'partuploadwizard_bloc.dart';

abstract class PartuploadwizardEvent extends Equatable {
  const PartuploadwizardEvent();

  @override
  List<Object> get props => [];
}

class UploadPartEvent extends PartuploadwizardEvent {
  final Part part;
  final int score;
  const UploadPartEvent({required this.part, required this.score});

  @override
  List<Object> get props => [part, score];
}

class DeletePartEvent extends PartuploadwizardEvent {
  /// document id to be deleted
  final String partId;

  /// company collection where to find the document to delete
  final String companyName;
  const DeletePartEvent({required this.partId, required this.companyName});
}
