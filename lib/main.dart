import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/pallet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: Pallete.darkModeAppTheme,
      home: const SizedBox(),
    );
  }
}
