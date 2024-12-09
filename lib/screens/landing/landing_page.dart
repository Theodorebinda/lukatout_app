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
  final ScrollController scrollController;
  const LandingPage({super.key, required this.scrollController});

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
              SizedBox(height: 20.0),
              Text(
                'Bienvenue sur DigiPublic',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              // TODO : Afficher les services
              // ServiceItemCard(),
              SizedBox(height: 20.0),
              Text(
                'Veuillez patienter pendant le chargement des services...',
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
              SizedBox(height: 20.0),
              // NoDataFound(
              //   text: 'Aucun service disponible pour le moment.',
              //   image: const SvgPicture.asset('assets/images/no_service.svg'),
              // ),
              SizedBox(height: 20.0),
              // OPSErrorScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
