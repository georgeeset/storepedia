import 'package:hydrated_bloc/hydrated_bloc.dart';

class DepartmentSelectorCubit extends HydratedCubit<String> {
  DepartmentSelectorCubit() : super('Electrical');
  late String department;

  changeDepartment({required department}) {
    emit(department);
  }

  @override
  String? fromJson(Map<String, dynamic> json) {
    return json['value'];
  }

  @override
  Map<String, dynamic>? toJson(String state) {
    return {'value': state};
  }
}
