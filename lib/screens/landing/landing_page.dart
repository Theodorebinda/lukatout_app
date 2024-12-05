import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lukatout/common/common_service.dart';
import 'package:lukatout/constant/colors.dart';
import 'package:lukatout/helper/common_helper.dart';
import 'package:lukatout/models/menu.dart';
import 'package:lukatout/models/menu_service.dart';
import 'package:lukatout/routes/apps_router.dart';
import 'package:lukatout/screens/landing/widgets/service_item_card.dart';
import 'package:lukatout/screens/submenu/submenu_page.dart';
import 'package:lukatout/security/security_service.dart';
import 'package:lukatout/services/data_student_services.dart';
import 'package:lukatout/utils/app_show_bottom_sheet.dart';
import 'package:lukatout/widgets/no_data_found.dart';
import 'package:lukatout/widgets/ops_error_screen.dart';
import 'package:lukatout/widgets/refrechable_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({
    super.key,
  });

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final CommonService commonService = CommonService();
  final StudentService studentService = StudentService();

  int _calculateCrossAxisCount(BoxConstraints constraints) {
    const double itemWidth = 100.0;
    final double maxCrossAxisCount = constraints.maxWidth / itemWidth;
    return maxCrossAxisCount.floor().clamp(1, double.infinity).toInt();
  }

  @override
  void initState() {
    // final student =  securityServiceSingleton.userInfo.first;
    // final studentId = student.;
    // debugPrint("StudentID : $studentId");

    commonService.fetchAppMenu();
    // studentService.fetchStudent(studentId);
    super.initState();
  }

  //  fonction a appelée lorsque l'utilisateur tirera pour rafraîchir
  Future<void> _handleRefresh() async {
    try {
      // final student = await securityServiceSingleton.userInfo.first;
      // final studentId = student!.id;
      await commonService.fetchAppMenu();
      // await securityServiceSingleton.fetchStudent(studentId);
    } catch (e) {
      debugPrint('Erreur lors de la récupération des données : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshablePage(
      onRefresh: _handleRefresh,
      indicatorColor: DigiPublicAColors.primaryColor,
      backgroundColor: Colors.white,
      child: Container(
        color: Colors.grey.shade100,
        padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 180.0,
                decoration: BoxDecoration(
                  color: DigiPublicAColors.primaryColor,
                  borderRadius: BorderRadius.circular(15.0), // Coins arrondis
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "Bloc pour prevoir la pub ",
                          style: TextStyle(
                            color: DigiPublicAColors.whiteColor,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 100.0,
                width: 300.0,
                decoration: BoxDecoration(
                  color: DigiPublicAColors.primaryColor,
                  borderRadius: BorderRadius.circular(15.0), // Coins arrondis
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: StreamBuilder(
                          stream: securityServiceSingleton.userInfo,
                          builder: (context, snapshot) {
                            String displayText = "Bienvenue";
                            // var name = snapshot.data.name
                            if (snapshot.hasData) {
                              displayText =
                                  "$displayText ${snapshot.data?.name ?? ''}"; // Concaténation
                            }
                            return Center(
                              child: Text(
                                displayText,
                                style: const TextStyle(
                                  color: DigiPublicAColors.whiteColor,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              StreamBuilder<List<IAppMenu>?>(
                stream: commonService.appMenuStream,
                builder: (context, snapshot) {
                  if
                      //  (snapshot.connectionState == ConnectionState.waiting) {
                      //   return buildServiceGridSkeleton(context);
                      // } else if
                      (snapshot.hasError) {
                    return OpsErrorScreen(
                      can_show_go_back_btn: false,
                      hidde_all_btn: true,
                      goBack: () {},
                      message: "Quelque chose s'est mal passé !",
                      title: "Oups !",
                      onClosing: () {},
                    );
                  } else if (!snapshot.hasData) {
                    return NoDataFound(
                      showRefreshBtn: true,
                      eventReload: () {},
                      info: "Oups ! Aucune donnée chargée !",
                      textStyle: const TextStyle(fontWeight: FontWeight.w500),
                    );
                  } else {
                    return LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                _calculateCrossAxisCount(constraints),
                            childAspectRatio: 1.0,
                            crossAxisSpacing: 20.0,
                            mainAxisSpacing: 20.0,
                          ),
                          itemCount: snapshot.data!.length,
                          padding: const EdgeInsets.all(8.0),
                          itemBuilder: (context, i) {
                            return FutureBuilder<Widget>(
                              future: loadLocalSvgFile(snapshot.data![i].icon),
                              builder: (BuildContext context,
                                  AsyncSnapshot<Widget> futureSnapshot) {
                                if (futureSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                        strokeWidth: 1.0),
                                  );
                                } else if (futureSnapshot.hasError) {
                                  return ServiceItemCard(
                                    svgWidget: SvgPicture.asset(
                                        'assets/svg/default.svg'),
                                    menuItem: snapshot.data![i],
                                    onValueChanged: (value) {},
                                  );
                                } else {
                                  return ServiceItemCard(
                                    svgWidget: futureSnapshot.data ??
                                        SvgPicture.asset(
                                            'assets/svg/default.svg'),
                                    menuItem: snapshot.data![i],
                                    onValueChanged: (value) {
                                      debugPrint(
                                          'Menu value: ${value.toString()}, Index: $i');
                                      commonService.setSelectedMenu(value);

                                      digiPublicShowBottomSheet(
                                        context: context,
                                        child: SubMenuPage(
                                          selectedMenu: value,
                                          onPressed: () {
                                            Get.back();
                                            Future.delayed(
                                              const Duration(milliseconds: 300),
                                              () {
                                                Get.toNamed(
                                                  DigiPublicRouter
                                                      .selectedSubMenu,
                                                  arguments: IMenuAndService(
                                                    menu: value,
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
