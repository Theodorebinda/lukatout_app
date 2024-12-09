import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:lukatout/constant/colors.dart';
import 'package:lukatout/routes/apps_router.dart';
import 'package:lukatout/security/security_service.dart';

class ChoiseProfilScreen extends StatefulWidget {
  const ChoiseProfilScreen({super.key});

  @override
  State<ChoiseProfilScreen> createState() => _ChoiseProfilScreenState();
}

class _ChoiseProfilScreenState extends State<ChoiseProfilScreen> {
  final _otpEditingController = TextEditingController();
  final _userNameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  late BuildContext _ctx;

  _initFx() async {
    final apiBaseURL = dotenv.env['BASE_URL'];
    debugPrint("apiBaseURL:: $apiBaseURL");

    securityServiceSingleton.accessTokenStream.listen((accessToken) {
      if (accessToken != null) {
        Get.offAllNamed(DigiPublicRouter.home);
      }
    });

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
                  image: AssetImage(
                      "assets/images/young-woman-doing-shopping-online.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 290,
              left: 20,
              child: _buildClickableBlock(
                icon: Icons.arrow_circle_right_outlined,
                onTap: () {
                  Get.toNamed(DigiPublicRouter.login);
                },
              ),
            ),
            const Positioned(
              top: 80,
              left: 10,
              child: Column(
                children: [
                  Image(
                    image: AssetImage("assets/logo/logoluka1w.png"),
                    width: 300,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                ],
              ),
            ),
            const Positioned(
              top: 300,
              left: 20,
              child: Center(
                child: SizedBox(
                  width: 350.0,
                  child: Text(
                    "Ceci n'est pas juste une Application d'achat, c'est votre guide vers l'excellence !",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Roboto",
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClickableBlock({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(95),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 30,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: Colors.brown),
          ],
        ),
      ),
    );
  }
}
