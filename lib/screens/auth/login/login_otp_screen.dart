// FLUTTER IMPORTS:

import 'package:digipublic_studiant/constant/colors.dart';
import 'package:digipublic_studiant/routes/apps_router.dart';
import 'package:digipublic_studiant/security/security_service.dart';
import 'package:digipublic_studiant/utils/app_show_local_snackbar.dart';
import 'package:digipublic_studiant/widgets/copy_right.dart';
import 'package:digipublic_studiant/widgets/input_widget.dart';
import 'package:digipublic_studiant/widgets/primary_button.dart';
import 'package:flutter/material.dart';

// PROJECT IMPORTS

// PACKAGES IMPORTS :
import 'package:animate_do/animate_do.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

class LoginOtpScreen extends StatefulWidget {
  const LoginOtpScreen({super.key});

  @override
  State<LoginOtpScreen> createState() => _LoginOtpScreenState();
}

class _LoginOtpScreenState extends State<LoginOtpScreen> {
  final _otpEditingController = TextEditingController();
  final _userNameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

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
                              Container(
                                width: 180.0,
                                height: 60.0,
                                decoration: const BoxDecoration(
                                    // color: Colors.red,
                                    image: DecorationImage(
                                        image:
                                            AssetImage("assets/logo/logo.png"),
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
                                  "Veillez saisir le code reçu",
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
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0))),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 40.0,
                              ),
                              InputWidget(
                                  inputFocusNode: _userNameFocusNode,
                                  label: "Code otp",
                                  keyboardType: TextInputType.number,
                                  txtEditingController: _otpEditingController),
                              const SizedBox(
                                height: 15.0,
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
                                      label: "Verifier",
                                      onPressed: verifyOtpRequest,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () async {
                                  // Get.toNamed(DigiPublicRouter.resetpassw);
                                },
                                child: const Text(
                                  "Renvoyer le code?",
                                  style: TextStyle(
                                      color: DigiPublicAColors.blackColor),
                                )),
                            const SizedBox(
                              width: 25.0,
                            ),
                          ],
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
  void verifyOtpRequest() async {
    final check = await validateInputs();
    if (check['status']) {
      await securityServiceSingleton.verifyOtp(otp: _otpEditingController.text);
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
    if (_otpEditingController.text.isEmpty ||
        _otpEditingController.text.length < 6 ||
        _otpEditingController.text.length > 20) {
      return {"status": false, "message": "Veuillez saisir un code valide"};
    } else {
      return {"status": true, "message": ""};
    }
  }
}
