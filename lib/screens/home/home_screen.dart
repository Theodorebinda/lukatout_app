import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lukatout/common/common_service.dart';
import 'package:lukatout/constant/colors.dart';
import 'package:lukatout/routes/apps_router.dart';
import 'package:lukatout/screens/landing/landing_page.dart';
import 'package:lukatout/security/security_service.dart';
import 'package:lukatout/widgets/app_fullcontent_spin.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController =
      PageController(); // PageController ajouté
  final CommonService commonService = CommonService();
  final SecurityService securityService = SecurityService();
  // final StudentService studentService = StudentService();

  // late String _studentId;

  // SERVICES INITIATIONS
  initiateFx() async {
    securityServiceSingleton.accessTokenStream.listen((accessToken) {
      debugPrint("home listener :: $accessToken");
      if (accessToken == null) {
        // Rediriger vers la page de connexion
        Get.offAllNamed(DigiPublicRouter.getLoginRoute());
      } else {
        commonService.fetchAppMenu();
      }
    });
  }

  @override
  void initState() {
    initiateFx();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    commonService.dispose();
    super.dispose();
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          children: [
            Container(
              height: 70.0,
              width: 100.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/logo/logo.png',
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 151, 237, 245),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: DigiPublicAColors.darkGreyColor,
            ),
            onPressed: () {
              // Ajouter la logique pour afficher les notifications (A faire)
            },
          ),
        ],
      ),
      // backgroundColor: DigiPublicAColors.whiteColor,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: DigiPublicAColors.whiteColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: DigiPublicAColors.primaryColor,
        onTap: onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
      body: StreamBuilder<bool?>(
        stream: securityServiceSingleton.globalSpinStream,
        builder: (context, snapshot) {
          return AppFullcontentSpin(
            activityIsRunning: snapshot.data == null ? false : snapshot.data!,
            message: 'Patientez...',
            child: PageView(
              controller: _pageController, // Utilisation du PageController
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: const <Widget>[
                LandingPage(),
                ProfileScreen(),
                DashboardScreen(),
              ],
            ),
          );
        },
      ),
    );
  }
}
