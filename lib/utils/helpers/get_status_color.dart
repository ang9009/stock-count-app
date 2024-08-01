import 'package:flutter/material.dart';
import 'package:stock_count/data/primary_theme.dart';

Color getStatusColor(double completionPercentage) {
  if (completionPercentage < 0.5) {
    return AppColors.warning;
  } else if (completionPercentage < 1) {
    return AppColors.progress;
  } else {
    return AppColors.success;
  }
}
