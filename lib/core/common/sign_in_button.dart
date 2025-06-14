import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/theme/pallet.dart';

class SignInButton extends ConsumerWidget {
  const SignInButton({super.key});

  void signinWithGoogle(WidgetRef ref) {
    ref.read(authControllerProvider).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
        onPressed: () => signinWithGoogle(ref),
        label: const Text(
          'Continue with Google',
          style: TextStyle(color: Colors.white),
        ),
        icon: Image.asset(
          Constants.googlePath,
          width: 35,
        ),
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Pallete.greyColor),
          minimumSize: WidgetStatePropertyAll(Size(double.infinity, 50)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
