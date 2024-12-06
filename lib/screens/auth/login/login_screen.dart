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
                      opacity: 1,
                      image: AssetImage(
                          "assets/images/laptop-shopping-bags-online-shopping-concept (1).jpg"),
                      fit: BoxFit.cover)),
            ),
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
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
                              // Container(
                              //   width: 180.0,
                              //   height: 60.0,
                              //   decoration: const BoxDecoration(
                              //       // color: Colors.red,
                              //       image: DecorationImage(
                              //           image:
                              //               AssetImage("assets/logo/logo.png"),
                              //           fit: BoxFit.contain)),
                              // )
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Flexible(
                              //   child: Text(
                              //     "Des  solutions numériques pour un secteur public plus efficace.",
                              //     textAlign: TextAlign.center,
                              //     style: TextStyle(
                              //         color: Colors.black, fontSize: 14.0),
                              //   ),
                              // )
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
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0))),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10.0,
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Connexion',
                                  style: TextStyle(
                                    color: DigiPublicAColors.primaryColor,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              InputWidget(
                                  inputFocusNode: _userNameFocusNode,
                                  label: "Nom d'utilisateur",
                                  keyboardType: TextInputType.text,
                                  txtEditingController:
                                      _usernameEditingController),
                              const SizedBox(
                                height: 15.0,
                              ),
                              InputWidget(
                                  inputFocusNode: _passwordFocusNode,
                                  label: "Pin",
                                  obscureText: true,
                                  keyboardType: TextInputType.text,
                                  txtEditingController:
                                      _passwordEditingController),
                              const SizedBox(
                                height: 5.0,
                              ),
                              // ... existing code ...
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton(
                                    onPressed: () async {
                                      Get.toNamed(DigiPublicRouter.resetPassw);
                                    },
                                    child: const Text(
                                      "Mot de passe oublié ?",
                                      style: TextStyle(
                                          color: DigiPublicAColors.blackColor),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              StreamBuilder<bool?>(
                                  stream:
                                      securityServiceSingleton.loginSpinStream,
                                  builder: (context, snapshot) {
                                    return PrimaryButton(
                                      activityIsRunning: snapshot.data ?? false,
                                      label: "Se Connecter",
                                      onPressed: loginRequest,
                                    );
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
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 35.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "vous n'avez pas de compte?",
                                style: TextStyle(
                                  color: DigiPublicAColors.whiteColor,
                                  fontSize: 14.0,
                                ),
                              ),
                              TextButton(
                                  onPressed: () async {
                                    Get.toNamed(DigiPublicRouter.signUp);
                                  },
                                  child: const Text(
                                    "Inscription ici",
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: DigiPublicAColors.primaryColor,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
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
