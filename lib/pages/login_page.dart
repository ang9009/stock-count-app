import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/api/utility.dart';
import 'package:stock_count/components/ui/error_snackbar.dart';
import 'package:stock_count/components/ui/rounded_button.dart';
import 'package:stock_count/components/ui/text_input.dart';
import 'package:stock_count/pages/home_page.dart';
import 'package:stock_count/utils/helpers/go_to_route.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _shopCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Login",
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
                heading: "Username",
                controller: _usernameController,
                hint: "Enter username...",
              ),
              SizedBox(height: 24.sp),
              TextInput(
                heading: "Password",
                controller: _passwordController,
                hint: "Enter password...",
              ),
              SizedBox(height: 24.sp),
              TextInput(
                heading: "Shop code",
                controller: _shopCodeController,
                hint: "Enter shop code...",
              ),
              const Spacer(),
              RoundedButton(
                style: RoundedButtonStyles.solid,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final String username = _usernameController.text.trim();
                    final String password = _passwordController.text.trim();
                    final String shopCode = _shopCodeController.text.trim();

                    try {
                      String err =
                          await Utility.login(username, password, shopCode);
                      if (err.isNotEmpty && context.mounted) {
                        showErrorSnackbar(context, err.toString());
                      } else {
                        Navigator.of(context).pushReplacement(
                          createRouteAndSlideIn(const HomePage()),
                        );
                      }
                    } catch (err) {
                      if (context.mounted) {
                        showErrorSnackbar(context, err.toString());
                      }
                    }
                  }
                },
                label: "Log in",
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _shopCodeController.dispose();
    super.dispose();
  }
}
