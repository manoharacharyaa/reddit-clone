import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_flutter/core/common/loader.dart';
import 'package:reddit_flutter/core/common/sign_in_button.dart';
import 'package:reddit_flutter/core/constants/constants.dart';
import 'package:reddit_flutter/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Image.asset(Constants.logoPath, height: 40),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Skip', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Dive into anything', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                Padding(padding: const EdgeInsets.all(8.0), child: Image.asset(Constants.loginEmotePath, height: 400)),
                const SizedBox(height: 20),
                const SignInButton(),
              ],
            ),
    );
  }
}
