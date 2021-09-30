import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_pedia/cubit/email_field_cubit/email_textfield_cubit.dart';

class EmailInputField extends StatelessWidget {
  const EmailInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmailTextfieldCubit, EmailTextfieldState>(
      builder: (context, state) {
        return TextField(
          keyboardType: TextInputType.emailAddress,
          enabled: true,
          textInputAction: TextInputAction.done,
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
            prefixIcon: Icon(
              Icons.email,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
          ),
        );
      },
    );
  }
}
