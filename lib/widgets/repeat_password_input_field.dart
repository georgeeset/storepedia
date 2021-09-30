import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_pedia/cubit/repeat_password_textfield_cubit/cubit/repeatpasswordtextfield_cubit.dart';

class RepeatPasswordInputField extends StatelessWidget {
  const RepeatPasswordInputField({ Key? key }) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RepeatPasswordTextfieldCubit, RepeatPasswordTextfieldState>(
      builder: (context, state) {
        return TextField(
          keyboardType: TextInputType.text,
          obscureText: true,
          enabled: true,
          textAlign: TextAlign.justify,
          textInputAction: TextInputAction.done,
          onChanged: (val) {
            final cubitHandle = context.read<RepeatPasswordTextfieldCubit>();
            cubitHandle.updateText(password:val);
          },
          // onSubmitted: (val) async {
          //   final cubitHandle = context.read<PasswordTextfieldCubit>();
          //   if (cubitHandle.state is PasswordTextfieldOk) {
          //     // call the correct function and padd val
          //     context.read<AuthenticationCubit>().verifyPhoneNumber(val);
          //   }
          // },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            //enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.zero),
            errorText: state is RepeatPasswordTextfieldError ? state.message : null,
            hintText: '*******',
            labelText: 'Repeat Password',
            prefixIcon: Icon(
              Icons.lock,
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