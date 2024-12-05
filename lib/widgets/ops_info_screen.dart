// ignore_for_file: non_constant_identifier_names

import 'package:animate_do/animate_do.dart';
import 'package:digipublic_studiant/constant/colors.dart';
import 'package:digipublic_studiant/widgets/danger_button.dart';
import 'package:digipublic_studiant/widgets/secondary_button.dart';
import 'package:flutter/material.dart';

class OpsInfoScreen extends StatelessWidget {
  final message;
  final title;
  final VoidCallback onClosing;
  final VoidCallback goBack;
  final bool can_show_go_back_btn;
  final bool hidde_all_btn;
  final bool no_top_padding;
  final Color custom_color;
  final Widget customIconChild;

  const OpsInfoScreen(
      {super.key,
      this.customIconChild = const Icon(
        Icons.info,
        size: 32.0,
        color: DigiPublicAColors.blackColor,
      ),
      required this.message,
      required this.onClosing,
      required this.goBack,
      this.can_show_go_back_btn = false,
      this.title = "Info. !",
      required this.hidde_all_btn,
      this.no_top_padding = false,
      this.custom_color = DigiPublicAColors.blackColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          if (no_top_padding == false)
            const SizedBox(
              height: 40.0,
            ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
            child: Column(
              children: [
                FadeInDown(
                  from: 30,
                  delay: const Duration(milliseconds: 400),
                  duration: const Duration(milliseconds: 900),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [customIconChild],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                FadeInUp(
                  from: 50,
                  delay: const Duration(milliseconds: 100),
                  duration: const Duration(milliseconds: 600),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          "$title",
                          style: TextStyle(
                              color: custom_color, fontWeight: FontWeight.w800),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                FadeInUp(
                  from: 40,
                  delay: const Duration(milliseconds: 300),
                  duration: const Duration(milliseconds: 900),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          "$message",
                          style: const TextStyle(fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (hidde_all_btn == false)
            const SizedBox(
              height: 25.0,
            ),
          if (hidde_all_btn == false)
            FadeInDown(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (can_show_go_back_btn == true)
                    SecondaryButton(
                      activityIsRunning: false,
                      label: "Retour",
                      onPressed: () {
                        goBack();
                      },
                    ),
                  if (can_show_go_back_btn == true)
                    const SizedBox(
                      width: 15.0,
                    ),
                  if (hidde_all_btn == false)
                    DangerButton(
                      activityIsRunning: false,
                      label: "Fermer",
                      onPressed: () {
                        onClosing();
                      },
                    ),
                ],
              ),
            ),
          if (hidde_all_btn == false)
            const SizedBox(
              height: 30.0,
            ),
        ],
      ),
    );
  }
}
