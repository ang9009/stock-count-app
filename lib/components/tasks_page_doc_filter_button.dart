import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/components/bottom_drawer.dart';
import 'package:stock_count/components/labelled_checkbox.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/providers/task_list/task_list_provider.dart';

class TasksPageDocFilterButton extends ConsumerStatefulWidget {
  const TasksPageDocFilterButton({
    super.key,
  });

  @override
  ConsumerState<TasksPageDocFilterButton> createState() =>
      _TasksPageDocFilterButtonState();
}

class _TasksPageDocFilterButtonState
    extends ConsumerState<TasksPageDocFilterButton> {
  String? bottomSheetSelectedFilter;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final docTypes = ref.watch(docTypeFilterOptionsProvider);

    if (docTypes.hasValue) {
      return ActionChip(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide.none,
        color: MaterialStatePropertyAll(
          Theme.of(context).colorScheme.tertiary,
        ),
        labelPadding: WidgetSizes.actionChipLabelPadding,
        avatar: SvgPicture.asset(
          height: 13.sp,
          "icons/filter.svg",
          colorFilter: const ColorFilter.mode(
            Colors.black,
            BlendMode.srcIn,
          ),
        ),
        label: const Text("Filter"),
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
        onPressed: () {
          if (docTypes.value!.length <= 1) {
            const msg = SnackBar(content: Text("Insufficient document types"));

            ScaffoldMessenger.of(context).showSnackBar(msg);
            return;
          }

          showModal(docTypes);
        },
      );
    } else if (docTypes.hasError) {
      // ! Change later
      return const SizedBox.shrink();
    }

    return const SizedBox.shrink();
  }

  void showModal(AsyncValue<List<String>> docTypes) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomDrawer(
          title: "Filter by",
          contents: SizedBox(
            width: double.infinity,
            // Height of 4 rows of options + height of 3 SizedBoxes (separators2)
            height: 24 * 4 + 25 * 3,
            child: StatefulBuilder(
              builder: (context, setState) {
                return ListView.separated(
                  itemCount: docTypes.value!.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 25),
                  itemBuilder: (context, index) {
                    // Ref: https://stackoverflow.com/questions/56530043/how-to-setstate-inside-showmodalbottomsheet

                    // Since this BottomDrawer is apparently not considered as a part of the this
                    // widget when showModalBottomSheet is called, using setState to update the list of checkboxes
                    // will not work, which is why a StatefulBuilder is needed
                    String currSortOption = docTypes.value![index];

                    return LabelledCheckbox(
                      label: currSortOption,
                      value: currSortOption == bottomSheetSelectedFilter,
                      onChanged: () {
                        if (bottomSheetSelectedFilter == currSortOption) {
                          setState(() {
                            bottomSheetSelectedFilter = null;
                          });
                        } else {
                          setState(() {
                            bottomSheetSelectedFilter = currSortOption;
                          });
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    ).whenComplete(() {
      ref.read(selectedTaskDocFilter.notifier).state =
          bottomSheetSelectedFilter;
    });
  }
}
