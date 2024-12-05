// FLUTTER IMPORTS:
import 'package:digipublic_studiant/routes/apps_router.dart';
import 'package:digipublic_studiant/security/security_service.dart';
import 'package:digipublic_studiant/widgets/copy_right.dart';
import 'package:digipublic_studiant/widgets/input_widget.dart';
import 'package:digipublic_studiant/widgets/primary_button.dart';
import 'package:flutter/material.dart';

// PROJECT IMPORTS

// PACKAGES IMPORTS :
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _usernameEditingController = TextEditingController();
  final _userNameFocusNode = FocusNode();

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

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Mot de passe oublié"),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: _cancelFocusedInput,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                    FadeInDown(
                      from: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 180.0,
                            height: 180.0,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/logo/logo.png"),
                                    fit: BoxFit.contain)),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    InputWidget(
                        inputFocusNode: _userNameFocusNode,
                        label: "Nom d'utilisateur",
                        keyboardType: TextInputType.text,
                        txtEditingController: _usernameEditingController),
                    const SizedBox(
                      height: 20,
                    ),
                    PrimaryButton(
                      activityIsRunning: false,
                      label: "Suivant",
                      onPressed: loginRequest,
                    ),
                  ],
                ),
              ),
            ),
            const CopyRightWidget(),
            const SizedBox(
              height: 25.0,
            ),
          ],
        ),
      ),
    );
  }

  // Example of using the login method
  void loginRequest() async {
    await securityServiceSingleton.resetPassword(
      _usernameEditingController.text,
    );
  }
}
