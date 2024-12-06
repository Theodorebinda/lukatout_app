import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lukatout/common/common_service.dart';
import 'package:lukatout/constant/colors.dart';
import 'package:lukatout/routes/apps_router.dart';
import 'package:lukatout/screens/dashboard/dashboard_screen.dart';
import 'package:lukatout/screens/landing/landing_page.dart';
import 'package:lukatout/screens/profile/profile_screen.dart';
import 'package:lukatout/security/security_service.dart';
import 'package:lukatout/widgets/app_fullcontent_spin.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final ScrollController _scrollController =
      ScrollController(); // Contrôleur de défilement

  final CommonService commonService = CommonService();
  final SecurityService securityService = SecurityService();

  // Initialisation des services
  initiateFx() async {
    securityServiceSingleton.accessTokenStream.listen((accessToken) {
      debugPrint("home listener :: $accessToken");
      if (accessToken == null) {
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
    _scrollController.dispose(); // Nettoyer le ScrollController
    commonService.dispose();
    super.dispose();
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController, // Contrôleur pour le NestedScrollView
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              snap: false,
              floating: false,
              expandedHeight: 160.0,
              flexibleSpace: const FlexibleSpaceBar(
                title: Text('SliverAppBar'),
                background: FlutterLogo(),
              ),
            ),
          ];
        },
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: <Widget>[
            LandingPage(scrollController: _scrollController),
            ProfileScreen(scrollController: _scrollController),
            DashboardScreen(scrollController: _scrollController),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
        selectedItemColor: Colors.blue,
        onTap: onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
