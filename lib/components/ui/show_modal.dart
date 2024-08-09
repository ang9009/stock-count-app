import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/data/primary_theme.dart';

void showModal({
  required BuildContext context,
  required String title,
  required Widget content,
  Function? onCloseCallback,
}) {
  final verticalPadding = 20.sp;
  final horizontalPadding = 20.sp;
  final dividerPadding = 24.sp;

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                verticalPadding,
                horizontalPadding,
                0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyles.largeTitle,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close, size: 20.sp),
                  )
                ],
              ),
            ),
            Divider(
              color: AppColors.borderColor,
              height: dividerPadding,
            ),
            SizedBox(height: 12.sp),
            Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                0,
                horizontalPadding,
                verticalPadding,
              ),
              child: content,
            ),
          ],
        ),
      );
    },
  ).then((value) {
    if (onCloseCallback != null) onCloseCallback();
  });
}
