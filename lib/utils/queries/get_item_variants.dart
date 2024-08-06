import 'package:sqflite/sqflite.dart';
import 'package:stock_count/utils/enums.dart';
import 'package:stock_count/utils/helpers/get_barcode_value_type.dart';
import 'package:stock_count/utils/helpers/local_database_helper.dart';
import 'package:stock_count/utils/object_classes.dart';

const int itemVariantsFetchLimit = 20;

Future<List<ItemVariant>> getItemVariants({
  required String? itemCode,
  required String docNo,
  required String docType,
  required int offset,
}) async {
  Database localDb = await LocalDatabaseHelper.instance.database;

  // !Needs testing
  final res = await localDb.rawQuery(
    '''SELECT item_barcode, item_code, lot_no, qty_collected, bin_no, item_name FROM task_item
       WHERE qty_collected != 0
       AND item_code ${itemCode == null ? '''IS NULL''' : "= '$itemCode'"}
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
      String itemName = item["item_name"] as String;
      BarcodeValueTypes barcodeValueType = getBarcodeValueType(
        itemBarcode: itemBarcode,
        lotNo: lotNo,
        itemName: itemName,
      );

      return ItemVariant(
        itemCode: item["item_code"]?.toString(),
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
