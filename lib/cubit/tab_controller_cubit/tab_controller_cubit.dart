import 'package:bloc/bloc.dart';

class TabControllerCubit extends Cubit<int> {
  TabControllerCubit() : super(0);

  changeTab({required tabNumber}) {
    emit(tabNumber);
  }
}
