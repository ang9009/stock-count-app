import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stock_count/components/scanning/bottom_drawer.dart';
import 'package:stock_count/components/ui/labelled_checkbox.dart';
import 'package:stock_count/components/ui/rounded_button.dart';
import 'package:stock_count/components/ui/show_error_snackbar.dart';
import 'package:stock_count/data/primary_theme.dart';
import 'package:stock_count/providers/current_page/current_page_provider.dart';
import 'package:stock_count/providers/task_list_paging_controller.dart';
import 'package:stock_count/utils/helpers/get_parent_type_options.dart';
import 'package:stock_count/utils/helpers/show_snackbar.dart';
import 'package:stock_count/utils/queries/create_qty_entry_task.dart';
import 'package:stock_count/utils/queries/get_doc_types_from_parent_type.dart';

class QuantityEntryReceiptsPage extends ConsumerStatefulWidget {
  const QuantityEntryReceiptsPage({super.key});

  @override
  ConsumerState<QuantityEntryReceiptsPage> createState() =>
      _QuantityEntryReceiptsPageState();
}

class _QuantityEntryReceiptsPageState
    extends ConsumerState<QuantityEntryReceiptsPage> {
  late Future<List<String>> _pendingParentTypes;
  late Future<List<String>?> _pendingDocTypes;
  final TextEditingController _parentTypeTextController =
      TextEditingController();
  final TextEditingController _docTypeTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _pendingParentTypes = getParentTypeOptions();
    _parentTypeTextController.addListener(() {
      if (_parentTypeTextController.text.isNotEmpty) {
        String parentType = _parentTypeTextController.text;
        _pendingDocTypes = getDocTypesFromParentType(parentType);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _parentTypeTextController.dispose();
    _docTypeTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create quantity entry task",
          style: TextStyles.largeTitle,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.sp,
          vertical: 20.sp,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select parent type",
                style: TextStyles.heading,
              ),
              SizedBox(height: 12.sp),
              FutureBuilder(
                future: _pendingParentTypes,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<String> parentTypes = snapshot.data!;

                    return DropdownField(
                      onTap: () {
                        _openOptionsModal(
                          typesList: parentTypes,
                          context: context,
                          controller: _parentTypeTextController,
                          title: "Select parent type",
                        );
                      },
                      controller: _parentTypeTextController,
                    );
                  } else if (snapshot.hasError) {
                    showErrorSnackbar(context,
                        "An unexpected error occurred: could not get parent types");
                    return const SizedBox.shrink();
                  }

                  return const SizedBox.shrink();
                },
              ),
              if (_parentTypeTextController.text.isNotEmpty)
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: 24.sp),
                      FutureBuilder(
                        future: _pendingDocTypes,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final docTypes = snapshot.data;

                            if (docTypes != null) {
                              return Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      "Select document type",
                                      style: TextStyles.heading,
                                    ),
                                    SizedBox(height: 12.sp),
                                    DropdownField(
                                      onTap: () {
                                        _openOptionsModal(
                                          typesList: docTypes,
                                          context: context,
                                          controller: _docTypeTextController,
                                          title: "Select document type",
                                        );
                                      },
                                      controller: _docTypeTextController,
                                    ),
                                    const Spacer(),
                                    RoundedButton(
                                      style: RoundedButtonStyles.solid,
                                      onPressed: () => submitOnPressed(),
                                      label: "Create task",
                                    ),
                                  ],
                                ),
                              );
                            }
                          } else if (snapshot.hasError) {
                            showErrorSnackbar(context,
                                "An unexpected error occurred: could not get document types");
                            return const SizedBox.shrink();
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  void submitOnPressed() async {
    if (!_formKey.currentState!.validate()) return;

    final parentType = _parentTypeTextController.text;
    final docType = _docTypeTextController.text;

    try {
      await createQuantityEntryTask(
        parentType: parentType,
        docType: docType,
      );
    } catch (err) {
      if (mounted) {
        showErrorSnackbar(
          context,
          err.toString(),
        );
      }
      return;
    }

    if (mounted) {
      showSnackbar(
        "New task added",
        context,
      );
      Navigator.pop(context);
      // Refresh tasks list on homoepage
      TaskListPagingController.of(context).refresh();
    }
    // Go home
    ref.read(currentPageProvider.notifier).setCurrentPage(0);
  }

  void _openOptionsModal({
    required List<String> typesList,
    required BuildContext context,
    required TextEditingController controller,
    required String title,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomDrawer(
          title: title,
          contents: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: Adaptive.h(20),
            ),
            child: StatefulBuilder(
              builder: (context, modalSetState) {
                return ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => LabelledCheckbox(
                    label: typesList[index],
                    value: typesList[index] == controller.text,
                    onTap: () {
                      setState(() {
                        modalSetState(() {
                          controller.text = typesList[index];
                        });
                      });
                    },
                  ),
                  separatorBuilder: (context, index) => Divider(
                    height: 24.sp,
                    color: AppColors.borderColor,
                  ),
                  itemCount: typesList.length,
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class DropdownField extends StatelessWidget {
  final Function onTap;
  final TextEditingController controller;

  const DropdownField({
    super.key,
    required this.onTap,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a value';
          }
          return null;
        },
        controller: controller,
        readOnly: true,
        enabled: false,
        style: const TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: AppColors.warning,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: AppColors.borderColor,
            ),
          ),
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 15.sp),
            child: SvgPicture.asset(
              "assets/icons/chevron_down.svg",
              fit: BoxFit.contain,
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              ),
            ),
          ),
          suffixIconConstraints: BoxConstraints(
            maxHeight: 18.sp,
          ),
          hintText: "Tap to select...",
          hintStyle: TextStyle(
            fontSize: 16.sp,
            color: AppColors.lighterTextColor,
          ),
        ),
      ),
    );
  }
}
