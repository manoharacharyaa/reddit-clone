import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_flutter/core/constants/constants.dart';
import 'package:reddit_flutter/features/auth/controller/auth_controller.dart';
import 'package:reddit_flutter/theme/pallet.dart';

class SignInButton extends ConsumerWidget {
  final bool isFromLogin;
  const SignInButton({super.key, this.isFromLogin = true});

  void signinWithGoogle(BuildContext context, WidgetRef ref) {
    ref
        .read(authControllerProvider.notifier)
        .signInWithGoogle(context, isFromLogin);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
        onPressed: () => signinWithGoogle(context, ref),
        label: const Text(
          'Continue with Google',
          style: TextStyle(color: Colors.white),
        ),
        icon: Image.asset(Constants.googlePath, width: 35),
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Pallete.greyColor),
          minimumSize: WidgetStatePropertyAll(Size(double.infinity, 50)),
          shape: WidgetStatePropertyAll(
            RoundedSuperellipseBorder(
              borderRadius: BorderRadiusGeometry.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
