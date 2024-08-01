import 'package:flutter/material.dart';

void showSnackbar(String msg, BuildContext context) {
  final snackbar = SnackBar(content: Text(msg));
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}
