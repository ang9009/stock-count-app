import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_page_provider.g.dart';

@riverpod
class CurrentPage extends _$CurrentPage {
  @override
  int build() {
    return 0;
  }

  void setCurrentPage(int pageIndex) {
    state = pageIndex;
  }
}
