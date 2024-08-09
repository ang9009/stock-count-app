import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stock_count/utils/helpers/local_database_helper.dart';
import 'package:stock_count/utils/object_classes.dart';

part 'settings_provider.g.dart';

@riverpod
class Settings extends _$Settings {
  @override
  Future<SettingsData> build() async {
    Database localDb = await LocalDatabaseHelper.instance.database;
    final SettingsData settings;

    try {
      final settingsData = await localDb.rawQuery("SELECT * FROM settings");
      settings = SettingsData(
        apiUrl: settingsData[0]["api_url"].toString(),
        enableSerial: settingsData[0]["enable_serial"] as int == 1,
        enableBin: settingsData[0]["enable_bin"] as int == 1,
        deviceId: settingsData[0]["device_id"].toString(),
        counterNum: settingsData[0]["counter_no"].toString(),
      );
    } catch (err) {
      return Future.error(
        "There was an error retrieving app settings: ${err.toString()}",
      );
    }

    return settings;
  }

  Future<void> setEnableBin(bool isEnabled) async {
    Database localDb = await LocalDatabaseHelper.instance.database;

    try {
      final fieldVal = isEnabled ? 1 : 0;
      await localDb.rawUpdate("UPDATE settings SET enable_bin = '$fieldVal'");
    } catch (err) {
      return Future.error(
        "There was an error retrieving app settings: ${err.toString()}",
      );
    }

    final currState = await future;
    state = AsyncData(
      SettingsData(
        apiUrl: currState.apiUrl,
        enableSerial: currState.enableSerial,
        enableBin: isEnabled,
        deviceId: currState.deviceId,
        counterNum: currState.counterNum,
      ),
    );
  }

  Future<void> setEnableSerial(bool isEnabled) async {
    Database localDb = await LocalDatabaseHelper.instance.database;

    try {
      final fieldVal = isEnabled ? 1 : 0;
      await localDb
          .rawUpdate("UPDATE settings SET enable_serial = '$fieldVal'");
    } catch (err) {
      return Future.error(
        "There was an error retrieving app settings: ${err.toString()}",
      );
    }

    final currState = await future;
    state = AsyncData(
      SettingsData(
        apiUrl: currState.apiUrl,
        enableSerial: isEnabled,
        enableBin: currState.enableBin,
        deviceId: currState.deviceId,
        counterNum: currState.counterNum,
      ),
    );
  }

  Future<void> setApiUrl(String url) async {
    Database localDb = await LocalDatabaseHelper.instance.database;

    try {
      await localDb.rawUpdate("UPDATE settings SET api_url = '$url'");
    } catch (err) {
      return Future.error(
        "An error occurred whilst trying to set the API url: ${err.toString()}",
      );
    }
    final currState = await future;
    state = AsyncData(
      SettingsData(
        apiUrl: url,
        enableSerial: currState.enableSerial,
        enableBin: currState.enableBin,
        deviceId: currState.deviceId,
        counterNum: currState.counterNum,
      ),
    );
  }

  Future<void> setDeviceId(String deviceId) async {
    Database localDb = await LocalDatabaseHelper.instance.database;
    bool taskTableHasItems;

    try {
      final itemCountData =
          await localDb.rawQuery("SELECT COUNT(*) AS count FROM task");
      final items = itemCountData[0]["count"];
      taskTableHasItems = items != 0;
    } catch (err) {
      return Future.error(
        "An error occurred whilst trying to set the API url: ${err.toString()}",
      );
    }

    if (taskTableHasItems) {
      return Future.error(
        "Error: device ID cannot be changed when the device still has saved tasks",
      );
    }

    try {
      await localDb.rawUpdate("UPDATE settings SET device_id = '$deviceId'");
    } catch (err) {
      return Future.error(
        "An error occurred whilst trying to set the API url: ${err.toString()}",
      );
    }

    final currState = await future;
    state = AsyncData(
      SettingsData(
        apiUrl: currState.apiUrl,
        enableSerial: currState.enableSerial,
        enableBin: currState.enableBin,
        deviceId: deviceId,
        counterNum: currState.counterNum,
      ),
    );
  }
}
