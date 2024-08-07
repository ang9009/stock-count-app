import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stock_count/api/config.dart';
import 'package:stock_count/api/services/custom_extensions.dart';

class Common {
  static String serviceLoginIDKey = "serviceLoginIDKey";
  static String serviceLoginPosIDKey = "serviceLoginPosIDKey";
  static String appInfoKey = "appInfoKey";
  static String apiUrlKey = "apiUrlKey";

  static String serviceLoginID = "";
  static String serviceLoginPosID = "";
  static Map<String, dynamic>? appInfo;

  static String dateSeperator = "/";
  static String timeSeperator = ":";
  static String dateFormat = "yyyy${dateSeperator}MM${dateSeperator}dd";
  static String timeFormat = "HH${timeSeperator}mm${timeSeperator}ss";
  static String datetimeFormat = "$dateFormat $timeFormat";
  static DateTime defaultDate = DateTime(2000, 01, 01);

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static BuildContext? get context {
    BuildContext? context = navigatorKey.currentState?.context;
    return context;
  }

  static const storageService = FlutterSecureStorage();

  static void clearCookies() async {
    appInfo = null;
    Config.apiUrl = "";

    await storageService.write(key: appInfoKey, value: null);
    await storageService.write(key: apiUrlKey, value: null);
  }

  static Future loadInfoFromStorage() async {
    var apiUrl = await storageService.read(key: apiUrlKey);
    if (apiUrl != null) {
      if (apiUrl.isNotEmpty) Config.apiUrl = apiUrl;
    }
    serviceLoginID = await storageService.read(key: serviceLoginIDKey) ?? "";
    serviceLoginPosID =
        await storageService.read(key: serviceLoginPosIDKey) ?? "";

    String? ai = await storageService.read(key: appInfoKey);
    if (ai != null) {
      if (ai.isNotEmpty) {
        appInfo = jsonDecode(ai);
      }
    }
  }

  static Future<void> init() async {
    try {
      await loadInfoFromStorage();
      var dir = await getApplicationDocumentsDirectory();
      Config.localFilePath = dir.path;
    } catch (ex) {
      debugPrint("Get setting fail,Error: $ex");
    }
    return;
  }

  static bool? _isDebug;
  static bool get isDebug {
    if (_isDebug == null) {
      _isDebug = false;
      assert(() {
        _isDebug = true;
        return true;
      }());
    }
    return _isDebug!;
  }

  static Locale? _locale;
  static Locale? _deviceLocale;
  static Locale get currentLocale {
    if (_locale == null) {
      _deviceLocale ??= Platform.localeName.toLocale();
      return _deviceLocale!;
    }
    return _locale!;
  }

  static set currentLocale(Locale? locale) {
    if (_locale != locale) {
      _locale = locale;
      if (context != null) {
        if ((_locale != null) &&
            (EasyLocalization.of(context!)?.currentLocale != _locale)) {
          EasyLocalization.of(context!)?.setLocale(_locale!);
        }
      }
    }
  }

  static Size? _screenSize;
  static Size screenSize() {
    if (_screenSize != null) return _screenSize!;
    BuildContext? context = navigatorKey.currentContext;
    if (context != null) {
      _screenSize = Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height);
      /*
      //To get height just of SafeArea (for iOS 11 and above):
      var padding = MediaQuery.of(context).padding;
      double newheight =  MediaQuery.of(context).size.height - padding.top - padding.bottom;*/
      return _screenSize!;
    } else {
      return const Size(double.infinity, double.infinity);
    }
  }

  static dynamic getFromMap(
      Map<String, dynamic>? map, String key, dynamic defaultValue) {
    if (map == null) return defaultValue;
    if (!map.containsKey(key)) return defaultValue;

    return map[key];
  }

  static Future<DateTime?> pickDate(BuildContext context, DateTime initDate,
      {DateTime? firstDate, DateTime? lastDate}) async {
    firstDate ??= DateTime(1900);
    lastDate ??= DateTime(9999);

    return showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDatePickerMode: DatePickerMode.day,
    );
  }

  static MaskTextInputFormatter getMaskFromDateTimeFormat(String formatString) {
    return MaskTextInputFormatter(
        mask: formatString.characters.map((e) {
      return (e == "y" ||
              e == "M" ||
              e == "d" ||
              e == "H" ||
              e == "m" ||
              e == "s")
          ? "#"
          : e;
    }).join());
  }
}

class NumberTextInputFormatter implements TextInputFormatter {
  final int decimalRange;
  final int? maxLength;

  NumberTextInputFormatter({this.maxLength, this.decimalRange = 0});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    String value = newValue.text;
    if ((maxLength ?? 0) > 0) {
      if (value.length > maxLength!) {
        return oldValue;
      }
    }
    if (!value.isNumer(isDecimal: (maxLength ?? 0) > 0)) return oldValue;

    if (decimalRange > 0) {
      TextSelection newSelection = newValue.selection;
      String truncated = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}

enum ImageType { file, asset, network, memory }

enum ButtonType { text, outline, elevated }

enum RelativePosition { top, bottom, left, right, foreground }
