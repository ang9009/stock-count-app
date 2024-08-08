import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/data/primary_theme.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final TextEditingController _apiUrlFieldController = TextEditingController();

  @override
  void initState() {
    _apiUrlFieldController.text = "asdfasdf";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const IconHeading(
              title: "Data",
              iconPath: "assets/icons/data.svg",
            ),
            SizedBox(height: 12.sp),
            SettingsRow(
              input: SettingsTextInput(
                fieldController: _apiUrlFieldController,
                hintText: "Enter API url...",
              ),
              label: "API ",
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsTextInput extends StatefulWidget {
  final TextEditingController fieldController;
  final String hintText;

  const SettingsTextInput({
    super.key,
    required this.fieldController,
    required this.hintText,
  });

  @override
  State<SettingsTextInput> createState() => _SettingsTextInputState();
}

class _SettingsTextInputState extends State<SettingsTextInput> {
  bool _apiUrlFieldIsFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (isFocused) {
        if (isFocused) {
          setState(() {
            _apiUrlFieldIsFocused = true;
          });
        } else {
          setState(() {
            _apiUrlFieldIsFocused = false;
          });
        }
      },
      child: TextField(
        controller: widget.fieldController,
        textAlign: TextAlign.right,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: Colors.black,
        cursorErrorColor: AppColors.warning,
        style: TextStyle(
          fontSize: 16.sp,
        ),
        decoration: InputDecoration(
          suffixIcon: _apiUrlFieldIsFocused
              ? GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      widget.fieldController.text = "";
                    });
                  },
                  child: SvgPicture.asset(
                    "assets/icons/clear.svg",
                    fit: BoxFit.scaleDown,
                    height: 12.sp,
                    colorFilter: const ColorFilter.mode(
                      AppColors.lighterTextColor,
                      BlendMode.srcIn,
                    ),
                  ),
                )
              : SvgPicture.asset(
                  "assets/icons/edit.svg",
                  fit: BoxFit.scaleDown,
                  height: 12.sp,
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
