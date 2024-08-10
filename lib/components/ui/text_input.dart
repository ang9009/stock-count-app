import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/data/primary_theme.dart';

class TextInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool? isPassword;
  final bool? autofocus;
  final String? heading;
  final String? Function(String)? extraValidator;
  final Function()? onChanged;
  final Widget? suffixIcon;

  const TextInput({
    super.key,
    required this.controller,
    required this.hint,
    this.heading,
    this.extraValidator,
    this.onChanged,
    this.suffixIcon,
    this.isPassword,
    this.autofocus,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (heading != null)
          Column(
            children: [
              Text(
                heading!,
                style: AppTextStyles.heading,
              ),
              SizedBox(height: 12.sp),
            ],
          ),
        TextFormField(
          autofocus: autofocus ?? false,
          obscureText: isPassword ?? false,
          onChanged: (value) {
            if (onChanged != null) onChanged!();
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }

            if (extraValidator != null) {
              String? msg = extraValidator!(value);
              return msg;
            }

            return null;
          },
          controller: controller,
          style: const TextStyle(
            color: Colors.black,
          ),
          decoration: InputDecoration(
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: AppColors.warning,
              ),
            ),
            suffixIcon: Padding(
              padding: EdgeInsets.only(
                right: 14.sp,
              ),
              child: suffixIcon,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: AppColors.borderColor,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: AppColors.warning,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: AppColors.lighterTextColor,
              ),
            ),
            suffixIconConstraints: BoxConstraints(
              maxHeight: 18.sp,
            ),
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 16.sp,
              color: AppColors.lighterTextColor,
            ),
          ),
        ),
      ],
    );
  }
}
