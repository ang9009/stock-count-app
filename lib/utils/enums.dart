// The type of the value from the scanned barcode
enum BarcodeValueTypes {
  barcode,
  itemCode,
  lotNo,
  // If the document type has the allow_unknown flag and the scanned item cannot be identified,
  // the barcode value type is "unknown"
  unknown,
}

enum TaskCompletionFilters {
  inProgress,
  completed,
}

final String unknownItemName = "UNK";
