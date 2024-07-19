import 'package:flutter/material.dart';
import 'package:storepedia/bloc/authentication_bloc/bloc/authentication_bloc.dart';
import 'package:storepedia/bloc/signin_option_bloc/bloc/signinoption_bloc.dart';
import 'package:storepedia/cubit/email_field_cubit/email_textfield_cubit.dart';
import 'package:storepedia/cubit/password_field_cubit/password_textfield_cubit.dart';
import 'package:storepedia/cubit/repeat_password_textfield_cubit/cubit/repeatpasswordtextfield_cubit.dart';
import 'package:storepedia/widgets/email_input_field.dart';
import 'package:storepedia/widgets/loading_indicator.dart';
import 'package:storepedia/widgets/password_input_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storepedia/widgets/repeat_password_input_field.dart';
import 'package:storepedia/constants/number_constants.dart' as number_constants;

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});
  static const String routeName = '/signin';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white54,
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: BlocBuilder<SigninoptionBloc, SigninoptionState>(
            builder: (context, state) {
              if (state is RegisterState) {
                return const RegisterWidget();
              } else {
                if (state is SigninState) {
                  return const SigninWidget();
                } else {
                  return BlocListener<AuthenticationBloc, AuthenticationState>(
                    listener: (context, state) {
                      if (state is AuthEmailSentState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.purpleAccent,
                            duration: Duration(
                                seconds: number_constants.errorSnackBarDelay),
                            content: Text('Reset Email Sent !'),
                          ),
                        );

                        context.read<SigninoptionBloc>().add(SigninEvent());
                      }
                    },
                    child: const ForgotPasswordWidget(),
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordWidget extends StatelessWidget {
  const ForgotPasswordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EmailTextfieldCubit>(
          create: (context) => EmailTextfieldCubit(),
        ),
      ],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const EmailInputField(
            doValidation: false,
          ),
          Container(
            height: 10.0,
          ),
          Container(
            height: 20.0,
          ),
          const ButtonSwitcher(
            commandButton: ForgotPasswordActionButtons(),
          ),
        ],
      ),
    );
  }
}

class ForgotPasswordActionButtons extends StatelessWidget {
  const ForgotPasswordActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          const BoxConstraints(maxWidth: number_constants.maxTextFieldWidth),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          OutlinedButton(
            onPressed: () {
              context.read<SigninoptionBloc>().add(SigninEvent());
            },
            child: const Text('Signin'),
          ),
          ElevatedButton(
            onPressed: () {
              final emailCubit = context.read<EmailTextfieldCubit>().state;

              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }

              if (emailCubit is EmailTextfieldOk) {
                context
                    .read<AuthenticationBloc>()
                    .add(ResetPasswordEvent(email: emailCubit.email));
              }
            },
            child: const Text('Reset Password'),
          ),
        ],
      ),
    );
  }
}

class RegisterWidget extends StatelessWidget {
  const RegisterWidget({
    super.key,
  });

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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const EmailInputField(),
          Container(height: 15.0),
          const PasswordInputField(),
          Container(
            height: 15.0,
          ),
          const RepeatPasswordInputField(),
          Container(
            height: 15.0,
          ),

          const ButtonSwitcher(commandButton: SignupSigninButton())
          //SignupSigninButton()
        ],
      ),
    );
  }
}

class SignupSigninButton extends StatelessWidget {
  const SignupSigninButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        OutlinedButton(
          onPressed: () {
            context.read<SigninoptionBloc>().add(SigninEvent());
          },
          child: const Text('Signin with email'),
        ),
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              var repeatPwd =
                  context.read<RepeatPasswordTextfieldCubit>().state;
              var password = context.read<PasswordTextfieldCubit>().state;
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
            child: const Text('Register'),
          ),
        ),
      ],
    );
  }
}

class SigninWidget extends StatelessWidget {
  const SigninWidget({
    super.key,
  });

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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const EmailInputField(
            doValidation: false,
          ),
          Container(
            height: 10.0,
          ),
          const PasswordInputField(
            doValidation: false,
          ),
          Container(
            height: 20.0,
          ),
          const ButtonSwitcher(
            commandButton: SigninSignupButton(),
          ),
        ],
      ),
    );
  }
}

class ButtonSwitcher extends StatelessWidget {
  const ButtonSwitcher({
    required this.commandButton,
    super.key,
  });
  final Widget commandButton;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return state is AuthenticatingState
            ? const LoadingIndicator()
            : commandButton; //SigninSignupButton();
      },
    );
  }
}

class SigninSignupButton extends StatelessWidget {
  const SigninSignupButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          const BoxConstraints(maxWidth: number_constants.maxTextFieldWidth),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton(
            onPressed: () {
              context.read<SigninoptionBloc>().add(ForgotPasswordEvent());
            },
            child: const Text('Forgot Password'),
          ),
          OutlinedButton(
            onPressed: () {
              context.read<SigninoptionBloc>().add(RegisterOptionEvent());
            },
            child: const Text('Register'),
          ),
          ElevatedButton(
            onPressed: () {
              final emailCubit = context.read<EmailTextfieldCubit>().state;
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
              }
            },
            child: const Text('Sign in'),
          ),
        ],
      ),
    );
  }
}
