import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/components/ui/rounded_button.dart';
import 'package:stock_count/components/ui/show_error_snackbar.dart';
import 'package:stock_count/components/ui/show_modal.dart';
import 'package:stock_count/components/ui/text_input.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/providers/settings/settings_provider.dart';
import 'package:stock_count/utils/helpers/test_connection.dart';
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

  final TextEditingController _deviceIdFieldController =
      TextEditingController();
  final _deviceIdFormKey = GlobalKey<FormState>();

  final TextEditingController _counterNumberFieldController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _apiUrlFieldController.dispose();
    _deviceIdFieldController.dispose();
    _counterNumberFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<SettingsData> settings = ref.watch(settingsProvider);
    ref.listen(settingsProvider, (_, settingsData) {
      if (settingsData.hasValue) {
        setState(() {
          _apiUrlFieldController.text = settingsData.requireValue.apiUrl;
          _deviceIdFieldController.text = settingsData.requireValue.deviceId;
          _counterNumberFieldController.text =
              settingsData.requireValue.counterNum;
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
          AsyncData(:final value) => Column(
              children: [
                SettingsRow(
                  value: SettingsTextInput(
                    onTap: () {
                      openEditApiUrlModal();
                    },
                    fieldController: _apiUrlFieldController,
                  ),
                  label: "API url",
                ),
                const Divider(color: AppColors.borderColor),
                SettingsRow(
                  value: SettingsTextInput(
                    onTap: () {
                      openEditDeviceIdModal(value.deviceId);
                    },
                    fieldController: _deviceIdFieldController,
                  ),
                  label: "Device ID",
                ),
                const Divider(color: AppColors.borderColor),
                SettingsRow(
                  value: Text(
                    value.counterNum,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.lighterTextColor,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  label: "Counter number",
                ),
                const Divider(color: AppColors.borderColor),
                SettingsRow(
                  value: Switch(
                    activeColor: Colors.white,
                    activeTrackColor: AppColors.success,
                    inactiveTrackColor: AppColors.borderColor,
                    trackOutlineColor: MaterialStateProperty.resolveWith(
                      (final Set<MaterialState> states) {
                        return Colors.transparent;
                      },
                    ),
                    inactiveThumbColor: Colors.white,
                    value: value.enableSerial,
                    onChanged: (value) {
                      ref
                          .read(settingsProvider.notifier)
                          .setEnableSerial(value)
                          .onError(
                        (error, stackTrace) {
                          showErrorSnackbar(context, error.toString());
                        },
                      );
                    },
                  ),
                  label: "Enable serial no. checking",
                ),
                const Divider(color: AppColors.borderColor),
                SettingsRow(
                  value: Switch(
                    activeColor: Colors.white,
                    activeTrackColor: AppColors.success,
                    inactiveTrackColor: AppColors.borderColor,
                    trackOutlineColor: MaterialStateProperty.resolveWith(
                      (final Set<MaterialState> states) {
                        return Colors.transparent;
                      },
                    ),
                    inactiveThumbColor: Colors.white,
                    value: value.enableBin,
                    onChanged: (value) {
                      ref
                          .read(settingsProvider.notifier)
                          .setEnableBin(value)
                          .onError(
                        (error, stackTrace) {
                          showErrorSnackbar(context, error.toString());
                        },
                      );
                    },
                  ),
                  label: "Enable BIN no.",
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

  void openEditDeviceIdModal(String currDeviceId) {
    showModal(
      onCloseCallback: () {
        ref.invalidate(settingsProvider);
      },
      context: context,
      title: "Edit device ID",
      content: Form(
        key: _deviceIdFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextInput(
              autofocus: true,
              controller: _deviceIdFieldController,
              hint: "Enter new device ID",
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
                      if (_deviceIdFormKey.currentState!.validate()) {
                        final deviceId = _deviceIdFieldController.text;
                        ref
                            .read(settingsProvider.notifier)
                            .setDeviceId(deviceId)
                            .onError(
                          (err, stackTrace) {
                            if (mounted) {
                              showErrorSnackbar(context, err.toString());
                            }
                          },
                        );

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
                      await testConnection(
                        _apiUrlFieldController.text,
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
                        final newUrl = _apiUrlFieldController.text;
                        ref
                            .read(settingsProvider.notifier)
                            .setApiUrl(newUrl)
                            .onError(
                          (err, _) {
                            if (mounted) {
                              showErrorSnackbar(context, err.toString());
                            }
                          },
                        );

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
}

class SettingsTextInput extends StatefulWidget {
  final TextEditingController fieldController;
  final Function onTap;

  const SettingsTextInput({
    super.key,
    required this.fieldController,
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
          color: AppColors.lighterTextColor,
        ),
        decoration: InputDecoration(
          suffixIcon: SvgPicture.asset(
            "assets/icons/edit.svg",
            width: 12.sp,
            height: 12.sp,
            fit: BoxFit.scaleDown,
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
        ),
      ),
    );
  }
}

class SettingsRow extends StatelessWidget {
  final String label;
  final Widget value;

  const SettingsRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30.sp,
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
                child: Align(
                  alignment: Alignment.centerRight,
                  child: value,
                ),
              ),
            ],
          ),
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
