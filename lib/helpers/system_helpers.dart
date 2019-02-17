import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl_standalone.dart';
import 'package:vibration/vibration.dart';

class SystemHelpers {
  static void hideKeyboardWithNoFocus(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static Future<dynamic> hideKeyboardWithFocus() {
    return SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  static Future<Null> showNavigationButtons(bool show) {
    if (show) {
      return SystemChrome.setEnabledSystemUIOverlays(
          [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    } else {
      return SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    }
  }

  static Future<String> getSystemLanguageCode() async {
    String value = "en";
    String systemLocale = await findSystemLocale();
    if (systemLocale != null) {
      List<String> locale = systemLocale.split("_");
      if (locale.length != 0) {
        value = locale[0];
      }
    }

    return value;
  }

  static Future<String> getSystemContryCode() async {
    String value = "US";
    String systemLocale = await findSystemLocale();
    if (systemLocale != null) {
      List<String> locale = systemLocale.split("_");
      if (locale.length != 0) {
        value = locale[1];
      }
    }

    return value;
  }

  static String generateUuid() {
    Uuid _uuid = new Uuid();
    return _uuid.v4().toString();
  }

  static Future<void> vibrate25() async {
    if (await Vibration.hasVibrator()) {
      await Vibration.vibrate(duration: 25);
    }
  }

  static Future<void> vibrate100() async {
    if (await Vibration.hasVibrator()) {
      await Vibration.vibrate(duration: 100);
    }
  }

  static void setScreenOrientationPortrait() async {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  static void setScreenOrientationLandscape() async {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  static void setScreenOrientationDefault() async {
    await SystemChrome.setPreferredOrientations([]);
  }
}
