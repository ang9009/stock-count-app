import 'package:flutter/material.dart';

void showErrorSnackbar(BuildContext context, String msg) {
  final snackbar = SnackBar(
    content: Text(msg),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}
