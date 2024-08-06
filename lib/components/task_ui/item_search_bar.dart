import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stock_count/data/primary_theme.dart';

class TasksSearchBar extends StatefulWidget {
  const TasksSearchBar({
    super.key,
  });

  @override
  State<TasksSearchBar> createState() => _TasksSearchBarState();
}

class _TasksSearchBarState extends State<TasksSearchBar> {
  final inputController = TextEditingController();
  var showClearBtn = false;

  @override
  void initState() {
    super.initState();
    inputController.addListener(_inputControllerListener);
  }

  void _inputControllerListener() {
    if (inputController.text.isNotEmpty && !showClearBtn) {
      setState(() {
        showClearBtn = true;
      });
    } else if (inputController.text.isEmpty && showClearBtn) {
      setState(() {
        showClearBtn = false;
      });
    }
  }

  @override
  void dispose() {
    inputController.removeListener(_inputControllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: inputController,
      trailing: showClearBtn
          ? [
              IconButton(
                onPressed: () => inputController.clear(),
                icon: const Icon(
                  Icons.close,
                  color: AppColors.lighterTextColor,
                ),
              ),
            ]
          : [],
      leading: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
        child: SvgPicture.asset(
          height: 17,
          "assets/icons/search.svg",
          colorFilter: const ColorFilter.mode(
            AppColors.lighterTextColor,
            BlendMode.srcIn,
          ),
        ),
      ),
      hintText: "Search...",
      hintStyle: MaterialStatePropertyAll(
        Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
