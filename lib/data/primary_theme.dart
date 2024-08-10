import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AppColors {
  static const lighterTextColor = Color.fromRGBO(191, 193, 196, 1);
  static const borderColor = Color.fromRGBO(230, 232, 239, 1);
  static const success = Color.fromRGBO(202, 210, 77, 1);
  static const progress = Color.fromRGBO(74, 147, 255, 1);
  static const warning = Color.fromRGBO(237, 86, 86, 1);
}

class AppTextStyles {
  static final largeTitle = TextStyle(
    color: Colors.black,
    fontSize: 17.sp,
    fontFamily: "Inter",
    fontWeight: FontWeight.bold,
  );
  static final heading = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    fontFamily: "Inter",
  );
  static final subHeading = TextStyle(
    fontSize: 15.sp,
    fontFamily: "Inter",
    color: AppColors.lighterTextColor,
    fontWeight: FontWeight.w100,
  );
}

class WidgetSizes {
  static final appBarHeight = Adaptive.h(10);
  static final cardPadding = EdgeInsets.symmetric(
    horizontal: 16.sp,
    vertical: 15.sp,
  );
  static final overlayOptionButtonPadding = EdgeInsets.symmetric(
    horizontal: 12.sp,
    vertical: 15.sp,
  );
  static final actionChipLabelPadding = EdgeInsets.only(
    right: 10.sp,
  );
  static final bottomNavHeight = Adaptive.h(9);
  static final cardCheckboxMargin = 14.sp;
}

class PrimaryTheme {
  ThemeData themeData = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    fontFamily: "Inter",
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.black,
      secondary: AppColors.lighterTextColor,
      tertiary: AppColors.borderColor,
    ),
    cardTheme: const CardTheme(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
    ),
    chipTheme: ChipThemeData(
      selectedColor: Colors.black,
      showCheckmark: false,
      padding: EdgeInsets.symmetric(
        horizontal: 5.sp,
      ),
      labelStyle: TextStyle(
        fontSize: AppTextStyles.subHeading.fontSize,
        fontFamily: "Inter",
        fontWeight: FontWeight.bold,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(1000),
        ),
      ),
    ),
    searchBarTheme: const SearchBarThemeData(
      textStyle: MaterialStatePropertyAll(
        TextStyle(
          fontFamily: "Inter",
          fontSize: 16,
        ),
      ),
      elevation: MaterialStatePropertyAll(0),
      side: MaterialStatePropertyAll(
        BorderSide(
          color: AppColors.borderColor,
        ),
      ),
      hintStyle: MaterialStatePropertyAll(
        TextStyle(
          color: AppColors.lighterTextColor,
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      toolbarHeight: WidgetSizes.appBarHeight,
      titleSpacing: 16,
      scrolledUnderElevation: 0.0,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 18.sp,
        fontFamily: "Inter",
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
