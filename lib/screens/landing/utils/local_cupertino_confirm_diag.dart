import 'package:flutter/cupertino.dart';

void localCupertinoConfirmDialog({
  required BuildContext context,
  required String confirmTxt,
  required String title,
  required String subtitle,
  required VoidCallback cancelFx,
  required VoidCallback confirmFx,
}) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => CupertinoActionSheet(
      title: Text(title),
      message: Text(subtitle),
      actions: <CupertinoActionSheetAction>[
        CupertinoActionSheetAction(
          /// This parameter indicates the action would be a default
          /// default behavior, turns the action's text to bold text.
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
            cancelFx();
          },
          child: const Text('Non'),
        ),
        CupertinoActionSheetAction(
          /// This parameter indicates the action would perform
          /// a destructive action such as delete or exit and turns
          /// the action's text color to red.
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context);
            Future.delayed(const Duration(milliseconds: 400), () {
              confirmFx();
            });
          },
          child: Text(confirmTxt),
        ),
      ],
    ),
  );
}

void localNoSubTitleCupertinoConfirmDialog({
  required BuildContext context,
  required String confirmTxt,
  required String title,
  required String subtitle,
  required VoidCallback cancelFx,
  required VoidCallback confirmFx,
}) {
  // addOrRemovePhoneNumberFx(flag: "remove", phoneNumber: phoneNumber);
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => CupertinoActionSheet(
      title: Text(title),
      // message: Text(subtitle),
      actions: <CupertinoActionSheetAction>[
        CupertinoActionSheetAction(
          /// This parameter indicates the action would be a default
          /// default behavior, turns the action's text to bold text.
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
            cancelFx();
          },
          child: const Text('Non'),
        ),
        CupertinoActionSheetAction(
          /// This parameter indicates the action would perform
          /// a destructive action such as delete or exit and turns
          /// the action's text color to red.
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context);
            Future.delayed(const Duration(milliseconds: 400), () {
              confirmFx();
            });
          },
          child: Text(confirmTxt),
        ),
      ],
    ),
  );
}
