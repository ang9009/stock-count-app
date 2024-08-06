import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/api/services/api_service.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/pages/home_page.dart';
import 'package:stock_count/utils/helpers/local_database_helper.dart';
import 'package:stock_count/utils/queries/download_stock_count_control.dart';
import 'package:stock_count/utils/queries/stock_count_control_is_populated.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late String? errorMsg;

  Future<void> loadDbAndLogin() async {
    try {
      await LocalDatabaseHelper.instance.database; // Initialize local db
      // !Currently, this gets stuck if the server is not on/network is not on
      final loginRes = await ApiService.getAppInfo(null);

      bool isPopulated = await stockCountControlIsPopulated();
      if (!isPopulated && (loginRes.isError || loginRes.isNoNetwork)) {
        throw ErrorDescription(
          "this app requires an internet connection to download initial data. Please connect to a WiFi network and try again.",
        );
      } else {
        await downloadStockCountControl();
      }
    } catch (err) {
      return Future.error("A startup error occurred: ${err.toString()}");
    }
  }

  @override
  void initState() {
    errorMsg = null;

    loadDbAndLogin().then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const HomePage(),
        ),
      );
    }).catchError((err) {
      log("Error caught");

      setState(() {
        errorMsg = err.toString();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Adaptive.w(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                "assets/images/boss_logo.png",
                width: Adaptive.w(80),
                height: Adaptive.h(20),
                fit: BoxFit.cover,
              ),
            ),
            if (errorMsg != null)
              Text(
                errorMsg!,
                style: TextStyles.subHeading,
                textAlign: TextAlign.center,
              )
            else
              LoadingAnimationWidget.waveDots(
                color: AppColors.lighterTextColor,
                size: Adaptive.w(10),
              ),
          ],
        ),
      ),
    );
  }
}
