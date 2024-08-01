// Table prefix special cases:
// SHO/TRO - trx
// TQS - trx
// IN - inv
// Otherwise, use the parent type as the table prefix (e.g. dn_hdr and dn_no).

// Since there are some cases where the parent type doesn't match the table name,
// we use this function
String getTableName(String parentType) {
  final tableName = switch (parentType.toUpperCase().trim()) {
    "SHO" => "trx",
    "TRO" => "trx",
    "TQS" => "trx",
    "IN" => "inv",
    _ => parentType,
  };

  return tableName;
}

// Purchase orders (PO) have a qty_ordered column instead of a item_qty column
String getQtyColName(String parentType) {
  final colName = switch (parentType.toUpperCase().trim()) {
    "PO" => "qty_ordered",
    _ => "item_qty",
  };

  return colName;
}

// The trx tables uses "doc_type" as the column name for document type,  while other tables
// use "parentType_type" (e.g. dn_type)
String getDocTypeColPrefix(String parentType) {
  final tableName = getTableName(parentType);

// If the document is not in the trx tables, the table name is the column prefix
  final colName = switch (tableName.toLowerCase()) {
    "trx" => "doc",
    _ => tableName,
  };

  return colName;
}

// Since the trx_hdr table only uses the trx_no as a primary key, the join condition is different from other tables
// which use the document number and document type as primary keys

// Return is preceded by "JOIN" in the SQL statement
String getReceiptDataJoinCondition(String parentType) {
  final tableName = getTableName(parentType);
  bool isTrx = tableName.toLowerCase() == "trx";
  // It should be either:
  // - For non-trx tables documents: ON h.parentType_type = d.parentType_type AND h.parentType_no = d.parentType_no
  // - For trx tables documents: ON h.trx_no = d.trx_no
  String nonTrxJoinCondition = '''h.${tableName}_type = d.${tableName}_type 
                                    AND h.${tableName}_no = d.${tableName}_no''';
  String trxJoinCondition = "h.trx_no = d.trx_no";

  return isTrx ? trxJoinCondition : nonTrxJoinCondition;
}
