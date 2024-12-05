import 'package:digipublic_studiant/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> digiPublicShowBottomSheet({
  required BuildContext context,
  required Widget child,
  double? height, // Ajout du paramètre height
}) async {
  var result = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: height ??
              (MediaQuery.of(context).size.height * 85) /
                  100, // Utilisation du paramètre height
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
          ),
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  const SizedBox(
                    height: 10.0,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        height: 5.0,
                        width: 50.0,
                        color: Colors.grey.shade200,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Expanded(child: child),
                ],
              ),
              Positioned(
                right: 10.0,
                top: 10.0,
                child: FloatingActionButton(
                  backgroundColor: DigiPublicAColors.redColor,
                  onPressed: () {
                    Get.back();
                  },
                  mini: true,
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        );
      },
      isDismissible: false,
      enableDrag: false,
      barrierColor: DigiPublicAColors.primaryColor.withOpacity(.7),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: height ??
            (MediaQuery.of(context).size.height * 75) /
                100, // Utilisation du paramètre height
        minHeight: height ??
            (MediaQuery.of(context).size.height * 70) /
                100, // Utilisation du paramètre height
      ));

  return result;
}
