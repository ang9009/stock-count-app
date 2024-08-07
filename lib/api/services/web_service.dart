import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../common.dart';
import '../config.dart';
import '../custom_dialogs.dart';

class ApiResponse {
  final int statusCode;
  final Map<String, dynamic> body;
  bool isError;
  final bool isNoNetwork;
  String errMsg = "";

  ApiResponse(
    this.statusCode,
    this.body,
    this.isError,
    this.isNoNetwork, {
    this.errMsg = "",
  });
}

enum HttpRequestType {
  get,
  post,
  put,
  delete,
  patch,
}

class WebService {
  static bool get showLog => true;
  static bool get showShortenLog => false;

  static void log(String s) {
    final pattern = RegExp('.{1,800}');
    pattern.allMatches(s).forEach((match) => debugPrint(match.group(0)));
  }

  static logError(Object ex, StackTrace st) {
    FlutterError.dumpErrorToConsole(
        FlutterErrorDetails(exception: ex, stack: st));
  }

  static String datetimeToMSJson(DateTime dt) {
    var offsetSymbol = "+";
    if (dt.timeZoneOffset.isNegative) offsetSymbol = "-";
    var offsetMin = dt.timeZoneOffset.inMinutes;
    var offsethours = (offsetMin / 60).floor();
    offsetMin = offsetMin % 60;
    var nf = NumberFormat("00", "en_US");
    var jsonStr =
        "/Date(${dt.millisecondsSinceEpoch}$offsetSymbol${nf.format(offsethours)}${nf.format(offsetMin)})/";
    return jsonStr;
  }

  static DateTime parseMSJson(String jsonStr) {
    var numeric = jsonStr.split('(')[1].split(')')[0];
    var negative = numeric.contains('-');
    var parts = numeric.split(negative ? '-' : '+');
    var millis = int.parse(parts[0]);
    //This will get you a DateTime in the TZ of the phone:

    var local = DateTime.fromMillisecondsSinceEpoch(millis);
    return local;
/*//This will get you the UTC time:
  //var utc = DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true);


  final multiplier = negative ? -1 : 1;
  var offset = Duration(
    hours: int.parse(parts[1].substring(0, 2)) * multiplier,
    minutes: int.parse(parts[1].substring(2)) * multiplier,
  );*/
  }

  static dynamic datetimeFromMSJson(dynamic obj) {
    if (obj == null) return obj;
    // Handle String
    if ((obj is String)) {
      var keyWord = "/Date(";
      if (obj.startsWith(keyWord)) {
        obj = parseMSJson(obj);
      }
      return obj;
    }

    // Handle Array
    if (obj is List) {
      var len = obj.length;
      for (var i = 0; i < len; i++) {
        obj[i] = datetimeFromMSJson(obj[i]);
      }
      return obj;
    }

    // Handle Object
    if (obj is Map) {
      obj.forEach((key, value) {
        obj[key] = datetimeFromMSJson(obj[key]);
      });
      return obj;
    }

    return obj;
  }

  static Map<String, dynamic> _transServceError(Map<String, dynamic> errData) {
    String? errMsg;
    int? errCode;
    if (errData.containsKey("ErrMsg")) {
      errMsg = errData["ErrMsg"];
      if (errMsg != null) {
        if (errMsg.indexOf("text_e") > 0) {
          var tempObj = jsonDecode(errMsg);

          switch (Common.currentLocale.languageCode) {
            case "zh":
              if (Common.currentLocale.countryCode == "CN") {
                errMsg = tempObj["text_z"];
              } else {
                errMsg = tempObj["text_c"];
              }
              break;
            default:
              errMsg = tempObj["text_e"];
              break;
          }
        }
      }
    }

    if (errData.containsKey("ErrCode")) {
      errCode = errData["ErrCode"];
      //if ((errCode == -100) || (errCode == -101) || (errCode == -105) || (errCode == -106)) { //No login or login timeout or process not found or no locked
      //    window.location.reload();
      //}
    }
    return {"errCode": errCode ?? 0, "errMsg": errMsg ?? "Unknow error"};
  }

  static Future<ApiResponse> callSmartWinService(
    BuildContext? context,
    String targetFunc,
    Map<String, dynamic> data, {
    bool showLog = true,
    bool passingFirstValue = false,
    Map<String, dynamic>? header,
    BaseOptions? options,
  }) async {
    HttpRequestType reqType = HttpRequestType.post;
    Map<String, dynamic> defHeader = {
      Headers.contentTypeHeader: "application/json; chartset=utf-8"
    };
    if (header != null) {
      defHeader.addAll(header);
    }
    ApiResponse ret;
    if (context == null) {
      ret = await startRequest(
        reqType,
        Config.apiUrl,
        targetFunc,
        data,
        defHeader,
        passingFirstValue: passingFirstValue,
        options: options,
        showLog: showLog,
      );
    } else {
      ret = await callWebservice(
        context,
        reqType,
        Config.apiUrl,
        targetFunc,
        data,
        defHeader,
        passingFirstValue: passingFirstValue,
        options: options,
        showLog: showLog,
      );
    }
    if (!ret.isError) {
      if (ret.body.containsKey("Error")) {
        var err = ret.body["Error"];
        if (err != null) {
          err = _transServceError(err);
          ret.isError = true;
          ret.errMsg = err["errMsg"];
          return ret;
        }
      }
      if (ret.body.containsKey("Data")) {
        var data = ret.body["Data"];
        if (data != null) {
          if ((targetFunc == "ExecuteSQLQuery") ||
              (targetFunc == "GetSQLSchema")) {
            ret.body["Data"] = jsonDecode(data);
          }
          data = ret.body["Data"];
          if (data is Map) {
            if (data.containsKey("AttachedResult")) {
              var atResult = data["AttachedResult"];
              if (atResult is Map) {
                if (atResult.containsKey("ReturnData")) {
                  ret.body["Data"]["AttachedResult"]["ReturnData"] =
                      jsonDecode(atResult["ReturnData"]);
                }
              }
              var trx = data["trx"];
              if (trx is List && trx.isNotEmpty) {
                ret.body["Data"] = [trx.first["pmtHeader"]];
              }
            }
          }
          //Convert ms datetime to js datetime
          ret.body["Data"] = datetimeFromMSJson(ret.body["Data"]);
        }
      }
    }
    return ret;
  }

  static Future<ApiResponse> callWebservice(
      BuildContext context,
      HttpRequestType type,
      String apiUrl,
      String endpoint,
      Map<String, dynamic> body,
      Map<String, dynamic> header,
      {bool showLog = true,
      bool passingFirstValue = false,
      BaseOptions? options}) async {
    return await futureWithIndicator(context, () async {
      return startRequest(
        type,
        apiUrl,
        endpoint,
        body,
        header,
        showLog: showLog,
        passingFirstValue: passingFirstValue,
        options: options,
      );
    });
  }

  static Future<ApiResponse> startRequest(
    HttpRequestType type,
    String apiUrl,
    String endpoint,
    dynamic body,
    Map<String, dynamic> header, {
    bool showLog = true,
    bool passingFirstValue = false,
    BaseOptions? options,
  }) async {
    String url = apiUrl + endpoint;
    String method = "";
    switch (type) {
      case HttpRequestType.get:
        method = "GET";
        break;
      case HttpRequestType.post:
        method = "POST";
        break;
      case HttpRequestType.put:
        method = "PUT";
        break;
      case HttpRequestType.delete:
        method = "DELETE";
        break;
      case HttpRequestType.patch:
        method = "PATCH";
        break;
    }
    if (showLog && WebService.showLog) {
      String s = "[$method $endpoint] ${jsonEncode(body)}";
      log(s);
    } else if (WebService.showShortenLog) {
      String s = "[$method $endpoint]";
      log(s);
    }

    Response? response;
    int statusCode = -1;
    String errMsg = "";
    try {
      dynamic data = body;
      if (passingFirstValue) {
        if (type != HttpRequestType.get) {
          if (body.isNotEmpty) data = body.values.first;
        }
      }
      switch (type) {
        case HttpRequestType.get:
          response = await get(url, body, header, options: options);
          break;
        case HttpRequestType.post:
          response = await post(url, data, header, options: options);
          break;
        case HttpRequestType.put:
          response = await put(url, data, header, options: options);
          break;
        case HttpRequestType.delete:
          response = await delete(url, data, header, options: options);
          break;
        case HttpRequestType.patch:
          response = await patch(url, data, header, options: options);
          break;
      }
      statusCode = response.statusCode ?? -1;
    } catch (e, st) {
      logError(e, st);

      if (e is DioError) {
        if (e.response != null) {
          statusCode = e.response?.statusCode ?? 0;
          errMsg = e.response?.statusMessage ?? "";
          if (errMsg.isEmpty) {
            if (e.response?.data is String) {
              errMsg = e.response?.data;
              /*body = {
              "error": e.response?.data
            }; //body = {"data": e.response?.data};*/
            } else {
              errMsg = e.response?.data.toString() ?? "Unknow error";
              // body = e.response?.data;
            }
          }
        } else {
          errMsg = e.error.toString();
          // body = {"error": e.error.toString()};
        }
      }
    }

    return handleResponse(
      response,
      statusCode,
      {},
      method,
      endpoint,
      showLog,
      errMsg,
    );
  }

  Future<ApiResponse> uploadFile(
    String apiUrl,
    String endpoint,
    FormData data,
    Map<String, dynamic> header, {
    BaseOptions? options,
  }) async {
    Response? response;
    int statusCode = -1;
    Map<String, dynamic> body = {};
    String errMsg = "";
    Dio dio = getDio(options);
    try {
      response = await dio.post(
        apiUrl + endpoint,
        data: data,
        options: Options(headers: header),
      );
      statusCode = response.statusCode ?? -1;
    } on DioError catch (e) {
      // print(e.error);
      // print(e.message);
      // print(e.response.data);
      if (e.response != null) {
        statusCode = e.response?.statusCode ?? 0;
        body = e.response?.data;
        errMsg = e.response?.data;
      } else {
        errMsg = e.error.toString();
      }
    } finally {
      disposeDio(dio);
    }

    return handleResponse(
      response,
      statusCode,
      body,
      "uploadFile",
      endpoint,
      true,
      errMsg,
    );
  }

  static Future<ApiResponse> downloadFile(
    String urlPath,
    savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    dynamic data,
    Map<String, dynamic>? header,
    BaseOptions? options,
  }) async {
    Response? response;
    int statusCode = -1;
    Map<String, dynamic> body = {};
    String errMsg = "";
    var dio = getDio(options);
    try {
      response = await dio.download(urlPath, savePath,
          options: Options(headers: header));
      statusCode = response.statusCode ?? -1;
    } on DioError catch (e) {
      errMsg = e.response?.statusMessage ?? "";
      if (errMsg.isEmpty) {
        if (e.response != null) {
          statusCode = e.response?.statusCode ?? 0;
          body = e.response?.data;
          errMsg = e.response?.data;
        } else {
          errMsg = e.error.toString();
        }
      }
    } finally {
      disposeDio(dio);
    }
    return handleResponse(
      response,
      statusCode,
      body,
      "downloadfile",
      urlPath,
      true,
      errMsg,
    );
  }

  static ApiResponse handleResponse(
    Response? response,
    int statusCode,
    Map<String, dynamic> body,
    String method,
    String endpoint,
    bool showLog,
    String errMsg,
  ) {
    bool isError = !(statusCode >= 200 && statusCode < 300);
    bool canConvertToJson = true;
    if (response != null) {
      statusCode = response.statusCode!;
      if (response.data is Map<String, dynamic>) {
        body = response.data;
        if (body["Error"] != null) {
          errMsg = body["Error"]["ErrMsg"];
          isError = true;
        }
      } else {
        body = {"data": response.data};
        canConvertToJson = false;
      }
    }

    if (showLog && WebService.showLog) {
      String bodyJson = canConvertToJson ? jsonEncode(body) : "";
      String s = "[$method $endpoint $statusCode] $bodyJson";
      log(s);
    } else if (WebService.showShortenLog) {
      String s = "[$method $endpoint $statusCode]}";
      log(s);
    }

    return ApiResponse(
      statusCode,
      body,
      isError,
      statusCode == -1,
      errMsg: errMsg,
    );
  }

  static Dio getDio(BaseOptions? options) {
    Dio dio = Dio(options);
    return dio;
  }

  static disposeDio(Dio dio) {
    dio.close();
  }

  static Future<Response> get(
      String url, Map<String, dynamic> data, Map<String, dynamic> header,
      {BaseOptions? options}) async {
    Dio dio = getDio(options);
    try {
      Response response = await dio.get(
        url,
        queryParameters: data,
        options: Options(headers: header),
      );
      return response;
    } finally {
      disposeDio(dio);
    }
  }

  static Future<Response> post(
      String url, dynamic data, Map<String, dynamic> header,
      {BaseOptions? options}) async {
    Dio dio = getDio(options);
    try {
      Response response = await dio.post(
        url,
        data: data,
        options: Options(headers: header),
      );
      return response;
    } finally {
      disposeDio(dio);
    }
  }

  static Future<Response> put(
      String url, dynamic data, Map<String, dynamic> header,
      {BaseOptions? options}) async {
    Dio dio = getDio(options);
    try {
      Response response = await dio.put(
        url,
        data: data,
        options: Options(headers: header),
      );
      return response;
    } finally {
      disposeDio(dio);
    }
  }

  static Future<Response> patch(
      String url, dynamic data, Map<String, dynamic> header,
      {BaseOptions? options}) async {
    Dio dio = getDio(options);
    try {
      Response response = await dio.patch(
        url,
        data: data,
        options: Options(headers: header),
      );
      return response;
    } finally {
      disposeDio(dio);
    }
  }

  static Future<Response> delete(
      String url, dynamic data, Map<String, dynamic> header,
      {BaseOptions? options}) async {
    Dio dio = getDio(options);
    try {
      Response response = await dio.delete(
        url,
        data: data,
        options: Options(headers: header),
      );
      return response;
    } finally {
      disposeDio(dio);
    }
  }

  static String cURLRepresentation(RequestOptions options) {
    List<String> components = ["\$ curl -i"];
    if (options.method.toUpperCase() == "GET") {
      components.add("-X ${options.method}");
    }

    options.headers.forEach((k, v) {
      if (k != "Cookie") {
        components.add("-H \"$k: $v\"");
      }
    });

    var data = json.encode(options.data);
    data = data.replaceAll('"', '\\"');
    components.add("-d \"$data\"");

    components.add("\"${options.uri.toString()}\"");

    return components.join('\\\n\t');
  }
}
