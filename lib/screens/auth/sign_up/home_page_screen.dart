// FLUTTER IMPORTS:
import 'package:carousel_slider/carousel_slider.dart';
import 'package:digipublic_studiant/common/common_service.dart';
import 'package:digipublic_studiant/constant/colors.dart';
import 'package:digipublic_studiant/routes/apps_router.dart';
import 'package:digipublic_studiant/screens/auth/sign_up/stape_sign/stape_page_screen.dart';
import 'package:digipublic_studiant/security/security_service.dart';
import 'package:digipublic_studiant/providers/dynamic_provider.dart';
import 'package:digipublic_studiant/widgets/primary_button.dart';
import 'package:flutter/material.dart';

// PROJECT IMPORTS

// PACKAGES IMPORTS :
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final _usernameEditingController = TextEditingController();
  CommonService commonService = CommonService();
  // final _userNameFocusNode = FocusNode();

  late BuildContext _ctx;

  _initFx() async {
    securityServiceSingleton.accessTokenStream.listen((accessToken) {
      if (accessToken != null) {
        // Redirect to the dashboard
        Get.offAllNamed(DigiPublicRouter.home);
      }
    });
  }

  @override
  void initState() {
    _initFx();
    super.initState();
    fetchFormFields();
    commonService.geAllEntities(
        '/core/entity?parent=null&include__childrens__include__childrens__include__childrens=true');
  }

  @override
  void dispose() {
    // securityService.dispose();
    super.dispose();
  }

  void _cancelFocusedInput() {
    FocusScopeNode currentFocus = FocusScope.of(_ctx);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  Future<void> fetchFormFields() async {
    // setState(() {
    //   _isLoading = true; // Activer le chargement
    // });

    try {
      final response = await commonService.getPersonHead('/id-bio/person/head');
      debugPrint('\n\n ----------------- head person data: $response',
          wrapWidth: 1024);
      setState(() {});
      Provider.of<DynamicFormProvider>(_ctx, listen: false).setFormField(
          context: _ctx,
          dynamicFields: response['data'],
          commonService: commonService);
    } catch (e) {
      debugPrint('Erreur lors de la récupération des champs : $e');
    } finally {
      // setState(() {
      //   _isLoading = false; // Désactiver le chargement
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              height: 90.0,
              width: 120.0,
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
        backgroundColor: DigiPublicAColors.whiteColor,
      ),
      body: _buildHome(),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: DigiPublicAColors.secondaryColor,
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 40.0,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            opacity: 5,
                            image:
                                AssetImage("assets/logo/logo-inline-white.png"),
                            fit: BoxFit.cover)),
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'Des  solutions numériques pour un secteur public plus efficace pour le grand public ',
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: DigiPublicAColors.whiteColor),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Support Technique'),
              // selected: _selectedIndex == 0,
              onTap: () {
                // Update the state of the app
                // _onItemTapped(0);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Services client'),
              // selected: _selectedIndex == 1,
              onTap: () {
                // Update the state of the app
                // _onItemTapped(1);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Universites'),
              // selected: _selectedIndex == 2,
              onTap: () {
                // Update the state of the app
                // _onItemTapped(2);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHome() {
    return GestureDetector(
        onTap: _cancelFocusedInput,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200.0,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            opacity: 5,
                            image: AssetImage(
                                "assets/images/medium-shot-graduate-student-holding-diploma.jpg"),
                            fit: BoxFit.cover)),
                  ),
                  const Positioned(
                    top: 30.0,
                    left: 20.0,
                    child: Column(
                      children: [
                        Text(
                          'Etudier en RDC',
                          style: TextStyle(
                            color: DigiPublicAColors.primaryColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            // fontFamily: ,
                          ),
                        ),
                        Text(
                          'ADMISSION',
                          style: TextStyle(
                            color: DigiPublicAColors.primaryColor,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  Container(
                    color: const Color.fromARGB(255, 199, 239, 243),
                    height: 250.0,
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Center the column's children vertically
                      children: [
                        const SizedBox(height: 40.0),
                        const Center(
                          child: Column(
                            children: [
                              Text(
                                'Ton aventure commence ici.',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22.0,
                                ),
                              ),
                              Text(
                                'Fais ta demande.',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        SizedBox(
                          child: PrimaryButton(
                            activityIsRunning: false,
                            label: "Demande D'admission",
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const StapePage(),
                                    // const NewPersonFormDynamic(),
                                  ));
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  const SizedBox(height: 10.0),
                  const Text(
                    'Remplis ta demande en 5 étapes',
                    style: TextStyle(
                      color: DigiPublicAColors.greyColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  // Carrousel
                  CarouselSlider(
                    items: [
                      // Étape 1
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 200.0,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    opacity: 5,
                                    image: AssetImage(
                                        "assets/logo/ico-etape-01.png"),
                                    fit: BoxFit.cover)),
                          ),
                          const SizedBox(
                            width: 200,
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment
                                      .centerLeft, // Alignement à gauche
                                  child: Text(
                                    "01.",
                                    style: TextStyle(
                                      fontSize: 80.0,
                                      color: DigiPublicAColors.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment
                                      .centerLeft, // Alignement à gauche
                                  child: Text(
                                    "Trouve ton programme",
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      color: DigiPublicAColors.darkGreyColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Étape 2
                      SizedBox(
                        height: 400,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 210.0,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      opacity: 5,
                                      image: AssetImage(
                                          "assets/logo/ico-etape-02.png"),
                                      fit: BoxFit.cover)),
                            ),
                            const SizedBox(
                              width: 200,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "02.",
                                      style: TextStyle(
                                        fontSize: 80.0,
                                        color: DigiPublicAColors.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Prépare ta demande",
                                      style: TextStyle(
                                        fontSize: 25.0,
                                        color: DigiPublicAColors.darkGreyColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Étape 3
                      SizedBox(
                        height: 400,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 210.0,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      opacity: 5,
                                      image: AssetImage(
                                          "assets/logo/ico-etape-03.png"),
                                      fit: BoxFit.cover)),
                            ),
                            const SizedBox(
                              width: 200,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "03.",
                                      style: TextStyle(
                                        fontSize: 80.0,
                                        color: DigiPublicAColors.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Remplis le Formulaire!",
                                      style: TextStyle(
                                        fontSize: 25.0,
                                        color: DigiPublicAColors.darkGreyColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Étape 4
                      SizedBox(
                        height: 400,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 210.0,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      opacity: 5,
                                      image: AssetImage(
                                          "assets/logo/ico-etape-03.png"),
                                      fit: BoxFit.cover)),
                            ),
                            const SizedBox(
                              width: 200,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "04.",
                                      style: TextStyle(
                                        fontSize: 80.0,
                                        color: DigiPublicAColors.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Suis ou modifie ta demande",
                                      style: TextStyle(
                                        fontSize: 25.0,
                                        color: DigiPublicAColors.darkGreyColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Étape 5
                      SizedBox(
                        height: 400,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 210.0,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      opacity: 5,
                                      image: AssetImage(
                                          "assets/logo/ico-etape-03.png"),
                                      fit: BoxFit.cover)),
                            ),
                            const SizedBox(
                              width: 200,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "05.",
                                      style: TextStyle(
                                        fontSize: 80.0,
                                        color: DigiPublicAColors.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Admis! Tu peux te connecter",
                                      style: TextStyle(
                                        fontSize: 25.0,
                                        color: DigiPublicAColors.darkGreyColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    options: CarouselOptions(
                      height: 400.0,
                      autoPlay: true,
                      enableInfiniteScroll: false,
                      // enlargeCenterPage: true,
                    ),
                  ),
                  const Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "FAQ",
                            style: TextStyle(
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold,
                                color: DigiPublicAColors.primaryColor),
                          ),
                        ),
                      ),
                      ExpansionTile(
                        title: Text(
                          "Découvre le programme qui t'intéresse",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: DigiPublicAColors.greyColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 12.0, bottom: 5.0),
                                child: Column(
                                  children: [
                                    Text(
                                        "Consulte le Répertoire des programmes offerts à l'UQTR pour trouver le programme de ton choix."),
                                    SizedBox(height: 10.0),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      ExpansionTile(
                        title: Text(
                          "Vérifie tes conditions d’admission",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: DigiPublicAColors.greyColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 12.0, bottom: 5.0),
                            child: Column(
                              children: [
                                Text(
                                    "Consulte le Répertoire des programmes offerts par Digi Public pour trouver le programme de ton choix."),
                                SizedBox(height: 10.0),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30.0),
                  PrimaryButton(
                      label: 'Let Go',
                      activityIsRunning: false,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StapePage(),
                            // const NewPersonFormDynamic(),
                          ),
                        );
                        // Get.toNamed(DigiPublicRouter.stapePage);
                      }),
                  const SizedBox(height: 40.0),
                ],
              )
            ],
          ),
        ));
  }
}
