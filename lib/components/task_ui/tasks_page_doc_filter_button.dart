import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/components/scanning/bottom_drawer.dart';
import 'package:stock_count/components/ui/labelled_checkbox.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/providers/task_list/task_list_providers.dart';

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
  late Set<String> selectedFilters;

  @override
  void initState() {
    selectedFilters = ref.read(selectedTaskFiltersProvider);
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
          "assets/icons/filter.svg",
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
          showModal(docTypes);
        },
      );
    }

    return const SizedBox.shrink();
  }

  void showModal(AsyncValue<List<String>> docTypes) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomDrawer(
          title: "Filter by",
          contents: StatefulBuilder(
            builder: (context, setState) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: Adaptive.h(30),
                ),
                child: Scrollbar(
                  trackVisibility: true,
                  child: ListView.separated(
                    itemCount: docTypes.value!.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 25),
                    itemBuilder: (context, index) {
                      // Ref: https://stackoverflow.com/questions/56530043/how-to-setstate-inside-showmodalbottomsheet

                      // Since this BottomDrawer is apparently not considered as a part of the this
                      // widget when showModalBottomSheet is called, using setState to update the list of checkboxes
                      // will not work, which is why a StatefulBuilder is needed
                      String currSortOption = docTypes.value![index];
                      bool isSelected =
                          selectedFilters.contains(currSortOption);

                      return LabelledCheckbox(
                        label: currSortOption,
                        value: isSelected,
                        onTap: () {
                          if (isSelected) {
                            setState(() {
                              selectedFilters.remove(currSortOption);
                            });
                          } else {
                            setState(() {
                              selectedFilters.add(currSortOption);
                            });
                          }
                        },
                      );
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    ).whenComplete(() {
      ref
          .read(selectedTaskFiltersProvider.notifier)
          .setFilters(selectedFilters);
    });
  }
}
