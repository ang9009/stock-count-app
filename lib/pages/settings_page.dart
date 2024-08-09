import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/api/services/api_service.dart';
import 'package:stock_count/components/ui/rounded_button.dart';
import 'package:stock_count/components/ui/show_error_snackbar.dart';
import 'package:stock_count/components/ui/show_modal.dart';
import 'package:stock_count/components/ui/text_input.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/providers/settings/settings_provider.dart';
import 'package:stock_count/utils/object_classes.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final TextEditingController _apiUrlFieldController = TextEditingController();
  final _apiUrlFormKey = GlobalKey<FormState>();
  bool _apiUrlWorks = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _apiUrlFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<SettingsData> settings = ref.watch(settingsProvider);
    ref.listen(settingsProvider, (_, settingsData) {
      if (settingsData.hasValue) {
        setState(() {
          _apiUrlFieldController.text = settingsData.requireValue.apiUrl;
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: switch (settings) {
          AsyncData() => Column(
              children: [
                const IconHeading(
                  title: "Data",
                  iconPath: "assets/icons/data.svg",
                ),
                SizedBox(height: 12.sp),
                SettingsRow(
                  input: SettingsTextInput(
                    onTap: () {
                      openEditApiUrlModal();
                    },
                    fieldController: _apiUrlFieldController,
                    hintText: "Enter API url...",
                  ),
                  label: "API ",
                ),
              ],
            ),
          AsyncError() => Text(
              "An unexpected error occurred: ${settings.error.toString()}",
              style: TextStyles.subHeading,
            ),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }

  void openEditApiUrlModal() {
    showModal(
      onCloseCallback: () {
        ref.invalidate(settingsProvider);
      },
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
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: RoundedButton(
                    style: RoundedButtonStyles.outlined,
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    label: "Cancel",
                  ),
                ),
                SizedBox(width: 15.sp),
                Expanded(
                  child: RoundedButton(
                    style: RoundedButtonStyles.solid,
                    onPressed: () async {
                      // This function sets external state (_apiUrlWorks) because async functions
                      // are not allowed into the validator function of the text input
                      await testConnection();
                      if (_apiUrlFormKey.currentState!.validate()) {
                        final newUrl = _apiUrlFieldController.text;
                        try {
                          ref.read(settingsProvider.notifier).setApiUrl(newUrl);
                        } catch (err) {
                          if (mounted) {
                            showErrorSnackbar(context, err.toString());
                          }
                        }

                        if (mounted) {
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    label: "Confirm",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> testConnection() async {
    final apiUrl = _apiUrlFieldController.text;
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
}

class SettingsTextInput extends StatefulWidget {
  final TextEditingController fieldController;
  final String hintText;
  final Function onTap;

  const SettingsTextInput({
    super.key,
    required this.fieldController,
    required this.hintText,
    required this.onTap,
  });

  @override
  State<SettingsTextInput> createState() => _SettingsTextInputState();
}

class _SettingsTextInputState extends State<SettingsTextInput> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: TextField(
        readOnly: true,
        enabled: false,
        controller: widget.fieldController,
        textAlign: TextAlign.right,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: Colors.black,
        cursorErrorColor: AppColors.warning,
        style: TextStyle(
          fontSize: 16.sp,
        ),
        decoration: InputDecoration(
          suffixIcon: SvgPicture.asset(
            "assets/icons/edit.svg",
            fit: BoxFit.scaleDown,
            height: 14.sp,
            colorFilter: const ColorFilter.mode(
              AppColors.lighterTextColor,
              BlendMode.srcIn,
            ),
          ),
          isDense: true,
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(
            bottom: 14.sp / 2,
          ),
          hintStyle: TextStyle(
            color: AppColors.lighterTextColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.normal,
          ),
          hintText: widget.hintText,
        ),
      ),
    );
  }
}

class SettingsRow extends StatelessWidget {
  final String label;
  final Widget input;

  const SettingsRow({
    super.key,
    required this.label,
    required this.input,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(width: 13.sp),
              Expanded(
                child: input,
              ),
            ],
          ),
        ),
        const Divider(
          color: AppColors.borderColor,
          height: 0,
        ),
      ],
    );
  }
}

class IconHeading extends StatelessWidget {
  final String iconPath;
  final String title;

  const IconHeading({
    super.key,
    required this.iconPath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          width: 16.sp,
          iconPath,
          colorFilter: const ColorFilter.mode(
            Colors.black,
            BlendMode.srcIn,
          ),
        ),
        SizedBox(width: 12.sp),
        Text(
          title,
          style: TextStyles.heading,
        ),
      ],
    );
  }
}
