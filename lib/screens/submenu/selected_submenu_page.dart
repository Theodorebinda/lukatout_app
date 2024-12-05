import 'package:digipublic_studiant/common/common_service.dart';
import 'package:digipublic_studiant/models/menu_service.dart';
import 'package:digipublic_studiant/widgets/no_data_found.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectedSubMenuPage extends StatefulWidget {
  const SelectedSubMenuPage({
    super.key,
  });

  @override
  State<SelectedSubMenuPage> createState() => _SelectedSubMenuPageState();
}

class _SelectedSubMenuPageState extends State<SelectedSubMenuPage> {
  IMenuAndService? menuAndService;
  final CommonService commonService = CommonService();

  @override
  void initState() {
    super.initState();
    // Récupérer les arguments et vérifier s'ils ne sont pas nuls
    menuAndService = Get.arguments as IMenuAndService?;
    if (menuAndService != null) {
      getSelectedPath();
    } else {
      // Gestion du cas où l'objet est null
      debugPrint("menuAndService est null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: false,
        title: Text(menuAndService?.menu.name ?? 'Menu Inconnu'),
      ),
      backgroundColor: CupertinoColors.lightBackgroundGray,
      body: Column(
        children: [
          if (menuAndService == null)
            Center(
              child: NoDataFound(
                textStyle: const TextStyle(fontWeight: FontWeight.w500),
                showRefreshBtn: false,
                eventReload: () {},
                info: "Aucune donnée disponible",
              ),
            )
          else
            Center(
              child: NoDataFound(
                showRefreshBtn: true,
                eventReload: () {
                  getSelectedPath();
                },
                info: "Aucune donnée pour l'instant",
                textStyle: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
        ],
      ),
    );
  }

  // Fonction pour récupérer le chemin du menu sélectionné
  void getSelectedPath() {
    if (menuAndService != null) {
      commonService.getSelectedPath("/${menuAndService!.menu.path}");
    }
  }
}
