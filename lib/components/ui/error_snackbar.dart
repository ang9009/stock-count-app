import 'package:flutter/material.dart';
import 'package:stock_count/data/primary_theme.dart';

void showErrorSnackbar(BuildContext context, String msg) {
  final snackbar = SnackBar(
    content: Text(msg),
    backgroundColor: AppColors.warning,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}
