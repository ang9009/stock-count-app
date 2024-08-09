import 'package:flutter/material.dart';
import 'package:stock_count/api/services/api_service.dart';

Future<bool> testConnection(String apiUrl, BuildContext context) async {
  try {
    final res =
        await ApiService.testConnection(context: context, apiUrl: apiUrl);
    if (res.isError || res.isNoNetwork) {
      return false;
    } else {
      return true;
    }
  } catch (err) {
    return false;
  }
}
