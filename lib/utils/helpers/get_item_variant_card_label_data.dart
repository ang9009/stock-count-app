import 'package:stock_count/utils/enums.dart';
import 'package:stock_count/utils/object_classes.dart';

// Used to get data to be displayed on the item variant label (e.g. "SC001 (Barcode)")

// barcodeVal refers to the value of the barcode, barcodeValTypeLabel refers to the label corresponding
// to the type of the barcode value (if the barcode value is a barcode, item code, or lot no.)
// E.g. if the item variant's barcode value "I001" is its item code, then the item's variant label
// will display "I001 (Item code)"
({String barcodeVal, String barcodeValTypeLabel}) getItemVariantCardLabelData(
    ItemVariant item) {
  return switch (item.barcodeValueType) {
    BarcodeValueTypes.barcode => (
        barcodeVal: item.itemBarcode!,
        barcodeValTypeLabel: "Barcode"
      ),
    BarcodeValueTypes.itemCode => (
        barcodeVal: item.itemCode,
        barcodeValTypeLabel: "Item code"
      ),
    BarcodeValueTypes.lotNo => (
        barcodeVal: item.lotNo!,
        barcodeValTypeLabel: "Serial/lot no."
      ),
    BarcodeValueTypes.unknown => (
        barcodeVal: item.itemCode,
        barcodeValTypeLabel: "Unknown"
      ),
  };
}
