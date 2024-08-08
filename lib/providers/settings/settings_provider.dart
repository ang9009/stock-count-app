// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:stock_count/utils/object_classes.dart';

// part 'settings_provider.g.dart';

// @riverpod
// class Settings extends _$Settings {
//   @override
//   Future<AppSettings> build() async {
//     Database localDb = await LocalDatabaseHelper.instance.database;
//     final AppSettings settings;

//     try {
//       final settingsData = localDb.rawQuery("SELECT * FROM settings");
      // settings = AppSettings(
      //   apiUrl: settingsData["a"],
      //   enableSerial: enableSerial,
      //   enableBin: enableBin,
      //   deviceId: deviceId,
      //   counterNum: counterNum,
      // );
//     } catch (err) {
//       return Future.error(
//         "There was an error retrieving app settings: ${err.toString()}",
//       );
//     }
//   }
// }
