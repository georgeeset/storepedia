import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storepedia/bloc/authentication_bloc/bloc/authentication_bloc.dart';
import 'package:storepedia/cubit/user_manager_cubit/usermanager_cubit.dart';
import 'package:storepedia/widgets/page_layout.dart';
import 'package:storepedia/widgets/warining_dialog.dart';

class EmailVerification extends StatelessWidget {
  const EmailVerification({
    super.key,
    required this.email,
  });
  final String email;

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: Text(
        'Email Verification',
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: Colors.white),
        textAlign: TextAlign.center,
        softWrap: true,
      ),
      hasBackButton: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 210,
              width: 200,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.0)),
              child: const Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.person,
                      size: 200,
                    ),
                  ),
                  AnimatedHeight(),
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Text('Your email is not yet verified !'),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
                onPressed: () async {
                  context.read<UserManagerCubit>().verifyEmail();
                  var dialogResult = await WarningDialog.boolActionsDialog(
                    context: context,
                    titleText: 'Email Verification',
                    bodyText:
                        "An Email has been sent to: $email \n\nCheck your email and click on the link to verify your account",
                    goodOption: 'Okay', //false
                  );
                  if (dialogResult != null) {
                    if (!context.mounted) return;
                    context.read<AuthenticationBloc>().add(SignOutEvent());
                  }
                },
                child: const Text('SendVerification Message')),
          ],
        ),
      ),
    );
  }
}

class AnimatedHeight extends StatefulWidget {
  const AnimatedHeight({super.key});

  @override
  _AnimatedHeightState createState() => _AnimatedHeightState();
}

class _AnimatedHeightState extends State<AnimatedHeight>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0, end: 200).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Center(
          child: Container(
            width: 200,
            height: _animation.value,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color.fromRGBO(255, 186, 182, 120),
                Colors.black12,
                Color.fromRGBO(255, 186, 182, 120)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )
                // border: Border.symmetric(
                //   horizontal: BorderSide(color: Colors.black, width: 3),
                // ),
                ),
          ),
        );
      },
    );
  }
}
