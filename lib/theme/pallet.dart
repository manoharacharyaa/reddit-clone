import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((
  ref,
) {
  return ThemeNotifier();
});

class Pallete {
  // Colors
  static const blackColor = Color.fromRGBO(1, 1, 1, 1); // primary color
  static const greyColor = Color.fromRGBO(26, 39, 45, 1); // secondary color
  static const drawerColor = Color.fromRGBO(18, 18, 18, 1);
  static const whiteColor = Colors.white;
  static var redColor = Colors.red.shade500;
  static var blueColor = Colors.blue.shade300;

  static var darkModeAppTheme = ThemeData.dark().copyWith(
    colorScheme: ColorScheme.dark(primary: Colors.blue),
    scaffoldBackgroundColor: blackColor,
    cardColor: greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: blackColor,
      iconTheme: IconThemeData(
        color: whiteColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: drawerColor,
    ),
    primaryColor: redColor,
    canvasColor: drawerColor,
  );

  static var lightModeAppTheme = ThemeData.light().copyWith(
    colorScheme: ColorScheme.dark(primary: Colors.blue),
    scaffoldBackgroundColor: whiteColor,
    cardColor: greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: whiteColor,
      elevation: 0,
      iconTheme: IconThemeData(
        color: blackColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: whiteColor,
    ),
    primaryColor: redColor,
    canvasColor: whiteColor,
  );

  // Themes
  // static var darkModeAppTheme = ThemeData.dark().copyWith(
  //   colorScheme: ColorScheme.dark(primary: Colors.blueAccent),
  //   scaffoldBackgroundColor: blackColor,
  //   cardColor: blackColor,
  //   appBarTheme: AppBarTheme(
  //     titleTextStyle: GoogleFonts.poppins(color: Colors.white, fontSize: 20),
  //     backgroundColor: blackColor,
  //     iconTheme: IconThemeData(color: whiteColor),
  //   ),
  //   drawerTheme: const DrawerThemeData(backgroundColor: drawerColor),
  //   primaryColor: redColor,
  // );

  // static var lightModeAppTheme = ThemeData.light().copyWith(
  //   colorScheme: ColorScheme.dark(primary: Colors.blueAccent),
  //   scaffoldBackgroundColor: whiteColor,
  //   cardColor: greyColor,
  //   appBarTheme: AppBarTheme(
  //     titleTextStyle: GoogleFonts.poppins(color: Colors.black, fontSize: 20),
  //     backgroundColor: whiteColor,
  //     elevation: 0,
  //     iconTheme: IconThemeData(color: blackColor),
  //   ),
  //   drawerTheme: const DrawerThemeData(backgroundColor: whiteColor),
  //   primaryColor: redColor,
  // );
}

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeMode _mode;

  ThemeNotifier({
    ThemeMode mode = ThemeMode.dark,
  }) : _mode = mode,
       super(Pallete.darkModeAppTheme) {
    getTheme();
  }

  ThemeMode get mode => _mode;

  void getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme');

    if (theme == 'light') {
      _mode = ThemeMode.light;
      state = Pallete.lightModeAppTheme;
    } else {
      _mode = ThemeMode.dark;
      state = Pallete.darkModeAppTheme;
    }
  }

  void toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_mode == ThemeMode.dark) {
      _mode = ThemeMode.light;
      state = Pallete.lightModeAppTheme;
      prefs.setString('theme', 'light');
    } else {
      _mode = ThemeMode.dark;
      state = Pallete.darkModeAppTheme;
      prefs.setString('theme', 'dark');
    }
  }
}
