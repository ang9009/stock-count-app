import 'package:stock_count/api/services/api_service.dart';
import 'package:stock_count/api/services/web_service.dart';
import 'package:stock_count/utils/object_classes.dart';

Future<List<ReceiptDocTypeFilterOption>> getDocTypeOptions() async {
  ApiResponse res;

  try {
    res = await ApiService.executeSQLQuery(
      null,
      [
        ApiService.sqlQueryParm(
          '''SELECT DISTINCT doc_desc, parent_type
             FROM stock_count_control
             WHERE need_ref_no = 'Y';''',
        ),
      ],
    );
  } catch (err) {
    return Future.error("An unexpected error occurred: ${err.toString()}");
  }

  final resData = ApiService.sqlQueryResult(res);
  final options = resData
      .map(
        (optionData) => ReceiptDocTypeFilterOption(
          docDesc: optionData["doc_desc"].toString(),
          parentType: optionData["parent_type"].toString(),
        ),
      )
      .toList();

  return options;
}
