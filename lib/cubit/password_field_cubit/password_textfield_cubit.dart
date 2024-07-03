import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:storepedia/repository/validator.dart';

part 'password_textfield_state.dart';

class PasswordTextfieldCubit extends Cubit<PasswordTextfieldState> {
  PasswordTextfieldCubit() : super(PasswordTextfieldInitial());
  final Validator validator = Validator();

  updateText(String password, bool doValidation) {
    String? result = validator.validatePassword(password);
    if (!doValidation) {
      emit(PasswordTextfieldOk(password: password));
    } else {
      if (result != null) {
        emit(PasswordTextfieldError(message: result));
      } else {
        emit(PasswordTextfieldOk(password: password));
      }
    }
  }
}
