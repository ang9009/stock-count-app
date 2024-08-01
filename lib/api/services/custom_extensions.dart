import 'dart:io';
import 'dart:ui' as dartui;

import 'package:easy_localization/easy_localization.dart' as easy_localization;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stock_count/api/services/common.dart';
import 'package:stock_count/api/services/web_service.dart';
//import 'package:intl/intl.dart';

extension WidgetEx on Widget {
  Widget onPress(
    Function() onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: this,
    );
  }
}

extension NumEx on num {
  String format(String pattern, {String? locale}) {
    return easy_localization.NumberFormat(pattern, locale).format(this);
  }
}

extension StringEx on String {
  Size textSize(
    TextStyle style, {
    double? width,
    int? maxLines,
    TextAlign textAlign = TextAlign.start,
    StrutStyle? strutStyle,
    dartui.TextDirection? textDirection = dartui.TextDirection.ltr,
    double textScaleFactor = 1.0,
  }) {
    /*
    const constraints = BoxConstraints(
      maxWidth: double.infinity, // maxwidth calculated
      minHeight: 0.0,
      minWidth: 0.0,
    );
    RenderParagraph renderParagraph = RenderParagraph(
      TextSpan(
        text: this,
        style: style,
      ),
      textDirection: textDirection!,
      maxLines: 1,
    );
    renderParagraph.layout(constraints);
    return Size(
        renderParagraph.getMinIntrinsicWidth(double.infinity).ceilToDouble(),
        renderParagraph.getMinIntrinsicHeight(double.infinity).ceilToDouble());
    */
    if (width != null) width = (width < 0 ? null : width);
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: this, style: style),
      textDirection: textDirection, //dartui.TextDecoration.ltr,
      textScaleFactor: textScaleFactor,
      textAlign: textAlign,
      strutStyle: strutStyle,
      maxLines: (maxLines ?? 1),
    )..layout(minWidth: (width ?? 0), maxWidth: (width ?? double.infinity));
    Size txtSize = textPainter.size;

    return txtSize;
  }

  DateTime toDateTime(
      {String? formatStr,
      String? locale,
      bool strict = true,
      DateTime? defaultDate}) {
    DateFormat df = DateFormat(formatStr, locale);
    late DateTime dt;
    if (strict) {
      dt = df.parseStrict(this);
    } else {
      dt = df.parse(this);
    }
    if (defaultDate != null) {
      dt = DateTime(defaultDate.year, defaultDate.month, defaultDate.day,
          dt.hour, dt.minute, dt.second, dt.millisecond, dt.microsecond);
    }

    return dt;
  }

  DateTime toDatetimeFromJson({String? format}) {
    if (format != null) {
      return toDateTime(formatStr: format, strict: false);
    } else {
      return DateTime.parse(this);
    }
  }

  bool isNumer({bool isDecimal = true}) {
    /*if(this == null) {
    return false;
    }*/
    if (!isDecimal) {
      return int.tryParse(this) != null;
    }
    return double.tryParse(this) != null;
  }

  bool parseBool() {
    return trim().toLowerCase() == 'true';
  }

  String tr({Map<String, String>? nameArg}) {
    return easy_localization.tr(toString(), namedArgs: nameArg);
  }
}

extension DateTimeEx on DateTime {
  String toDateTimeString({String? format}) {
    format ??= Common.datetimeFormat;
    return DateFormat(format).format(this);
  }

  String toDateString({String? format, String? locale}) {
    format ??= Common.dateFormat;
    return DateFormat(format, locale).format(this);
  }

  String toTimeString({String? format, String? locale}) {
    format ??= Common.timeFormat;
    return DateFormat(format, locale).format(this);
  }

  String toJson({String? format, bool toMSFormat = true}) {
    if (toMSFormat) return WebService.datetimeToMSJson(this);
    if (format != null) {
      return toDateTimeString(format: format);
    } else {
      return toIso8601String();
    }
  }
}

extension FileEx on File {
  String fileName() {
    return path.split(Platform.pathSeparator).last;
  }
}
