// ignore_for_file: prefer_const_constructors, unused_import, import_of_legacy_library_into_null_safe
// import 'package:splashscreen/splashscreen.dart';
import 'dart:ui';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:informativa/pages/old_records.dart';
import 'package:flutter/material.dart';
import 'package:informativa/pages/machine_page.dart';
import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.kanitTextTheme(),
          scrollbarTheme: ScrollbarThemeData(
              thumbVisibility: MaterialStateProperty.all<bool>(true)),
          backgroundColor: Colors.white,
        ),
        title: 'Informativa',
        builder: EasyLoading.init(),
        home: MachinePage());
  }
}


// SplashScreen(
//         seconds: 3,
//         navigateAfterSeconds: const MachinePage(),
//         image: Image.asset('assets/image/informativa.png'),
//         photoSize: 150.0,
//         useLoader: false,
//         backgroundColor: const Color.fromRGBO(84, 114, 251, 1),
//         // styleTextUnderTheLoader: new TextStyle(),
//         // loaderColor: Colors.white)
//       ),