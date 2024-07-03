import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:storepedia/repository/validator.dart';

part 'email_textfield_state.dart';

class EmailTextfieldCubit extends Cubit<EmailTextfieldState> {
  final Validator validator = Validator();
  EmailTextfieldCubit() : super(EmailTextfieldInitial());

  updateEmail({required String email, required bool doValidation}) {
    final String? result = validator.validateEmail(email);

    if (!doValidation) {
      emit(EmailTextfieldOk(email: email));
    } else {
      if (result != null) {
        emit(EmailTextfieldError(message: result));
      } else {
        emit(EmailTextfieldOk(email: email));
      }
    }
  }
}
