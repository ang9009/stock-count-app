import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stock_count/utils/helpers/local_database_helper.dart';

Future<String> getCurrTransactionNumber() async {
  Database localDb = await LocalDatabaseHelper.instance.database;
  final deviceIdRes = await localDb.rawQuery("SELECT device_id FROM settings");
  final counterNumRes =
      await localDb.rawQuery("SELECT counter_no FROM settings");

  String deviceId = deviceIdRes[0]["device_id"].toString();
  String counterNum = counterNumRes[0]["counter_no"].toString();

  if (counterNum.length > 6) {
    throw ErrorDescription("counter number is more than 6 digits long");
  }

  // The numeric portion of the transaction number should be at most 6 characters long
  String numeric = counterNum.padLeft(6, '0');

  return deviceId + numeric;
}
