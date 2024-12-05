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
                  opacity: .8,
                  image: AssetImage("assets/images/bg-img.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildClickableBlock(
                    label: "Étudiant",
                    icon: Icons.school,
                    onTap: () {
                      Get.toNamed(DigiPublicRouter.login);
                    },
                  ),
                  _buildClickableBlock(
                    label: "Professeur",
                    icon: Icons.person,
                    onTap: () {
                      Get.toNamed(DigiPublicRouter.login);
                    },
                  ),
                ],
              ),
            ),
            const Positioned(bottom: 10, left: 0, right: 0, child: Text('data')
                //  CopyRightWidget(),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildClickableBlock({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: DigiPublicAColors.primaryColor),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
