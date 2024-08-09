import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/api/config.dart';
import 'package:stock_count/api/services/api_service.dart';
import 'package:stock_count/components/ui/rounded_button.dart';
import 'package:stock_count/components/ui/show_error_snackbar.dart';
import 'package:stock_count/components/ui/show_modal.dart';
import 'package:stock_count/components/ui/text_input.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/pages/login_page.dart';
import 'package:stock_count/pages/settings_setup_page.dart';
import 'package:stock_count/utils/helpers/local_database_helper.dart';
import 'package:stock_count/utils/helpers/set_api_url.dart';
import 'package:stock_count/utils/helpers/test_connection.dart';
import 'package:stock_count/utils/queries/download_stock_count_control.dart';
import 'package:stock_count/utils/queries/settings_is_populated.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late String? errorMsg;

  final TextEditingController _apiUrlFieldController = TextEditingController();
  final _apiUrlFormKey = GlobalKey<FormState>();
  bool _apiUrlWorks = false;

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
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: (errorMsg != null)
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: Adaptive.h(3)),
                  RoundedButton(
                    style: RoundedButtonStyles.outlined,
                    onPressed: () {
                      openEditApiUrlModal();
                    },
                    label: "Edit API url",
                  ),
                  SizedBox(height: Adaptive.h(1.4)),
                  RoundedButton(
                    style: RoundedButtonStyles.solid,
                    onPressed: () {
                      setState(() {
                        errorMsg = null;
                        initializeApp();
                      });
                    },
                    label: "Retry connection",
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Future<void> initializeApp() async {
    try {
      await LocalDatabaseHelper
          .instance.database; // Initialize local db singleton

      bool settingsIsSetup = await getSettingsIsPopulated();
      if (!settingsIsSetup && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const SettingsSetupPage(),
          ),
        );
        return;
      }

      // Re-downloads stock count control on every startup
      // If this has to be removed, please replace it with a check for whether or not stock count control is empty
      // If it is empty, then download it. If it cannot be downloaded, throw an error
      final loginRes = await ApiService.login(null);
      if (loginRes.isError ||
          loginRes.isNoNetwork ||
          loginRes.errMsg.isNotEmpty) {
        final apiUrl = await Config.instance.apiUrl;
        throw ErrorDescription(
          '''Could not connect to server. Please make sure that you are connected to a WiFi network. Current API url: $apiUrl''',
        );
      } else {
        await downloadStockCountControl();
      }

      if (mounted) {
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

  void openEditApiUrlModal() {
    showModal(
      context: context,
      title: "Edit API url",
      content: Form(
        key: _apiUrlFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextInput(
              autofocus: true,
              controller: _apiUrlFieldController,
              hint: "Enter new API URL",
              extraValidator: (_) {
                if (_apiUrlWorks) return null;
                return "API url is invalid";
              },
            ),
            SizedBox(height: 15.sp),
            RoundedButton(
              style: RoundedButtonStyles.solid,
              onPressed: () async {
                // This function sets external state (_apiUrlWorks) because async functions
                // are not allowed into the validator function of the text input
                final newUrl = _apiUrlFieldController.text;

                await testConnection(
                  newUrl,
                  context,
                ).then((urlIsValid) {
                  if (urlIsValid) {
                    setState(() {
                      _apiUrlWorks = true;
                    });
                  } else {
                    setState(() {
                      _apiUrlWorks = false;
                    });
                  }
                });

                if (_apiUrlFormKey.currentState!.validate()) {
                  try {
                    await setApiUrl(newUrl);
                  } catch (err) {
                    if (mounted) {
                      // Close modal
                      Navigator.of(context).pop();
                      showErrorSnackbar(context, err.toString());
                    }
                    return;
                  }

                  if (mounted) {
                    // Close modal
                    Navigator.of(context).pop();
                    setState(() {
                      errorMsg = null;
                      initializeApp();
                    });
                  }
                }
              },
              label: "Confirm and refresh",
            ),
          ],
        ),
      ),
    );
  }
}
