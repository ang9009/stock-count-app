import 'dart:convert';
import 'dart:io' as io;

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../common.dart';
import '../config.dart';
import 'web_service.dart';

enum ContentType { appJson, textHtml, imageJpg }

class ApiService {
  static const int ptCustomSystem = 3;
  static const int ptWebPos = 0;

  static Map<String, String> getHeader() {
    Map<String, String> header = {
      // "accept": "application/json",
      "Content-Type": "application/json; chartset=utf-8",
      // "Content-Type": "application/x-www-form-urlencoded",
      // "Platform": Common.navigatorPlatform,
      // "Version": Config.version,
      // "x-api-key": Config.apiKey,
      // "Accept-Language": LanguageVM.lang,
    };
    return header;
  }

  //login smartwin service
  static Future<ApiResponse> login(
    BuildContext? context, {
    String? userName,
    String? userPwd,
    int? connectTimeout,
  }) async {
    await logout(context, connectTimeout: connectTimeout);

    if (Common.serviceLoginID.isEmpty) {
      Map<String, dynamic> loginInfo = {
        "UserName": userName ?? "",
        "Password": userPwd ?? "",
        "ProcessType": ptCustomSystem,
      };

      // ignore: use_build_context_synchronously
      ApiResponse apiRes = await WebService.callSmartWinService(
        context,
        "Login",
        loginInfo,
        options: BaseOptions(
          connectTimeout: connectTimeout,
        ),
      );

      if (apiRes.isError) {
        return apiRes;
      } else {
        Common.serviceLoginID = apiRes.body["WarningMsg"][0];
        await Common.storageService.write(
          key: Common.serviceLoginIDKey,
          value: Common.serviceLoginID,
        );
      }
    }

    return ApiResponse(200, {}, false, false);
  }

  //logout smartwin service
  static Future<ApiResponse?> logout(
    BuildContext? context, {
    int? connectTimeout,
    bool testingOnly = false,
  }) async {
    ApiResponse? loginRes;
    if (testingOnly || (Common.serviceLoginID.isNotEmpty)) {
      String loginId = Common.serviceLoginID;
      if (testingOnly) loginId = "";

      loginRes = await WebService.callSmartWinService(
        context,
        "Logout",
        {"loginID": jsonEncode(loginId)},
        passingFirstValue: true,
        options: BaseOptions(connectTimeout: connectTimeout),
      );
      if (!testingOnly) {
        if (!loginRes.isError) {
          Common.serviceLoginID = "";
          await Common.storageService.write(
            key: Common.serviceLoginIDKey,
            value: Common.serviceLoginID,
          );
        }
      }
    }

    // ignore: use_build_context_synchronously
    await loginWebPos(context, connectTimeout: connectTimeout);

    if (loginRes != null && loginRes.isNoNetwork) return loginRes;
    return null;
  }

  //login web pos
  static Future<ApiResponse> loginWebPos(
    BuildContext? context, {
    String? userName,
    String? userPwd,
    int? connectTimeout,
  }) async {
    await logoutWebPos(context, connectTimeout: connectTimeout);

    if (Common.serviceLoginPosID.isEmpty) {
      Map<String, dynamic> loginInfo = {
        "UserName": userName ?? "",
        "Password": userPwd ?? "",
        "ProcessType": ptWebPos,
      };

      // ignore: use_build_context_synchronously
      ApiResponse apiRes = await WebService.callSmartWinService(
        context,
        "Login",
        loginInfo,
        options: BaseOptions(
          connectTimeout: connectTimeout,
        ),
      );

      if (apiRes.isError) {
        return apiRes;
      } else {
        Common.serviceLoginPosID = apiRes.body["WarningMsg"][0];
        await Common.storageService.write(
          key: Common.serviceLoginPosIDKey,
          value: Common.serviceLoginPosID,
        );
      }
    }

    return ApiResponse(200, {}, false, false);
  }

  //logout web pos
  static Future<ApiResponse?> logoutWebPos(
    BuildContext? context, {
    int? connectTimeout,
    bool testingOnly = false,
  }) async {
    ApiResponse? loginPosRes;
    if (testingOnly || (Common.serviceLoginPosID.isNotEmpty)) {
      String loginId = Common.serviceLoginPosID;
      if (testingOnly) loginId = "";

      // ignore: use_build_context_synchronously
      loginPosRes = await WebService.callSmartWinService(
        context,
        "Logout",
        {"loginID": jsonEncode(loginId)},
        passingFirstValue: true,
        options: BaseOptions(connectTimeout: connectTimeout),
      );
      if (!testingOnly) {
        if (!loginPosRes.isError) {
          Common.serviceLoginPosID = "";
          await Common.storageService.write(
            key: Common.serviceLoginPosIDKey,
            value: Common.serviceLoginPosID,
          );
        }
      }
    }

    if (loginPosRes != null && loginPosRes.isNoNetwork) return loginPosRes;
    return null;
  }

// Execute write statements
  static Future<ApiResponse> executeSQL(
    BuildContext? context,
    List<String> sqlStr,
  ) async {
    var sqlParm = {"loginID": Common.serviceLoginID, "parmData": sqlStr};
    var ret = await WebService.callSmartWinService(
      context,
      "ExecuteSQL",
      sqlParm,
    );
    return ret;
  }

  static Map<String, dynamic> sqlQueryParm(
    String sql, {
    int pageIndex = 0,
    int pageSize = 0,
    String whereStatement = "",
    String groupByStatement = "",
    String orderByStatement = "",
  }) {
    return {
      "sqlStr": sql,
      "pageIndex": pageIndex,
      "pageSize": pageSize,
      "AttachWhereStatement": whereStatement,
      "AttachGroupByStatement": groupByStatement,
      "AttachOrderByStatement": orderByStatement
    };
  }

  static List<dynamic> sqlQueryResult(
    ApiResponse apiRes, {
    int index = 0,
    bool firstValidRecord = false,
  }) {
    //当firstValidRecord为真时，递增式返回第一条有效数据
    List<dynamic> resData = <dynamic>[];
    if ((apiRes.body["Data"] is List) &&
        (apiRes.body["Data"].length > 0) &&
        (index < apiRes.body["Data"].length)) {
      if (firstValidRecord) {
        var data = apiRes.body["Data"];

        for (var i = 0; i < data.length; i++) {
          if ((data[i] is List) && (data[i].length > 0)) {
            resData = data[i];
            break;
          }
        }
      } else {
        resData = apiRes.body["Data"][index];
      }
    }

    return resData;
  }

  static dynamic sqlQueryValue(
    ApiResponse apiRes,
    String colName, {
    dynamic defaultValue,
    int index = 0,
  }) {
    try {
      List<dynamic> resData = sqlQueryResult(apiRes, index: index);
      if (resData.isNotEmpty) {
        return resData.first[colName];
      }
      return defaultValue;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<bool> recordIsExist(
    String sql, {
    int index = 0,
    bool firstValidRecord = false,
  }) async {
    ApiResponse apiRes = await ApiService.executeSQLQuery(
      null,
      [ApiService.sqlQueryParm(sql)],
    );
    if (apiRes.isError) return false;
    List<dynamic> resData = sqlQueryResult(
      apiRes,
      index: index,
      firstValidRecord: firstValidRecord,
    );
    if (resData.isEmpty) return false;
    return true;
  }

  static String getAllUpdatedOnAndBy(
    String updatedBy, {
    bool withoutUpdatedOnAndBy = false,
  }) {
    if (updatedBy.isEmpty) updatedBy = "SIS";
    String sql = """ ,ho_upd_on = getdate(),
                      ho_upd_by = '$updatedBy',
                      sh_upd_on = getdate(),
                      sh_upd_by = '$updatedBy' """;
    if (!withoutUpdatedOnAndBy) {
      sql += ",updated_on = getdate(),updated_by = '$updatedBy' ";
    }
    return sql;
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

// Used for read
  static Future<ApiResponse> executeSQLQuery(
    BuildContext? context,
    List<Map<String, dynamic>> sqlParm,
  ) async {
    /*e.g: sqlParm = {
      "sqlStr": "",
      "pageIndex": 0,
      "pageSize": 0,
      "AttachWhereStatement": "",
      "AttachGroupByStatement": "",
      "AttachOrderByStatement": ""
    };*/
    var parmData = {"loginID": Common.serviceLoginID, "parmData": sqlParm};
    var ret = await WebService.callSmartWinService(
      context,
      "ExecuteSQLQuery",
      parmData,
    );

    String errMsg = errorOccur(ret);
    if (errMsg.isNotEmpty) {
      return Future<ApiResponse>.error(
        errMsg,
      );
    }

    return ret;
  }

  static Future<ApiResponse> refreshSalesList(
    BuildContext? context,
    Map<String, dynamic> header,
    List<Map<String, dynamic>> detail,
  ) async {
    /* e.g: salesList = {
      "trx": [
        {
          "trxHeader": {"trx_no": "trxNO", "trx_type": "SAL"},
          "trxDetail": [{"trx_no": "trxNo", "item_code": "a", "item_qty": 2}]
        }
      ]
    };*/
    Map<String, dynamic> salesList = {
      "trx": [
        {"trxHeader": header, "trxDetail": detail}
      ],
      "loginID": Common.serviceLoginPosID,
    };
    // if (!salesList.containsKey("loginID")) {
    //   //调用的是pos功能
    //   salesList["loginID"] = Common.serviceLoginPosID;
    // }
    ApiResponse apiRes = await WebService.callSmartWinService(
      context,
      "RefreshSalesList",
      salesList,
    );
    return apiRes;
  }

  static Future<ApiResponse> getAppInfo(BuildContext? context) async {
    ApiResponse apiRes = await login(context, connectTimeout: 3000); //login
    if (apiRes.isError) {
      throw ErrorDescription(apiRes.errMsg);
    }
    if (Common.appInfo != null) {
      return ApiResponse(200, Common.appInfo!, false, false);
    }
    // ignore: use_build_context_synchronously
    var ret = await WebService.callSmartWinService(
      context,
      "GetAppInfo",
      {"null": null},
      passingFirstValue: true,
    );
    if (!ret.isError) {
      try {
        ret.body["Data"]?["CompanyEnableTime"] = null;
        await Common.storageService.write(
          key: Common.appInfoKey,
          value: jsonEncode(ret.body),
        );
      } catch (ex) {
        debugPrint(ex.toString());
      }
    }
    return ret;
  }

  static Future<ApiResponse> uploadFile(
    BuildContext? context,
    srcFile,
    String fileName,
    String filePath, {
    ContentType? contentType,
  }) async {
    if (!await io.File(srcFile).exists()) {
      return ApiResponse(-1, {}, true, false)
        ..errMsg = "File $srcFile not found.";
    }
    Map<String, dynamic>? header;
    /*FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        srcFile,
        filename: fileName,
      ),
    });*/
    var byteList = io.File(srcFile).readAsBytesSync();
    header = {
      Headers.contentTypeHeader: "application/octet-stream",
      Headers.contentLengthHeader: byteList.length
    };
    var formData = Stream.fromIterable(
        byteList.map((element) => [element])); //io.File(srcFile).openRead();

    String ep =
        "UploadFile?loginID=${Uri.encodeComponent(Common.serviceLoginID)}&fileName=${Uri.encodeComponent(fileName)}&filePath=${Uri.encodeComponent(filePath)}";
    // ignore: use_build_context_synchronously
    var ret = await WebService.callSmartWinService(
      context,
      ep,
      {"fileData": formData},
      passingFirstValue: true,
      showLog: false,
      header: header,
    );
    if (!ret.isError) {
      if (ret.body.containsKey("WarningMsg")) {
        var wm = ret.body["WarningMsg"];
        if ((wm != null) && (wm is List)) {
          if (wm.isNotEmpty) {
            wm[0] = jsonDecode(wm[0]);
            wm[0] = WebService.datetimeFromMSJson(wm[0]);
            ret.body["WarningMsg"] = wm;
          }
        }
      }
    }
    return ret;
  }

  static String genFileURL(String filePath, {bool showOnly = false}) {
    if (filePath.trim().isEmpty) return "";

    String srvUrl = Config.apiUrl;
    srvUrl =
        ((srvUrl.endsWith("/") || srvUrl.endsWith("\\")) ? srvUrl : "$srvUrl/");
    return "${srvUrl}DownloadFile?loginID=${Uri.encodeComponent(Common.serviceLoginID)}&showOnly=${showOnly ? "true" : "false"}&filePath=${Uri.encodeComponent(filePath)}";
  }

  static Future<ApiResponse> downFile(
    BuildContext? context,
    urlPath,
    saveFileName, {
    String? saveFilePath,
  }) async {
    var filePath = "${Config.localFilePath}/$saveFileName";
    if ((saveFilePath ?? "").isNotEmpty) {
      filePath = "$saveFilePath/$saveFileName";
    }
    var ret = await WebService.downloadFile(urlPath, filePath);
    if (!ret.isError) ret.body["File"] = filePath;
    return ret;
  }

  static Future<ApiResponse> getDataByDatastore(
      BuildContext? context, Map<String, dynamic> parmData,
      {Map<String, dynamic>? header}) async {
    /*e.g:
        parmData = {
            DatastoreSourceType DataSourceType,
            string DataSource, //dstDataObject: dataobject,dstPSR: psr file path,dstSQL: sql satatement,dstDWR: report id for report writer
            string[] JsonData, //dstDWR: this is setting(dwr_hdr,dwr_dat) if exits
            int ReturnPageStart,
            int ReturnPageCount,
            bool ReturnFromBuffer,	
            DatastoreSaveAsType ReturnDataType,
            DatastoreDataFormatType ReturnDataFormat,
            //--For report writer
            string LanguageID,
            string ShopCode,
            string UserID
            //--End
        }
    */
    var parmInfo = {"loginID": Common.serviceLoginID, "parmData": parmData};
    var ret = await WebService.callSmartWinService(
        context, "GetDataByDatastore", parmInfo,
        header: header);
    return ret;
  }

  static String genGetDataByDatastoreURL(
    Map<String, dynamic> parmData,
  ) {
    var objectAsJson =
        jsonEncode({"loginID": Common.serviceLoginID, "parmData": parmData});
    var baseUrl = "${Config.apiUrl}ScriptService/GetDataByDatastore";
    return "$baseUrl?dsParm=${Uri.encodeComponent(objectAsJson)}";
  }

  static Map<String, dynamic> callFunctionParm(
    String funcNo,
    List<Map<String, String>> stringParms, {
    List<Map<String, dynamic>>? datetimeParms,
    List<Map<String, dynamic>>? numberParms,
  }) {
    return {
      "funcNo": funcNo,
      "stringParms": stringParms,
      "datetimeParms": datetimeParms,
      "numberParms": numberParms,
    };
  }

  static Future<ApiResponse> callFunction(
      BuildContext? context, Map<String, dynamic> funcParm) async {
    /*e.g:
     funcParm = {"funcNo": "",
     "stringParms": [{"Name": "","Value": ""}],
     "datetimeParms": [{"Name": "","Value": DateTime.now()}],
     "numberParms": [{"Name": "","Value": 0}]};
    */

    funcParm["loginID"] = Common.serviceLoginID;
    var ret =
        await WebService.callSmartWinService(context, "CallFunction", funcParm);
    if (!ret.isError) {
      if (!ret.body.containsKey("WarningMsg")) {
        ret.body["WarningMsg"] = null;
      }
      if (ret.body.containsKey("Data")) {
        var data = ret.body["Data"];
        if (data is Map) {
          if (data.containsKey("ReturnData")) {
            if (data["ReturnData"] != null) {
              var retData = data["ReturnData"];
              retData = jsonDecode(retData);
              retData = WebService.datetimeFromMSJson(retData);
              data["ReturnData"] = retData;
            }
          }
        }
      }
    }
    return ret;
  }
}
