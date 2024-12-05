// FLUTTER IMPORTS
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// PACKAGE IMPORTS
import 'package:animate_do/animate_do.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lukatout/constant/colors.dart';
import 'package:lukatout/widgets/ops_info_screen.dart';

class NoDataFound extends StatelessWidget {
  final VoidCallback eventReload;
  final String info;
  final String? title;
  final showRefreshBtn;
  final TextStyle textStyle;
  const NoDataFound(
      {super.key,
      required this.eventReload,
      this.showRefreshBtn = false,
      required this.info,
      required this.textStyle,
      this.title});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(bottom: 5.0),
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: FadeInUp(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                OpsInfoScreen(
                  no_top_padding: true,
                  customIconChild: SizedBox(
                    height: 40.0,
                    width: 40.0,
                    // height: (40 * MediaQuery.of(context).size.width)/100,
                    // width: (41 * MediaQuery.of(context).size.width)/100,
                    child: SvgPicture.string(
                      '''<svg id="fi_6598519" enable-background="new 0 0 68 68" height="512" viewBox="0 0 68 68" width="512" xmlns="http://www.w3.org/2000/svg"><g id="_x32_15"><path d="m21.5 38.6c.3-.3.3-.8 0-1.1l-2.4-2.4 3.1-3.1c.3-.3.3-.8 0-1.1s-.8-.3-1.1 0l-3.1 3.1-2.8-2.8c-.3-.3-.8-.3-1.1 0s-.3.8 0 1.1l2.8 2.8-2.8 2.8c-.3.3-.3.8 0 1.1s.8.3 1.1 0l2.8-2.8 2.4 2.4c.4.3.8.3 1.1 0z"></path><path d="m21.2 48.5c-.3.3-.3.8.1 1.1.3.3.8.3 1.1-.1 4.9-5.4 13.3-5.3 18.1-.3.3.3.8.3 1.1 0s.3-.8 0-1.1c-5.5-5.6-14.9-5.7-20.4.4z"></path><path d="m58.6 54.5 2.6-26.5c.1-1.1-.3-2.2-1-3s-1.8-1.3-2.9-1.3v-6.9c0-2.6-2-4.7-4.6-4.8l-42.1-.6c-2.7 0-4.7 2.1-4.8 4.6v1.8c-1.2.3-2.1 1.1-2.6 2.3-.6.7-1 1.6-1.2 2.3-.5 1.8-.4 3.7-.2 5.6.8 8.8 1.6 17.5 2.3 26.3.3 3.8 1.3 5.4 6.8 5.7 15.7.8 31.4.7 47.1.4.6 0 1.3 0 1.8-.3.6-.3 1-.9.9-1.5-.3-1.3-2.5-1.1-3.8-1.2.9-.6 1.5-1.6 1.7-2.9zm-48-41.5 42.1.6c1.7 0 3.2 1.5 3.1 3.2v7h-14.7c-1.1 0-2.2-.5-3-1.3l-2.3-2.6c-1.2-1.3-2.9-2.1-4.7-2.1h-23.8v-1.6c0-1.9 1.5-3.3 3.3-3.2zm44.1 43.6h-45.1c-1.2 0-2.3-.9-2.4-2.2l-2.9-32.6c-.1-1.4 1-2.6 2.4-2.6h24.4c1.4 0 2.7.6 3.6 1.6l2.3 2.6c1 1.2 2.5 1.9 4.1 1.9h16.2c.7 0 1.3.3 1.8.8s.7 1.2.6 1.8l-2.6 26.5c-.1 1.2-1.2 2.2-2.4 2.2z"></path><path d="m44.2 33.8 2.2-2.2c.3-.3.3-.8 0-1.1s-.8-.3-1.1 0l-2.2 2.2-2.8-2.8c-.3-.3-.8-.3-1.1 0s-.3.8 0 1.1l2.8 2.8-2.6 2.6c-.3.3-.3.8 0 1.1s.8.3 1.1 0l2.6-2.6 2.8 2.8c.3.3.8.3 1.1 0s.3-.8 0-1.1z"></path><path d="m57.8 7.6c-.9 1.2-1.6 2.4-2.1 3.8-.1.4.1.8.5.9s.8-.1.9-.5c.4-1.2 1-2.4 1.8-3.4.3-.3.2-.8-.1-1.1-.3 0-.7 0-1 .3z"></path><path d="m64.2 10.5c-.2-.3-.7-.5-1-.2l-4.7 3c-.3.2-.4.7-.2 1s.7.5 1 .2l4.7-3c.3-.2.4-.7.2-1z"></path><path d="m65.6 15.9-5.3.4c-.4 0-.7.4-.7.8s.4.7.8.7l5.3-.4c.4 0 .7-.4.7-.8-.1-.4-.4-.7-.8-.7z"></path></g>
                      </svg>
                      ''',
                      fit: BoxFit.contain,
                      color: DigiPublicAColors.primaryColor,
                    ),
                  ),
                  goBack: () {},
                  hidde_all_btn: true,
                  message: info,
                  title: title ?? 'Infos.',
                  custom_color: DigiPublicAColors.primaryColor,
                  onClosing: () {},
                ),
                const SizedBox(
                  height: 5.0,
                ),
                if (showRefreshBtn)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                          onPressed: eventReload,
                          icon: const Icon(
                            CupertinoIcons.refresh,
                            color: DigiPublicAColors.secondaryColor,
                          ),
                          label: const Text(
                            'Rafraichir',
                            style: TextStyle(
                                color: DigiPublicAColors.secondaryColor),
                          ))
                    ],
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
