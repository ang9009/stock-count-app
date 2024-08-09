import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/api/services/api_service.dart';
import 'package:stock_count/components/ui/rounded_button.dart';
import 'package:stock_count/components/ui/show_error_snackbar.dart';
import 'package:stock_count/components/ui/text_input.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/pages/login_page.dart';
import 'package:stock_count/utils/helpers/show_loading_overlay.dart';
import 'package:stock_count/utils/queries/download_stock_count_control.dart';
import 'package:stock_count/utils/queries/initialize_settings.dart';

class SettingsSetupPage extends StatefulWidget {
  const SettingsSetupPage({super.key});

  @override
  State<SettingsSetupPage> createState() => _SettingsSetupPageState();
}

class _SettingsSetupPageState extends State<SettingsSetupPage> {
  final TextEditingController _deviceIdController = TextEditingController();
  final TextEditingController _apiUrlController = TextEditingController();
  bool _apiUrlWorks = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> testConnection() async {
    final apiUrl = _apiUrlController.text;
    final res =
        await ApiService.testConnection(context: context, apiUrl: apiUrl);
    if (res.isError || res.isNoNetwork) {
      setState(() {
        _apiUrlWorks = false;
      });
    } else {
      setState(() {
        _apiUrlWorks = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Set up device",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.sp,
          vertical: 20.sp,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextInput(
                controller: _deviceIdController,
                hint: "Enter device ID",
                heading: "Device ID",
              ),
              SizedBox(height: 24.sp),
              TextInput(
                suffixIcon: _apiUrlWorks
                    ? SvgPicture.asset(
                        height: 13.sp,
                        "assets/icons/check.svg",
                        colorFilter: const ColorFilter.mode(
                          AppColors.success,
                          BlendMode.srcIn,
                        ),
                      )
                    : SvgPicture.asset(
                        height: 17.sp,
                        "assets/icons/clear.svg",
                        colorFilter: const ColorFilter.mode(
                          AppColors.warning,
                          BlendMode.srcIn,
                        ),
                      ),
                onChanged: () {
                  if (_apiUrlWorks) {
                    setState(() {
                      _apiUrlWorks = false;
                    });
                  }
                },
                controller: _apiUrlController,
                hint: "Enter API url",
                heading: "API url",
                extraValidator: (input) {
                  if (_apiUrlWorks) return null;
                  return "API url is invalid";
                },
              ),
              SizedBox(height: 17.sp),
              RoundedButton(
                style: RoundedButtonStyles.outlined,
                onPressed: () async {
                  await testConnection();
                  _formKey.currentState!.validate();
                },
                label: "Test connection",
              ),
              SizedBox(height: 16.sp),
              const Spacer(),
              RoundedButton(
                style: RoundedButtonStyles.solid,
                onPressed: () async {
                  await submitForm();
                },
                label: "Confirm",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitForm() async {
    await testConnection();

    if (_formKey.currentState!.validate()) {
      if (mounted) showLoadingOverlay(context);
      try {
        final deviceId = _deviceIdController.text;
        final apiUrl = _apiUrlController.text;
        await initializeSettings(
          deviceId: deviceId,
          apiUrl: apiUrl,
        );

        final loginRes = await ApiService.login(null);
        if ((loginRes.isError || loginRes.isNoNetwork)) {
          throw ErrorDescription(
            "Could not connect to server. Please make sure that you are connected to a WiFi network.",
          );
        } else {
          await downloadStockCountControl();
        }

        if (mounted) {
          // Get rid of loading overlay
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const LoginPage(),
            ),
          );
        }
      } catch (err) {
        if (mounted) {
          // Get rid of loading overlay
          Navigator.pop(context);
          showErrorSnackbar(context, err.toString());
        }
      }
    }
  }

  @override
  void dispose() {
    _deviceIdController.dispose();
    _apiUrlController.dispose();
    super.dispose();
  }
}
