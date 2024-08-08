import 'package:sqflite/sqflite.dart';
import 'package:stock_count/utils/helpers/local_database_helper.dart';

class Config {
  Config._privateConstructor();
  static final Config instance = Config._privateConstructor();

  Future<String> get apiUrl async {
    Database localDb = await LocalDatabaseHelper.instance.database;
    String apiUrl;
    try {
      final apiUrlData = await localDb.rawQuery("SELECT api_url FROM settings");
      apiUrl = apiUrlData.first["api_url"].toString();
    } catch (err) {
      return Future.error(
        "Tried to access api url before instantiation: ${err.toString()}",
      );
    }

    return apiUrl;
  }

  static const String serviceFilePath = "CustomFiles";

  static String localFilePath = "";
}
