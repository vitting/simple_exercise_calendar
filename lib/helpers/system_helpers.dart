import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl_standalone.dart';

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
}
