import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storepedia/cubit/repeat_password_textfield_cubit/cubit/repeatpasswordtextfield_cubit.dart';
import 'package:storepedia/constants/number_constants.dart' as number_constants;

class RepeatPasswordInputField extends StatelessWidget {
  const RepeatPasswordInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RepeatPasswordTextfieldCubit,
        RepeatPasswordTextfieldState>(
      builder: (context, state) {
        return ConstrainedBox(
          constraints: const BoxConstraints(
              maxWidth: number_constants.maxTextFieldWidth),
          child: TextField(
            keyboardType: TextInputType.text,
            obscureText: true,
            enabled: true,
            textAlign: TextAlign.justify,
            textInputAction: TextInputAction.done,
            onChanged: (val) {
              final cubitHandle = context.read<RepeatPasswordTextfieldCubit>();
              cubitHandle.updateText(password: val);
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              //enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.zero),
              errorText:
                  state is RepeatPasswordTextfieldError ? state.message : null,
              hintText: '*******',
              labelText: 'Repeat Password',
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
