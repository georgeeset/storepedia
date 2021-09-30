import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'signinsignup_state.dart';

class SigninsignupCubit extends Cubit<SigninsignupState> {
  SigninsignupCubit() : super(SigninState());
}
