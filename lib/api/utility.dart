import 'dart:convert';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stock_count/api/common.dart';
import 'package:stock_count/api/config.dart';
import 'package:stock_count/api/services/api_service.dart';
import 'package:stock_count/api/services/web_service.dart';

class FormatMonth {
  final DateTime firstDate;
  final String firstDateString;
  final DateTime lastDate;
  final String lastDateString;
  final String formatDate;
  final int thisMonth;
  final int thisYear;
  final int lastDay;
  final int firstDay;

  FormatMonth(
    this.firstDate,
    this.lastDate,
    this.firstDateString,
    this.lastDateString,
    this.formatDate,
    this.thisMonth,
    this.thisYear,
    this.firstDay,
    this.lastDay,
  );
}

class DiagonalLinePainter extends CustomPainter {
  final Color color;
  final int angle;
  final double strokeWidth;
  final PaintingStyle paintingStyle;

  DiagonalLinePainter({
    this.color = Colors.black,
    this.angle = 15,
    this.strokeWidth = 2.0,
    this.paintingStyle = PaintingStyle.stroke,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    final path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width, size.height / 2);

    // Convert degrees to radians
    final dx = size.height / 2 * tan(angle * (3.141592653589793238 / 180));
    path.lineTo(size.width - dx, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(DiagonalLinePainter oldDelegate) => false;
}

enum SpecialPriceType { sptItem, sptPlu }

class Utility {
  static String loginKey = "ISALOGININFO";

  static String userId = "";
  static String userName = "";
  static String shopCode = "";
  static String machineId = "";
  static int userLevel = 0;

  static double calcPadding = 0;
  static double calcButtonWidth = 0;
  static Color lightGrey = const Color(0xFFD9D9D9);

  static String serviceImagePath = "Images/item";
  static String localImagesPath = "${Config.localFilePath}/items";

  static void clear() async {
    userId = "";
    userName = "";
    shopCode = "";
    userLevel = 0;

    await Common.storageService.write(key: loginKey, value: null);
  }

  static Future<bool> init() async {
    double screenWidth = Common.screenSize().width;
    calcPadding = screenWidth / 10;
    if (calcPadding < 20) calcPadding = 20;
    if (calcPadding > 30) calcPadding = 30;
    calcButtonWidth = screenWidth - calcPadding * 2;

    String loginInfo = await Common.storageService.read(key: loginKey) ?? "";

    if (loginInfo.isEmpty) return false;

    dynamic loginData = jsonDecode(loginInfo);
    if (loginData is! Map) return false;

    userId = loginData["userid"] ?? "";
    userName = loginData["username"] ?? "";
    shopCode = loginData["shopcode"] ?? "";
    userLevel = loginData["userlevel"] ?? 0;

    if (userId.isEmpty) return false;
    if (shopCode.isEmpty) return false;

    return true;
  }

  static Widget noImage = const FittedBox(child: Text("No Image"));

  static Widget noRecords = Center(
    child: Text("you_do_not_have_any_records_t".tr()),
  );

  static Widget sizedBox(double height) {
    return SizedBox(height: height);
  }

  static Widget widthBox(double width) {
    return SizedBox(width: width);
  }

  static Widget title(
    String text, {
    Color? color,
    double fontSize = 18,
    bool isExpanded = true,
    bool isUpperCase = true,
    int? maxLines,
    TextOverflow? textOverflow,
    TextAlign textAlign = TextAlign.center,
    FontWeight fontWeight = FontWeight.bold,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    Widget? titlePrefix,
    Widget? titleSuffix,
  }) {
    if (isUpperCase) text = text.toUpperCase();
    color ??= Colors.black;
    Widget txt = Text(
      text,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: color,
      ),
      maxLines: maxLines,
      overflow: textOverflow,
      textAlign: textAlign,
    );

    List<Widget> list = [txt];
    if (titleSuffix != null) list.insert(0, titleSuffix);
    if (titlePrefix != null) list.add(titlePrefix);
    if (isExpanded) {
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        children: list.map((e) => Expanded(child: e)).toList(),
      );
    }
    if (list.length > 1) {
      return Row(mainAxisAlignment: mainAxisAlignment, children: list);
    }

    return list.first;
  }

  static String currencySymbol(String currCode) {
    switch (currCode) {
      case "RMB":
        return "Â¥";
      case "HKD":
        return "\$";
      default:
        return "";
    }
  }

  static String errorOccur(
    ApiResponse apiRes, {
    bool withoutNoNetwork = false,
  }) {
    String err = "";
    String noNetwork = "no_network_t".tr();
    if (!withoutNoNetwork && apiRes.isNoNetwork) {
      err = "$noNetwork\r\n";
      return err;
    }

    if (apiRes.isError) {
      err += "${apiRes.errMsg}\r\n";
      return err;
    }
    return err;
  }

  static Future<String> login(
    String username,
    String password,
    String shopcode,
  ) async {
    String error = "";

    String sql =
        "select user_id,user_name,user_level,user_password,status,allow_login,saleman_type from user_hdr where user_id = '$username'";
    String sql1 =
        "select top 1 * from machine_list where wh_code = '$shopcode'";

    ApiResponse apiRes = await ApiService.executeSQLQuery(
      null,
      [ApiService.sqlQueryParm(sql), ApiService.sqlQueryParm(sql1)],
    );

    error = errorOccur(apiRes);
    if (error.isNotEmpty) return error;

    List<dynamic> resData = ApiService.sqlQueryResult(apiRes);
    if (resData.isEmpty) return "your_account_is_not_existed_t".tr();

    String pwd = (resData.first["user_password"] ?? "").toString().trim();
    if (pwd != password.trim()) {
      return "the_current_password_is_incorrect_t".tr();
    }

    String status = (resData.first["status"] ?? "N").toString().trim();
    if (status != "A") return "your_account_is_not_activated_t".tr();

    String allowLogin = (resData.first["allow_login"] ?? "N").toString().trim();
    if (allowLogin != "Y") return "you_are_not_allow_to_login_t".tr();

    String salesType = (resData.first["saleman_type"] ?? "").toString().trim();

    bool isExist = false;
    switch (salesType) {
      case "A":
        break;
      case "M":
        sql = """select h.user_id from user_hdr h,user_shop s where 
          h.user_id = s.user_id and h.user_id = '$username' and s.sh_code = '$shopcode'""";
        isExist = await ApiService.recordIsExist(sql);
        if (!isExist) return "you_do_not_belong_to_this_shop_t".tr();
        break;
      case "S":
        sql = """select h.user_id from user_hdr h,v_wh_anly v 
          where h.shop_group = v.shop_group and h.user_id = '$username' and v.wh_code = '$shopcode' 
          and v.wh_status = 'A'""";
        isExist = await ApiService.recordIsExist(sql);
        if (!isExist) return "you_do_not_belong_to_this_shop_t".tr();
        break;
      default:
        return "you_do_not_belong_to_this_shop_t".tr();
    }

    userId = resData.first["user_id"] ?? "";
    userName = resData.first["user_name"] ?? "";
    userLevel = resData.first["user_level"] ?? 0;
    machineId = ApiService.sqlQueryValue(
      apiRes,
      "machine_id",
      index: 1,
      defaultValue: "",
    );
    shopCode = shopcode;

    await Common.storageService.write(
      key: loginKey,
      value: jsonEncode(
        {
          "userid": userId,
          "username": userName,
          "shopcode": shopCode,
          "userlevel": userLevel,
          "machineid": machineId,
        },
      ),
    );
    return error;
  }
}
