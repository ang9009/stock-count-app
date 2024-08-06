// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:stock_count/utils/enums.dart';

class ReceiptDocTypeFilterOption {
  final String docDesc;
  final String parentType;

  ReceiptDocTypeFilterOption({
    required this.docDesc,
    required this.parentType,
  });

  @override
  bool operator ==(Object other) =>
      other is ReceiptDocTypeFilterOption &&
      other.docDesc == docDesc &&
      other.parentType == parentType;

  @override
  int get hashCode => Object.hash(docDesc, parentType);
}

// A task that is displayed on the "my tasks" page
// Some data is nullable because items can belong to receipts that have "allow_unknown" set to true
// Item code cannot be nullable, since unknown items have their barcode as their item code
class TaskItem {
  final String itemCode;
  final String itemName;
  final int? qtyRequired;
  final int qtyCollected;

  TaskItem({
    required this.itemCode,
    required this.itemName,
    required this.qtyRequired,
    required this.qtyCollected,
  });
}

// An item that has been scanned on the "scan items" page
class ScannedItem {
  final TaskItem taskItem;
  final String barcode;
  final BarcodeValueTypes barcodeValueType;

  ScannedItem({
    required this.taskItem,
    required this.barcode,
    required this.barcodeValueType,
  });
}

class Task {
  final String docNo;
  final String docType;
  final String parentType;
  final DateTime? lastUpdated;
  final DateTime createdAt;
  final int qtyRequired;
  final int qtyCollected;

  Task({
    required this.docNo,
    required this.docType,
    required this.parentType,
    required this.lastUpdated,
    required this.createdAt,
    required this.qtyCollected,
    required this.qtyRequired,
  });
}

class ReceiptDownloadOption {
  final String docNo;
  final String docType;
  final DateTime creationDate;

  ReceiptDownloadOption({
    required this.creationDate,
    required this.docNo,
    required this.docType,
  });

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    ReceiptDownloadOption otherReceipt = other as ReceiptDownloadOption;

    if (docNo == otherReceipt.docNo && docType == otherReceipt.docType) {
      return true;
    }

    return false;
  }

  @override
  int get hashCode => Object.hash(docNo, docType);
}

class ItemVariant {
  final String itemCode;
  final String binNo;
  final String? itemBarcode;
  final String? lotNo; // Serial
  final int qtyCollected;
  final BarcodeValueTypes barcodeValueType;

  ItemVariant({
    required this.itemBarcode,
    required this.lotNo,
    required this.binNo,
    required this.itemCode,
    required this.qtyCollected,
    required this.barcodeValueType,
  });

  // Required for "itemChanges" map since ItemVariants are used as keys, and qtyCollected
  // needs to be ignored for comparisions
  // ! Might cause issues if used in data collections that require unique values?
  @override
  int get hashCode => Object.hash(
        itemCode,
        binNo,
        itemBarcode,
        lotNo,
      );

  @override
  bool operator ==(Object other) {
    if (other is! ItemVariant) return false;

    return itemCode == other.itemCode &&
        binNo == other.binNo &&
        itemBarcode == other.itemBarcode &&
        lotNo == other.lotNo &&
        qtyCollected == other.qtyCollected &&
        barcodeValueType == other.barcodeValueType;
  }

  @override
  String toString() {
    return 'ItemVariant('
        'itemBarcode: $itemBarcode, '
        'lotNo: $lotNo, '
        'binNo: $binNo, '
        'itemCode: $itemCode, '
        'qtyCollected: $qtyCollected, '
        'barcodeValueType: $barcodeValueType)';
  }
}
