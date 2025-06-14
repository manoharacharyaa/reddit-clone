import 'package:flutter/material.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/theme/pallet.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
        onPressed: () {},
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
