import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storepedia/cubit/password_field_cubit/password_textfield_cubit.dart';
import 'package:storepedia/constants/number_constants.dart' as numberConstants;

class PasswordInputField extends StatelessWidget {
  const PasswordInputField({super.key, this.labelText = 'Password'});
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordTextfieldCubit, PasswordTextfieldState>(
      builder: (context, state) {
        return ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: numberConstants.maxTextFieldWidth),
          child: TextField(
            keyboardType: TextInputType.text,
            obscureText: true,
            enabled: true,
            textAlign: TextAlign.justify,
            textInputAction: TextInputAction.done,
            autocorrect: true,
            enableSuggestions: true,
            autofillHints: const [],
            onChanged: (val) {
              final cubitHandle = context.read<PasswordTextfieldCubit>();
              cubitHandle.updateText(val);
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              //enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.zero),
              errorText: state is PasswordTextfieldError ? state.message : null,
              hintText: '*******',
              labelText: labelText,
              prefixIcon: const Icon(
                Icons.lock,
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
