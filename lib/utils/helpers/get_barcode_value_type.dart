import 'package:stock_count/utils/enums.dart';

BarcodeValueTypes getBarcodeValueType({
  required String? itemBarcode,
  required String? lotNo,
  required String? itemName,
}) {
  if (itemName == unknownItemName) {
    return BarcodeValueTypes.unknown;
  } else if (itemBarcode == null && lotNo == null) {
    return BarcodeValueTypes.itemCode;
  } else if (itemBarcode != null) {
    return BarcodeValueTypes.barcode;
  } else {
    return BarcodeValueTypes.lotNo;
  }
}
