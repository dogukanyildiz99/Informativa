// ignore_for_file: prefer_const_constructors, unused_import, import_of_legacy_library_into_null_safe

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:informativa/pages/old_records.dart';
// import 'package:splashscreen/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:informativa/pages/machine_page.dart';
import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.white,
      ),
      title: 'Informativa',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr'),
      ],
      locale: Locale('tr'),
      builder: EasyLoading.init(),
      home: MachinePage(),
      // home: MachinePage(),
      // home: SplashScreen(
      //   seconds: 3,
      //   navigateAfterSeconds: const MachinePage(),
      //   image: Image.asset(
      //     'informativa2.png',
      //   ),
      //   photoSize: 200.0,
      //   useLoader: false,
      //   backgroundColor: const Color.fromRGBO(84, 114, 251, 1),
      // ));
    );
  }
}
