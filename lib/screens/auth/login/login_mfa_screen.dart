import 'package:flutter/material.dart';

// PACKAGES IMPORTS :
import 'package:animate_do/animate_do.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:lukatout/constant/colors.dart';
import 'package:lukatout/models/mfa.dart';
import 'package:lukatout/routes/apps_router.dart';
import 'package:lukatout/security/security_service.dart';
import 'package:lukatout/widgets/copy_right.dart';
import 'package:lukatout/widgets/primary_button.dart';

class LoginMfaScreen extends StatefulWidget {
  const LoginMfaScreen({super.key});

  @override
  State<LoginMfaScreen> createState() => _LoginMfaScreenState();
}

class _LoginMfaScreenState extends State<LoginMfaScreen>
    with TickerProviderStateMixin {
  // final _usernameEditingController = TextEditingController();
  final _userNameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  int currentTabIndex = 0;
  List<Widget> listOfPages = [];

  // final _passwordEditingController = TextEditingController();
  late BuildContext _ctx;

  _initFx() async {
    // BASE URL IN .env FILE
    final apiBaseURL = dotenv.env['BASE_URL'];
    debugPrint("apiBaseURL:: $apiBaseURL");

    // LISTEN TO SECURITY SERVICE
    securityServiceSingleton.accessTokenStream.listen((accessToken) {
      if (accessToken != null) {
        // Redirect to the dashboard
        Get.offAllNamed(DigiPublicRouter.home);
      }
    });

    // REMOVE SPLASH SCREEN
    await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
  }

  @override
  void initState() {
    _initFx();
    super.initState();
  }

  @override
  void dispose() {
    securityServiceSingleton.hideSpinners();
    super.dispose();
  }

  void _cancelFocusedInput() {
    FocusScopeNode currentFocus = FocusScope.of(_ctx);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: _cancelFocusedInput,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      opacity: .8,
                      image: AssetImage("assets/images/bg-img.png"),
                      fit: BoxFit.cover)),
            ),
            Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                      FadeInUp(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 180.0,
                              height: 60.0,
                              decoration: const BoxDecoration(
                                  // color: Colors.red,
                                  image: DecorationImage(
                                      image: AssetImage("assets/logo/logo.png"),
                                      fit: BoxFit.contain)),
                            )
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                "Des  solutions numériques pour un secteur public plus efficace.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14.0),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30.0),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.7),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0))),
                        child: Column(
                          children: [
                            StreamBuilder<IMFaLoginData>(
                                stream: securityServiceSingleton.mfaController,
                                builder: (context, snapshot) {
                                  if (snapshot.error != null) {
                                    return const Center(
                                      child: Text("Oops !"),
                                    );
                                  } else if (snapshot.data == null) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.0,
                                      ),
                                    );
                                  } else {
                                    List<IMfa> mfas = snapshot.data!.mfas;
                                    TabController tabController = TabController(
                                        length: snapshot.data != null
                                            ? mfas.length
                                            : 0,
                                        vsync: this);
                                    // PageController _controller = PageController(
                                    //   initialPage: 0,
                                    // );
                                    listOfPages = [];
                                    for (var i = 0; i < mfas.length; i++) {
                                      var itm = mfas[i];
                                      if (itm.mFaFlag == 'Email') {
                                        listOfPages.add(Column(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "ENVOYER LE CODE DE CONFIRMATION",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              DigiPublicAColors
                                                                  .primaryColor),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      itm.descriptionStr,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                StreamBuilder<bool?>(
                                                    stream:
                                                        securityServiceSingleton
                                                            .loginSpinStream,
                                                    builder:
                                                        (context, snapshot) {
                                                      return PrimaryButton(
                                                        activityIsRunning:
                                                            snapshot.data ??
                                                                false,
                                                        label: "Envoyer",
                                                        onPressed: () {
                                                          sendOtp('Email');
                                                        },
                                                      );
                                                    }),
                                              ],
                                            ),
                                            const Divider(),
                                            Row(
                                              children: [
                                                TextButton.icon(
                                                  onPressed: () {
                                                    Get.offAllNamed(
                                                        DigiPublicRouter.login);
                                                  },
                                                  label: const Text("Retour"),
                                                  icon: const Icon(Icons
                                                      .arrow_back_ios_outlined),
                                                )
                                              ],
                                            )
                                          ],
                                        ));
                                      } else if (itm.mFaFlag == 'PhoneNumber') {
                                        listOfPages.add(
                                            const Text("Phone number here"));
                                      }
                                    }
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TabBar(
                                                  controller: tabController,
                                                  // isScrollable: false,
                                                  onTap: (value) {
                                                    setState(() {
                                                      currentTabIndex = value;
                                                    });
                                                  },
                                                  tabs: [
                                                    ...snapshot.data!.mfas
                                                        .asMap()
                                                        .entries
                                                        .map((elm) {
                                                      return Text(
                                                          elm.value.mfaName);
                                                    })
                                                  ]),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 250,
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    ...listOfPages
                                                        .asMap()
                                                        .entries
                                                        .map((chld) {
                                                      return chld.value;
                                                    })
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                }),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
                ),
                if (!_passwordFocusNode.hasFocus &&
                    !_userNameFocusNode.hasFocus)
                  const CopyRightWidget(),
                if (!_passwordFocusNode.hasFocus &&
                    !_userNameFocusNode.hasFocus)
                  const SizedBox(
                    height: 25.0,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// service prend direction et direction prend id project
  // Example of using the login method

  void sendOtp(String mfaflag) async {
    await securityServiceSingleton.sendOtp(mfaflag);
  }
}
