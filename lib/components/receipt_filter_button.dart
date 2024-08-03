import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/components/receipt_filter_modal.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/providers/receipt_list/receipt_list_providers.dart';
import 'package:stock_count/utils/classes.dart';

class ReceiptFilterButton extends ConsumerStatefulWidget {
  final List<ReceiptDocTypeFilterOption> docTypes;

  const ReceiptFilterButton({
    required this.docTypes,
    super.key,
  });

  @override
  ConsumerState<ReceiptFilterButton> createState() =>
      _ReceiptFilterButtonState();
}

class _ReceiptFilterButtonState extends ConsumerState<ReceiptFilterButton> {
  late ReceiptDocTypeFilterOption? modalSelectedOption;

  @override
  Widget build(BuildContext context) {
    final selectedFilterOption = ref.watch(selectedReceiptTypeProvider);
    modalSelectedOption = ref.read(selectedReceiptTypeProvider);

    if (selectedFilterOption != null) {
      return ActionChip(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        labelPadding: const EdgeInsets.only(
          right: 10,
        ),
        avatar: SvgPicture.asset(
          height: 13.sp,
          "icons/filter.svg",
          colorFilter: const ColorFilter.mode(
            Colors.black,
            BlendMode.srcIn,
          ),
        ),
        label: Text("Filter by: \"${selectedFilterOption.docDesc}\""),
        backgroundColor: AppColors.borderColor,
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
        side: const BorderSide(
          color: Colors.transparent,
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, modalSetState) {
                  return ReceiptFilterModal(
                    selectedOption: modalSelectedOption!,
                    docTypes: widget.docTypes,
                    onTap: (selectedOption) {
                      modalSetState(() {
                        modalSelectedOption = selectedOption;
                      });
                    },
                  );
                },
              );
            },
          ).whenComplete(() {
            ref
                .read(selectedReceiptTypeProvider.notifier)
                .setSelectedType(modalSelectedOption!);
            ref.read(selectedReceiptsProvider.notifier).clearSelectedReceipts();
          });
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
