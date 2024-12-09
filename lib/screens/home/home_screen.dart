import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lukatout/common/common_service.dart';
import 'package:lukatout/constant/colors.dart';
import 'package:lukatout/routes/apps_router.dart';
import 'package:lukatout/screens/dashboard/dashboard_screen.dart';
import 'package:lukatout/screens/landing/landing_page.dart';
import 'package:lukatout/screens/profile/profile_screen.dart';
import 'package:lukatout/security/security_service.dart';

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
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              clipBehavior: Clip.antiAlias,
              automaticallyImplyLeading: true,
              backgroundColor: const Color.fromARGB(255, 175, 145, 133),
              pinned: true,
              snap: false,
              floating: false,
              collapsedHeight: 80.0,
              expandedHeight: 230.0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(10.0),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: const EdgeInsets.only(top: 5.0, bottom: 20.0),
                title: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Trouve un produit ou un marchant',
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 12.0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                background: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          CircleAvatar(
                            radius: 26.0,
                            backgroundImage: NetworkImage(
                                "https://lh3.googleusercontent.com/a/ACg8ocKi7_sRkEisPwvp2TKaQQXOPC0DjsoGJ24BReynndwrm_7InhzT=s288-c-no"), // Remplacez par l'URL de l'avatar
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            "Theodore",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(90)),
                        child: IconButton(
                          icon: const Icon(
                            Icons.notifications_outlined,
                            color: Colors.grey,
                            size: 30.0,
                          ),
                          onPressed: () {
                            // Action pour l'icône de notification
                          },
                        ),
                      ),
                    ],
                  ),
                ),
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
            DashboardScreen(scrollController: _scrollController),
            ProfileScreen(scrollController: _scrollController),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: DigiPublicAColors.whiteColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Cathalogue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_rounded),
            label: 'Favories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.brown,
        onTap: onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
