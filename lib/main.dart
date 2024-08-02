import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/api/services/api_service.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/pages/home_page.dart';

void main() async {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );

  try {
    ApiService.getAppInfo(null);
  } catch (err) {
    debugPrint("A startup error occurred in main: ${err.toString()}");
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
