import 'package:flutter/material.dart';

void showLoadingOverlay(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    },
  );
}
