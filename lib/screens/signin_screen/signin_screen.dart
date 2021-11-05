import 'package:flutter/material.dart';
import 'package:store_pedia/bloc/authentication_bloc/bloc/authentication_bloc.dart';
import 'package:store_pedia/bloc/signin_option_bloc/bloc/signinoption_bloc.dart';
import 'package:store_pedia/cubit/connectivity_cubit/cubit/connectivity_cubit.dart';
import 'package:store_pedia/cubit/email_field_cubit/email_textfield_cubit.dart';
import 'package:store_pedia/cubit/password_field_cubit/password_textfield_cubit.dart';
import 'package:store_pedia/cubit/repeat_password_textfield_cubit/cubit/repeatpasswordtextfield_cubit.dart';
import 'package:store_pedia/cubit/signin_signup_cubit/cubit/signinsignup_cubit.dart';
import 'package:store_pedia/widgets/email_input_field.dart';
import 'package:store_pedia/widgets/loading_indicator.dart';
import 'package:store_pedia/widgets/password_input_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_pedia/widgets/repeat_password_input_field.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white54,
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Container(
            child: BlocBuilder<SigninoptionBloc, SigninoptionState>(
              builder: (context, state) {
                if (state is RegisterState) {
                  return RegisterWidget();
                } else {
                  return SigninWidget();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterWidget extends StatelessWidget {
  const RegisterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EmailTextfieldCubit>(
          create: (context) => EmailTextfieldCubit(),
        ),
        BlocProvider<PasswordTextfieldCubit>(
          create: (context) => PasswordTextfieldCubit(),
        ),
        BlocProvider<RepeatPasswordTextfieldCubit>(
          create: (context) => RepeatPasswordTextfieldCubit(
              firstPassword: context.read<PasswordTextfieldCubit>()),
        ),
      ],
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmailInputField(),
            Container(height: 15.0),
            PasswordInputField(),
            Container(
              height: 15.0,
            ),
            RepeatPasswordInputField(),
            Container(
              height: 15.0,
            ),

            ButtonSwitcher(commandButton: SignupSigninButton())
            //SignupSigninButton()
          ],
        ),
      ),
    );
  }
}

class SignupSigninButton extends StatelessWidget {
  const SignupSigninButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        OutlinedButton(
          onPressed: () {
            context.read<SigninoptionBloc>().add(SigninEvent());
          },
          child: Text('Signin with email'),
        ),
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              var repeatPwd =
                  context.read<RepeatPasswordTextfieldCubit>().state;
              var password =
                  context.read<PasswordTextfieldCubit>().state;
              var email = context.read<EmailTextfieldCubit>().state;
              if (repeatPwd is RepeatPasswordTextfieldOk &&
                  password is PasswordTextfieldOk &&
                  email is EmailTextfieldOk) {
                context.read<AuthenticationBloc>().add(RegisterEvent(
                    email: email.email,
                    password1: password.password,
                    password2: repeatPwd.password));
              }
            },
            child: Text('Register'),
          ),
        ),
      ],
    );
  }
}

class SigninWidget extends StatelessWidget {
  const SigninWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EmailTextfieldCubit>(
          create: (context) => EmailTextfieldCubit(),
        ),
        BlocProvider<PasswordTextfieldCubit>(
          create: (context) => PasswordTextfieldCubit(),
        ),
      ],
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            EmailInputField(),
            Container(
              height: 10.0,
            ),
            PasswordInputField(),
            Container(
              height: 20.0,
            ),
            ButtonSwitcher(commandButton: SigninSignupButton(),),
          ],
        ),
      ),
    );
  }
}

class ButtonSwitcher extends StatelessWidget {
  const ButtonSwitcher({
    required this.commandButton,
    Key? key,
  }) : super(key: key);
  final Widget commandButton;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return state is AuthenticatingState
            ? LoadingIndicator()
            : commandButton;//SigninSignupButton();
      },
    );
  }
}

class SigninSignupButton extends StatelessWidget {
  const SigninSignupButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // TextButton(
            //   onPressed: () {
            //     context.read<SigninoptionBloc>().add(ForgotPasswordEvent());
            //   },
            //   child: Text('Forgot Password'),
            // ),
            OutlinedButton(
              onPressed: () {
                context.read<SigninoptionBloc>().add(RegisterOptionEvent());
              },
              child: Text('Register'),
            ),
            ElevatedButton(
              onPressed: state is ConnectivityOffline
                  ? null
                  : () {
                      final emailCubit =
                          context.read<EmailTextfieldCubit>().state;
                      final passwordCubit =
                          context.read<PasswordTextfieldCubit>().state;
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }

                      if (emailCubit is EmailTextfieldOk &&
                          passwordCubit is PasswordTextfieldOk) {
                        context.read<AuthenticationBloc>().add(
                              EmailPasswordSigninEvent(
                                email: emailCubit.email,
                                password: passwordCubit.password,
                              ),
                            );
                      } else {
                        print('signin Failed');
                      }
                    },
              child: Text('Sign in'),
            ),
          ],
        );
      },
    );
  }
}
