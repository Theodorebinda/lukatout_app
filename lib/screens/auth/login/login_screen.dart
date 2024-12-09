// FLUTTER IMPORTS:

import 'package:flutter/material.dart';

// PROJECT IMPORTS

// PACKAGES IMPORTS :
import 'package:animate_do/animate_do.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:lukatout/constant/colors.dart';
import 'package:lukatout/routes/apps_router.dart';
import 'package:lukatout/security/security_service.dart';
import 'package:lukatout/utils/app_show_local_snackbar.dart';
import 'package:lukatout/widgets/action_button.dart';
import 'package:lukatout/widgets/copy_right.dart';
import 'package:lukatout/widgets/input_widget.dart';
import 'package:lukatout/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameEditingController = TextEditingController();
  final _userNameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  final _passwordEditingController = TextEditingController();
  late BuildContext _ctx;

  _initFx() async {
    // BASE URL IN .env FILE
    final apiBaseURL = dotenv.env['BASE_URL'];
    debugPrint("apiBaseURL:: $apiBaseURL");

    // LISTEN TO SECURITY SERVICE
    securityServiceSingleton.accessTokenStream.listen((accessToken) {
      if (accessToken != null) {
        // Redirect to the home
        Get.offAllNamed(DigiPublicRouter.home);
      } else {
        Get.offAllNamed(DigiPublicRouter.choiseProfil);
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
      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
      body: GestureDetector(
        onTap: _cancelFocusedInput,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      opacity: 1,
                      image: AssetImage(
                          "assets/images/laptop-shopping-bags-online-shopping-concept.jpg"),
                      fit: BoxFit.cover)),
            ),
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(
                          height: 240.0,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 230, 230, 230),
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(30.0),
                                  right: Radius.circular(30.0))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20.0,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Connexion',
                                    style: TextStyle(
                                      fontSize: 40.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              InputWidget(
                                  inputFocusNode: _userNameFocusNode,
                                  label: "Adresse E-mail",
                                  keyboardType: TextInputType.text,
                                  txtEditingController:
                                      _usernameEditingController),
                              const SizedBox(
                                height: 35.0,
                              ),
                              InputWidget(
                                  inputFocusNode: _passwordFocusNode,
                                  label: "mot de passe",
                                  obscureText: true,
                                  keyboardType: TextInputType.text,
                                  txtEditingController:
                                      _passwordEditingController),
                              Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: TextButton(
                                  onPressed: () async {
                                    Get.toNamed(DigiPublicRouter.resetPassw);
                                  },
                                  child: const Text(
                                    "Mot de passe oublié ?",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 25.0,
                              ),
                              StreamBuilder<bool?>(
                                  stream:
                                      securityServiceSingleton.loginSpinStream,
                                  builder: (context, snapshot) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 28),
                                      child: ElevatedButton(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.brown,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: loginRequest,
                                        child: const SizedBox(
                                            width: 310,
                                            height: 60,
                                            child: Center(
                                                child: Text(
                                              "Connexion",
                                              style: TextStyle(
                                                fontSize: 24.0,
                                                fontFamily: "Poppins",
                                              ),
                                            ))),
                                      ),
                                    );
                                  }),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Center(
                                  child: Column(
                                children: [
                                  const Text(
                                    '-Ou-',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: DigiPublicAColors.greyColor,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ActionButton(
                                        label: 'Google',
                                        icon: Icons.g_mobiledata_outlined,
                                        color: DigiPublicAColors.redColor,
                                        iconColor: Colors.white,
                                        borderRadius: 10.0,
                                        onTap: (context) {
                                          // Action : Voir les notes
                                        },
                                      ),
                                      ActionButton(
                                        label: 'X',
                                        icon: Icons.one_x_mobiledata,
                                        color: DigiPublicAColors.blackColor,
                                        iconColor: DigiPublicAColors.whiteColor,
                                        borderRadius: 10.0,
                                        onTap: (context) {
                                          // Action : Voir les notes
                                        },
                                      ),
                                      ActionButton(
                                        label: 'Facebook',
                                        icon: Icons.facebook,
                                        color: Colors.blue,
                                        iconColor: DigiPublicAColors.whiteColor,
                                        borderRadius: 10.0,
                                        onTap: (context) {
                                          // Action : Voir les notes
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Text("Pas de Compte ?",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: DigiPublicAColors.greyColor,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Poppins",
                                      )),
                                  TextButton(
                                      onPressed: () async {
                                        Get.toNamed(DigiPublicRouter.signUp);
                                      },
                                      child: const Text(
                                        "INSCRIS-TOI",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontFamily: "Poppins",
                                            color:
                                                DigiPublicAColors.primaryColor,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!_passwordFocusNode.hasFocus &&
                    !_userNameFocusNode.hasFocus)
                  // const CopyRightWidget(),
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
  void loginRequest() async {
    final check = await validateInputs();
    if (check['status']) {
      await securityServiceSingleton.login(
          _usernameEditingController.text, _passwordEditingController.text);
    } else {
      // SHOW SNACK BAR
      appShowGetXSnackBarFx(
          title: "Oops !",
          subtitle: '${check['message']}',
          bgcolor: DigiPublicAColors.redColor,
          position: SnackPosition.TOP);
    }
  }

  Future<Map<String, dynamic>> validateInputs() async {
    if (_usernameEditingController.text.isEmpty ||
        _passwordEditingController.text.isEmpty) {
      return {
        "status": false,
        "message": "Veuillez fournir vos coordonnées de connexion"
      };
    } else {
      return {"status": true, "message": ""};
    }
  }
}
