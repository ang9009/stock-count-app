import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/components/ui/error_snackbar.dart';
import 'package:stock_count/components/ui/rounded_button.dart';
import 'package:stock_count/components/ui/text_input.dart';
import 'package:stock_count/pages/login_page.dart';
import 'package:stock_count/utils/queries/initialize_settings.dart';

class SettingsSetupPage extends StatefulWidget {
  const SettingsSetupPage({super.key});

  @override
  State<SettingsSetupPage> createState() => _SettingsSetupPageState();
}

class _SettingsSetupPageState extends State<SettingsSetupPage> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Set up device ID",
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
                controller: _controller,
                hint: "Enter device ID",
                heading: "Device ID",
              ),
              const Spacer(),
              RoundedButton(
                style: RoundedButtonStyles.solid,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final deviceId = _controller.text;
                      await initializeSettings(deviceId);
                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const LoginPage(),
                          ),
                        );
                      }
                    } catch (err) {
                      if (context.mounted) {
                        showErrorSnackbar(context, err.toString());
                      }
                    }
                  }
                },
                label: "Confirm",
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
