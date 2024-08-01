// exist bin_no, exist lot_no, exist

import 'package:sqflite/sqflite.dart';
import 'package:stock_count/utils/classes.dart';
import 'package:stock_count/utils/enums.dart';
import 'package:stock_count/utils/helpers/initialize_db.dart';

Future<void> updateScannedItemQuantity({
  required ScannedItem item,
  required String docType,
  required String docNo,
  required String binNo,
}) async {
  Database localDb = await getDatabase();

  final whereCondition = _getWhereCondition(
    item: item,
    docType: docType,
    docNo: docNo,
    binNo: binNo,
  );

  List<Map> matchingItemVariants;

  try {
    final getMatchingItemsQuery = '''SELECT COUNT(1) AS count
                                     FROM task_item
                                     $whereCondition''';
    matchingItemVariants = await localDb.rawQuery(getMatchingItemsQuery);
  } catch (err) {
    return Future.error("An unexpected error occurred: ${err.toString()}");
  }

  final matchingItemsCount =
      int.parse(matchingItemVariants[0]["count"].toString());

  try {
    final itemData = item.taskItem;
    String itemBarcode = item.barcodeValueType == BarcodeValueTypes.barcode
        ? "'${item.barcode}'"
        : "NULL";
    String lotNo = item.barcodeValueType == BarcodeValueTypes.lotNo
        ? "'${item.barcode}'"
        : "NULL";

    if (matchingItemsCount == 0) {
      await localDb.rawInsert(
          '''INSERT INTO task_item (doc_type, doc_no, item_code, item_name, item_barcode, lot_no, bin_no, qty_collected)
           VALUES ('$docType', '$docNo', '${itemData.itemCode}', '${itemData.itemName}', $itemBarcode, $lotNo, '$binNo', 1);''');
    } else {
      await localDb.rawUpdate('''UPDATE task_item
                               SET qty_collected = qty_collected + 1
                               $whereCondition''');
    }
  } catch (err) {
    return Future.error("An unexpected error occurred: ${err.toString()}");
  }
}

String _getWhereCondition({
  required ScannedItem item,
  required String docType,
  required String docNo,
  required String binNo,
}) {
  String barcodeAndSerialReq = switch (item.barcodeValueType) {
    BarcodeValueTypes.barcode =>
      "AND item_barcode = '${item.barcode}' AND lot_no IS NULL",
    BarcodeValueTypes.lotNo =>
      "AND lot_no = '${item.barcode}' AND item_barcode IS NULL",
    BarcodeValueTypes.itemCode => "lot_no IS NULL AND item_barcode IS NULL",
  };

  final itemData = item.taskItem;
  return '''WHERE doc_type = '$docType' 
           AND doc_no = '$docNo'
           AND item_code = '${itemData.itemCode}'
           AND bin_no = '$binNo'
           AND qty_required = 0
           $barcodeAndSerialReq''';
}
