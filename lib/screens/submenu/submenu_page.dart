import 'package:digipublic_studiant/constant/colors.dart';
import 'package:digipublic_studiant/helper/common_helper.dart';
import 'package:digipublic_studiant/models/menu.dart';
import 'package:digipublic_studiant/widgets/no_data_found.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SubMenuPage extends StatefulWidget {
  final IAppMenu selectedMenu;
  final VoidCallback onPressed;
  const SubMenuPage(
      {super.key, required this.selectedMenu, required this.onPressed});

  @override
  State<SubMenuPage> createState() => _SubMenuPageState();
}

class _SubMenuPageState extends State<SubMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.selectedMenu.name,
                style: const TextStyle(
                    fontWeight: FontWeight.w800, fontSize: 22.0),
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10.0),
            border: const Border(
              left: BorderSide(
                color: DigiPublicAColors.primaryColor, // Border color
                width: 3.0, // Border width
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.light_mode_outlined),
              const SizedBox(
                width: 9.0,
              ),
              Expanded(
                child: Text(
                  widget.selectedMenu.verbose,
                  style: TextStyle(color: Colors.grey.shade800),
                ),
              )
            ],
          ),
        ),
        if (widget.selectedMenu.subMenus.isEmpty)
          Center(
            child: NoDataFound(
              showRefreshBtn: false,
              eventReload: () {},
              info: "Aucun menu",
              textStyle: const TextStyle(fontWeight: FontWeight.w500),
            ),
          )
        else
          Expanded(
            child: ListView.separated(
                itemBuilder: (BuildContext context, int i) {
                  var item = widget.selectedMenu.subMenus[i];
                  return FutureBuilder<Widget>(
                    future: loadLocalSvgFile(item.icon),
                    builder: (BuildContext context,
                        AsyncSnapshot<Widget> futureSnapshot) {
                      if (futureSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return ListTile(
                          trailing: const Icon(CupertinoIcons.chevron_right),
                          leading: const SizedBox(
                              width: 20.0,
                              height: 20.0,
                              child: Center(
                                  child: CircularProgressIndicator(
                                strokeWidth: 1.0,
                              ))),
                          title: Text(item.name.capitalizeFirstLetter()),
                        );
                      } else if (futureSnapshot.hasError) {
                        return ListTile(
                          trailing: const Icon(CupertinoIcons.chevron_right),
                          leading: SvgPicture.asset('assets/svg/default.svg'),
                          title: Text(item.name.capitalizeFirstLetter()),
                        );
                      } else {
                        return InkWell(
                          onTap: widget.onPressed,
                          child: ListTile(
                            trailing: const Icon(CupertinoIcons.chevron_right),
                            leading: SizedBox(
                              height: 25.0,
                              width: 25.0,
                              child: futureSnapshot.data ??
                                  SvgPicture.asset('assets/svg/default.svg'),
                            ),
                            title: Text(item.name.capitalizeFirstLetter()),
                          ),
                        ); // snapshot.data ?? SvgPicture.asset('assets/svg/$defaultSvg');
                      }
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int i) {
                  return const Divider();
                },
                itemCount: widget.selectedMenu.subMenus.length),
          )
      ],
    );
  }
}
