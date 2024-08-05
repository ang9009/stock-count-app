import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/api/services/api_service.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/pages/home_page.dart';
import 'package:stock_count/utils/helpers/local_db_helper.dart';
import 'package:stock_count/utils/queries/stock_count_control_is_populated.dart';

void main() async {
  Widget startupApp = const MyApp();

  try {
    await LocalDatabaseHelper.instance.database; // Initialize local db
    final loginRes = await ApiService.getAppInfo(null);

    bool isPopulated = await stockCountControlIsPopulated();
    if (!isPopulated && (loginRes.isError || loginRes.isNoNetwork)) {
      throw ErrorDescription(
        "this app requires an internet connection to download initial data. Please connect to a WiFi network and try again.",
      );
    }

    // Download data from server on every startup
  } catch (err) {
    startupApp = StartupError(
      errorMsg: "A startup error occurred: ${err.toString()}",
    );
  }

  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

class StartupError extends StatelessWidget {
  final String errorMsg;

  const StartupError({super.key, required this.errorMsg});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(errorMsg),
            ],
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (p0, p1, p2) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: PrimaryTheme().themeData,
          home: const Center(
            child: HomePage(),
          ),
        );
      },
    );
  }
}
