import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stock_count/utils/helpers/local_database_helper.dart';

Future<void> setApiUrl(String url) async {
  Database localDb = await LocalDatabaseHelper.instance.database;

  try {
    await localDb.rawUpdate("UPDATE settings SET api_url = '$url'");
  } catch (err) {
    throw ErrorDescription(
      "An error occurred whilst trying to set the API url: ${err.toString()}",
    );
  }
}
