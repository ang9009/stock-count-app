import 'package:flutter_riverpod/flutter_riverpod.dart';

final binNumberProvider = StateProvider<String?>((ref) {
  return null;
});

final docDataProvider =
    StateProvider<({String? docNo, String? docType})>((ref) {
  return (docNo: null, docType: null);
});
