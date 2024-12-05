import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lukatout/constant/colors.dart';

enum LocalSnackbarStatus { defaultColor, successColor, errorColor, useBG }

void appShowLocalToastMessageFx(
    {required String message,
    required BuildContext ctx,
    LocalSnackbarStatus? status,
    Color? bgcolor}) {
  // Step 2
  var snackBar = SnackBar(
    content: Text(message),
    showCloseIcon: true,
    // elevation: double.infinity,
    behavior: SnackBarBehavior.floating,
    backgroundColor: status != null
        ? status == LocalSnackbarStatus.defaultColor
            ? CupertinoColors.lightBackgroundGray
            : status == LocalSnackbarStatus.successColor
                ? DigiPublicAColors.primaryColor
                : status == LocalSnackbarStatus.errorColor
                    ? DigiPublicAColors.redColor
                    : CupertinoColors.lightBackgroundGray
        : CupertinoColors.lightBackgroundGray,
    duration: const Duration(milliseconds: 5000),
    // closeIconColor: appsRed,
    margin: EdgeInsets.only(
        bottom: (75 * MediaQuery.of(ctx).size.height) / 100,
        left: 20.0,
        right: 20.0),

    // action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
  );
  // Step 3
  ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
}

//SnackbarController
void appShowGetXSnackBarFx(
    {required String title,
    required String subtitle,
    SnackPosition? position,
    Color? bgcolor,
    Color? txtcolor}) {
  Get.snackbar(
    title,
    subtitle,
    snackPosition: position ?? SnackPosition.TOP,
    colorText: txtcolor ?? Colors.white,
    duration: const Duration(milliseconds: 9000),
    backgroundColor: bgcolor ?? CupertinoColors.lightBackgroundGray,
    borderWidth: 1.0,
    borderRadius: 0.0,
    shouldIconPulse: true,
    snackStyle: SnackStyle.FLOATING,
    // borderColor: Colors.white
  );
}
