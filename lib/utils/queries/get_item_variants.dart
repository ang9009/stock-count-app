import 'package:sqflite/sqflite.dart';
import 'package:stock_count/pages/get_barcode_value_type.dart';
import 'package:stock_count/utils/classes.dart';
import 'package:stock_count/utils/enums.dart';
import 'package:stock_count/utils/helpers/initialize_db.dart';

const int itemVariantsFetchLimit = 20;

Future<List<ItemVariant>> getItemVariants({
  required String itemCode,
  required String docNo,
  required String docType,
}) async {
  Database localDb = await getDatabase();

  final res = await localDb.rawQuery(
    '''SELECT item_barcode, item_code, lot_no, qty_collected, bin_no FROM task_item
       WHERE qty_collected != 0
       AND item_code = '$itemCode'
       AND doc_no = '$docNo'
       AND doc_type = '$docType'
       LIMIT $itemVariantsFetchLimit;''',
  );

  return getItemVariantsFromData(res);
}

Future<List<ItemVariant>> getItemVariantsWithOffset({
  required String itemCode,
  required String docNo,
  required String docType,
  required int offset,
}) async {
  Database localDb = await getDatabase();

  final res = await localDb.rawQuery(
    '''SELECT item_barcode, item_code, lot_no, qty_collected, bin_no FROM task_item
       WHERE qty_collected != 0
       AND item_code = '$itemCode'
       AND doc_no = '$docNo'
       AND doc_type = '$docType'
       LIMIT $itemVariantsFetchLimit
       OFFSET $offset;''',
  );

  return getItemVariantsFromData(res);
}

List<ItemVariant> getItemVariantsFromData(List<Map<String, Object?>> data) {
  List<ItemVariant> items = data.map(
    (item) {
      String? itemBarcode = item["item_barcode"] as String?;
      String? lotNo = item["lot_no"] as String?;
      BarcodeValueTypes barcodeValueType = getBarcodeValueType(
        itemBarcode: itemBarcode,
        lotNo: lotNo,
      );

      return ItemVariant(
        itemCode: item["item_code"] as String,
        binNo: item["bin_no"] as String,
        itemBarcode: itemBarcode,
        lotNo: lotNo,
        qtyCollected: item["qty_collected"] as int,
        barcodeValueType: barcodeValueType,
      );
    },
  ).toList();

  return items;
}
