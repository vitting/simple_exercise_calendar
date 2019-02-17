import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:simple_exercise_calendar/helpers/mainInherited_widget.dart';
import 'package:simple_exercise_calendar/helpers/system_helpers.dart';
import 'package:simple_exercise_calendar/helpers/theme_config.dart';
import 'package:simple_exercise_calendar/ui/home/home.dart';

void main() async {
  String languageCode = await SystemHelpers.getSystemLanguageCode();

  if (languageCode != "da") {
    languageCode = "en";
  }

  SystemHelpers.setScreenOrientationPortrait();

  return runApp(MainInherited(
      languageCode: languageCode,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          FlutterI18nDelegate(false, "en.json"),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          scaffoldBackgroundColor: ThemeConfig.scaffoldBackgroundColor,
        ),
        home: Home(),
      )));
}
