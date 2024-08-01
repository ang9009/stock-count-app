// Get the top 10 receipts ordered by date
import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:stock_count/api/services/api_service.dart';
import 'package:stock_count/utils/classes.dart';
import 'package:stock_count/utils/helpers/doc_type_helpers.dart';
import 'package:stock_count/utils/helpers/initialize_db.dart';

// Amount of receipts to be fetched each time
const int receiptsFetchLimit = 20;

Future<List<ReceiptDownloadOption>> getReceipts(String docType) async {
  final tableName = getTableName(docType);
  final docTypeColPrefix = getDocTypeColPrefix(tableName);
  String? downloadedReceipts = await getDownloadedReceipts();
  String getReceiptsQuery =
      '''SELECT TOP $receiptsFetchLimit ${tableName}_no, ${docTypeColPrefix}_type, ${tableName}_date 
          FROM ${tableName}_hdr 
          WHERE ${tableName}_status NOT IN ('C', 'H')
          ${downloadedReceipts != null ? "AND CONCAT(${tableName}_no, ${docTypeColPrefix}_type) NOT IN $downloadedReceipts" : ""}
          ORDER BY ${tableName}_date''';

  final receipts = await ApiService.executeSQLQuery(
    null,
    [
      ApiService.sqlQueryParm(getReceiptsQuery),
    ],
  ).then((res) {
    final resData = ApiService.sqlQueryResult(res);
    final receipts = _getReceiptData(resData, tableName, docTypeColPrefix);

    return receipts;
  }).catchError((err) {
    log("An error occurred: ${err.toString()}");
    return Future<List<ReceiptDownloadOption>>.error(err.toString());
  });

  return receipts;
}

Future<List<ReceiptDownloadOption>> getReceiptsWithOffset(
  String docType,
  int offset,
) async {
  // Use to simulate loading time
  // await Future.delayed(const Duration(seconds: 2));
  final tableName = getTableName(docType);
  final docTypeColPrefix = getDocTypeColPrefix(tableName);
  String? downloadedReceipts = await getDownloadedReceipts();

  final receipts = ApiService.executeSQLQuery(
    null,
    [
      ApiService.sqlQueryParm(
        '''SELECT ${tableName}_no, ${docTypeColPrefix}_type, ${tableName}_date 
        FROM ${tableName}_hdr 
        WHERE ${tableName}_status NOT IN ('C', 'H')
        ${downloadedReceipts != null ? "AND CONCAT(${tableName}_no, ${docTypeColPrefix}_type) NOT IN $downloadedReceipts" : ""}
        ORDER BY ${tableName}_date 
        OFFSET $offset ROWS 
        FETCH NEXT $receiptsFetchLimit ROWS ONLY''',
      ),
    ],
  ).then((res) {
    final resData = ApiService.sqlQueryResult(res);
    final receipts = _getReceiptData(resData, tableName, docTypeColPrefix);

    return receipts;
  }).catchError((err) {
    log("An error occurred: ${err.toString()}");
    return Future<List<ReceiptDownloadOption>>.error(err.toString());
  });

  return receipts;
}

List<ReceiptDownloadOption> _getReceiptData(
  List<dynamic> resData,
  String tableName,
  String docTypeColPrefix,
) {
  List<ReceiptDownloadOption> receipts = [];

  for (final receiptData in resData) {
    final receiptOption = ReceiptDownloadOption(
      docNo: receiptData["${tableName}_no"],
      docType: receiptData["${docTypeColPrefix}_type"],
      creationDate: receiptData["${tableName}_date"],
    );
    receipts.add(receiptOption);
  }

  return receipts;
}

// Creates a string of values to be used in a SQL query in the format ('docTypeDocNo', ...)
// E.g. ('DNSC001', 'DNSC002', ... 'DNSC020')
// Meant to be used to filter out receipts that have already been downloaded in a SQL query
// using NOT IN

// Returns null if there are no downloaded receipts
Future<String?> getDownloadedReceipts() async {
  Database localDb = await getDatabase();
  List<Map> downloadedReceipts =
      await localDb.rawQuery("SELECT doc_no, doc_type FROM task");

  if (downloadedReceipts.isEmpty) return null;

  String docs = "";

  for (var i = 0; i < downloadedReceipts.length; i++) {
    final receipt = downloadedReceipts[i];

    // Trim for white space
    final doc = "'${receipt["doc_no"].trim()}${receipt["doc_type"].trim()}'";
    final comma = i == downloadedReceipts.length - 1 ? "" : ", ";
    docs += "$doc$comma";
  }

  return "($docs)";
}
