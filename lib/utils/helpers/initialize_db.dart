import 'dart:developer';

import 'package:sqflite/sqflite.dart';

// Used to get database for function calls and setup database on app start
Future<Database> initializeDatabase() async {
  final dbPath = await getDatabasesPath();
  String path = "${dbPath}stock_count.db";

  Database localDb =
      await openDatabase(path, version: 1, onCreate: onCreate, onOpen: onOpen);
  return localDb;
}

Future<Database> getDatabase() async {
  final dbPath = await getDatabasesPath();
  String path = "${dbPath}stock_count.db";

  Database localDb = await openDatabase(path);
  return localDb;
}

void onOpen(Database localDb) async {
  // Foreign keys are disabled by default, so this is necessary
  await localDb.execute("PRAGMA foreign_keys=ON");
}

void onCreate(Database localDb, int version) async {
  log("Initializing db");
  const createTaskTable = '''CREATE TABLE task (
    doc_no NVARCHAR(15) NOT NULL,
    doc_type NVARCHAR(4) NOT NULL,
    trx_no VARCHAR(255) NOT NULL,
    last_updated DATETIME DEFAULT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (doc_no, doc_type)
)''';

  const createTaskItemTable = '''CREATE TABLE task_item (
	  doc_type NVARCHAR(4) NOT NULL,
    doc_no NVARCHAR(15) NOT NULL,
    item_code NVARCHAR(15) NOT NULL,
    item_name NVARCHAR(40),
    item_barcode NVARCHAR(50),
    lot_no NVARCHAR(50),
    bin_no NVARCHAR(50),
    qty_required INT NOT NULL DEFAULT 0,
    qty_collected INT NOT NULL DEFAULT 0,
    FOREIGN KEY (doc_no, doc_type)
        REFERENCES task(doc_no, doc_type)
        ON DELETE CASCADE
)''';

  const createBarcodeTable = '''CREATE TABLE item_barcode (
    item_barcode NVARCHAR(50),
    item_code NVARCHAR(15) NOT NULL,
    PRIMARY KEY (item_barcode)
  )''';

  const createTaskDeleteTrigger = '''CREATE TRIGGER delete_related_item_barcodes
  AFTER DELETE ON task_item
  FOR EACH ROW
BEGIN
    DELETE FROM item_barcode
    WHERE  item_barcode.item_code = OLD.item_code
           AND NOT EXISTS(SELECT item_code
                          FROM   task_item
                          WHERE  task_item.item_code = OLD.item_code);
END;''';

  final queries = [
    createTaskTable,
    createBarcodeTable,
    createTaskItemTable,
    createTaskDeleteTrigger
  ];

  for (final query in queries) {
    await localDb.execute(query);
  }
}
