import 'dart:async';

import "package:flutter/material.dart";
import 'package:stock_count/api/common.dart';
import 'package:stock_count/api/services/custom_extensions.dart';

enum MessageBoxButtons { yes, no, cancel, retry, confirm, details }

Future<MessageBoxButtons?> messageBox({
  required BuildContext context,
  Widget? title,
  required Widget content,
  List<MessageBoxButtons>? buttons,
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
  void Function(MessageBoxButtons button)? buttonTap,
  TextStyle? btnTextStyle,
  ButtonStyle? btnStyle,
  bool withoutIcon = false,
  Color backgroundColor = Colors.white,
  Color surfaceTintColor = Colors.white,
}) {
  final String yesText = "yes_t".tr();
  final String noText = "no_t".tr();
  final String cancelText = "cancel_t".tr();
  final String retryText = "retry_t".tr();
  final String confirmText = "confirm_t".tr();
  final String detailsText = "details_t".tr();

  Widget btnIcon(MessageBoxButtons btn) {
    if (withoutIcon) return const SizedBox();
    switch (btn) {
      case MessageBoxButtons.yes:
      case MessageBoxButtons.confirm:
        return const Icon(Icons.check);
      case MessageBoxButtons.cancel:
      case MessageBoxButtons.no:
        return const Icon(Icons.cancel);
      case MessageBoxButtons.retry:
        return const Icon(Icons.redo);
      case MessageBoxButtons.details:
        return const Icon(Icons.details_outlined);
      default:
        return const SizedBox();
    }
  }

  Widget btnYes = TextButton.icon(
    style: btnStyle,
    icon: btnIcon(MessageBoxButtons.yes),
    label: Text(yesText, style: btnTextStyle, textAlign: TextAlign.center),
    onPressed: () {
      Navigator.of(context).pop(MessageBoxButtons.yes); // 关闭对话框
      if (buttonTap != null) buttonTap(MessageBoxButtons.yes);
    },
  );
  Widget btnNo = TextButton.icon(
    style: btnStyle,
    icon: btnIcon(MessageBoxButtons.no),
    label: Text(noText, style: btnTextStyle),
    onPressed: () => Navigator.of(context).pop(MessageBoxButtons.no), // 关闭对话框
  );
  Widget btnCancel = TextButton.icon(
    style: btnStyle,
    icon: btnIcon(MessageBoxButtons.cancel),
    label: Text(cancelText, style: btnTextStyle),
    onPressed: () {
      Navigator.of(context).pop(MessageBoxButtons.cancel); // 关闭对话框
      if (buttonTap != null) buttonTap(MessageBoxButtons.cancel);
    },
  );
  Widget btnRetry = TextButton.icon(
    style: btnStyle,
    icon: btnIcon(MessageBoxButtons.retry),
    label: Text(retryText, style: btnTextStyle),
    onPressed: () {
      Navigator.of(context).pop(MessageBoxButtons.retry); // 关闭对话框
      if (buttonTap != null) buttonTap(MessageBoxButtons.retry);
    },
  );
  Widget btnConfirm = TextButton.icon(
    style: btnStyle,
    icon: btnIcon(MessageBoxButtons.confirm),
    label: Text(confirmText, style: btnTextStyle, textAlign: TextAlign.center),
    onPressed: () {
      Navigator.of(context).pop(MessageBoxButtons.confirm); // 关闭对话框
      if (buttonTap != null) buttonTap(MessageBoxButtons.confirm);
    },
  );
  Widget btnDetails = TextButton.icon(
    style: btnStyle,
    icon: btnIcon(MessageBoxButtons.details),
    label: Text(detailsText, style: btnTextStyle),
    onPressed: () {
      Navigator.of(context).pop(MessageBoxButtons.details);
      if (buttonTap != null) buttonTap(MessageBoxButtons.details);
    },
  );

  List<Widget> actions = [];
  //buttons = buttons ?? [MessageBoxButtons.Yes];
  if (buttons != null) {
    for (var btn in buttons) {
      switch (btn) {
        case MessageBoxButtons.cancel:
          actions.add(btnCancel);
          break;
        case MessageBoxButtons.no:
          actions.add(btnNo);
          break;
        case MessageBoxButtons.retry:
          actions.add(btnRetry);
          break;
        case MessageBoxButtons.yes:
          actions.add(btnYes);
          break;
        case MessageBoxButtons.confirm:
          actions.add(btnConfirm);
          break;
        case MessageBoxButtons.details:
          actions.add(btnDetails);
          break;
      }
    }
  }
  return showDialog<MessageBoxButtons>(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return PopScope(
        canPop: false,
        child: AlertDialog(
          title: title,
          content: content,
          actions: actions,
          actionsAlignment: mainAxisAlignment,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: backgroundColor,
          surfaceTintColor: surfaceTintColor,
        ),
      );
    },
  );
}

Future<MessageBoxButtons?> showError(
    BuildContext context, FlutterErrorDetails details,
    {List<MessageBoxButtons>? buttons}) {
  //FlutterError.dumpErrorToConsole(details);

  return messageBox(
    context: context,
    content: SingleChildScrollView(
      child: InteractiveViewer(child: ErrorWidget.builder(details)),
    ), //支持平移和缩放
    buttons: buttons,
  );
}

Future showProgressBar(
  BuildContext context,
  String message, {
  TextStyle? msgTextStyle,
  TextAlign? msgTextAlign,
}) async {
  Widget content = Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const CircularProgressIndicator(),
      Padding(
        padding: const EdgeInsets.only(top: 26.0),
        child: Text(
          message,
          style: msgTextStyle,
          textAlign: msgTextAlign,
        ),
      )
    ],
  );

  messageBox(
    context: context,
    content: content,
    buttons: [],
  );
}

Future<T> futureWithIndicator<T>(
  BuildContext? context,
  FutureOr<T> Function() job, {
  String? message,
}) async {
  BuildContext? currentContext = context;
  currentContext ??= Common.context;

  if (currentContext != null) {
    message = (message ?? "loading_wait_t".tr());
    showProgressBar(currentContext, message);
  }

  try {
    return await job();
  } finally {
    if (currentContext != null) {
      Navigator.of(currentContext).pop();
    }
  }
}
