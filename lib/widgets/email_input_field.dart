import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storepedia/cubit/email_field_cubit/email_textfield_cubit.dart';

class EmailInputField extends StatelessWidget {
  const EmailInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmailTextfieldCubit, EmailTextfieldState>(
      builder: (context, state) {
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            enabled: true,
            textInputAction: TextInputAction.done,
            autocorrect: true,
            enableSuggestions: true,
            autofillHints: const [],
            onChanged: (val) {
              final cubitHandle = context.read<EmailTextfieldCubit>();
              cubitHandle.updateEmail(email: val);
            },
            // onSubmitted: (val) async {
            //   final cubitHandle = context.read<PhoneTextfieldCubit>();
            //   if (cubitHandle.state is PhoneTextfieldOk) {
            //     // call the correct function and padd val
            //     context.read<AuthenticationCubit>().verifyPhoneNumber(val);
            //   }
            // },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              //enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.zero),
              errorText: state is EmailTextfieldError ? state.message : null,
              hintText: 'youremail@domain.com',
              labelText: 'Email',
              // isDense: true,
              prefixIcon: const Icon(
                Icons.email,
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
