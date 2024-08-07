import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/api/services/api_service.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/pages/login_page.dart';
import 'package:stock_count/pages/settings_setup_page.dart';
import 'package:stock_count/utils/helpers/local_database_helper.dart';
import 'package:stock_count/utils/queries/download_stock_count_control.dart';
import 'package:stock_count/utils/queries/settings_is_populated.dart';
import 'package:stock_count/utils/queries/stock_count_control_is_populated.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late String? errorMsg;

  @override
  void initState() {
    errorMsg = null;

    initializeApp();
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
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
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

  Future<void> initializeApp() async {
    try {
      await LocalDatabaseHelper.instance.database; // Initialize local db
      final loginRes = await ApiService.login(null);

      bool stockCountCtrlIsPopulated = await getStockCountControlIsPopulated();
      if (!stockCountCtrlIsPopulated &&
          (loginRes.isError || loginRes.isNoNetwork)) {
        throw ErrorDescription(
          "this app requires an internet connection to download initial data. Please connect to a WiFi network and try again.",
        );
      } else {
        await downloadStockCountControl();
      }

      bool settingsIsSetup = await getSettingsIsPopulated();
      if (!settingsIsSetup && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const SettingsSetupPage(),
          ),
        );
      } else if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const LoginPage(),
          ),
        );
      }
    } catch (err) {
      setState(() {
        errorMsg = err.toString();
      });
    }
  }
}
