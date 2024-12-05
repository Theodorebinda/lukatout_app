import 'package:digipublic_studiant/screens/auth/choise_profile/choise_profil.dart';
import 'package:digipublic_studiant/screens/auth/login/login_mfa_screen.dart';
import 'package:digipublic_studiant/screens/auth/login/login_otp_screen.dart';
import 'package:digipublic_studiant/screens/auth/login/login_screen.dart';
import 'package:digipublic_studiant/screens/auth/resetpass/reset_password.dart';
import 'package:digipublic_studiant/screens/auth/sign_up/sign_up.dart';
import 'package:digipublic_studiant/screens/auth/sign_up/home_page_screen.dart';
import 'package:digipublic_studiant/screens/auth/sign_up/stape_sign/stape_page_screen.dart';
import 'package:digipublic_studiant/screens/dashboard/dashboard_screen.dart';
import 'package:digipublic_studiant/screens/home/home_screen.dart';
import 'package:digipublic_studiant/screens/profile/profile_screen.dart';
import 'package:digipublic_studiant/screens/submenu/selected_submenu_page.dart';
import 'package:get/get.dart';

class DigiPublicRouter {
  static String choiseProfil = '/choiceProfil';
  static String login = '/login';
  static String home = '/home';
  static String homePage = '/homePage';
  static String resetPassw = '/resetPassw';
  static String signUp = '/signUp';
  static String subMenu = '/subMenu';
  static String selectedSubMenu = '/selectedSubmenu';
  static String profile = '/profile';
  static String dashboard = '/dashboard';
  static String otp = '/otp';
  static String stapePage = '/stapePage';
  static String loginMfa = '/loginmfa';

  static String getHomeRoute() => home;
  static String getHomePageRoute() => home;
  static String getLoginRoute() => login;
  static String getChoiseProfilScreen() => choiseProfil;
  static String getOtpRoute() => otp;
  static String getStapePage() => stapePage;
  static String getLoginMfaRoute() => loginMfa;
  static String getResetPasswRoute() => resetPassw;
  static String getSignUpScreen() => signUp;
  static String getSubMenuRoute() => subMenu;
  static String getSelectedSubMenuRoute() => selectedSubMenu;
  static String getProfileRoute() => profile;
  static String getDashboardRoute() => dashboard;

  static List<GetPage> routes = [
    // GetPage(name: login, page: () => const LoginScreen()),

    GetPage(
        name: choiseProfil,
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 800),
        page: () => const ChoiseProfilScreen()),
    GetPage(
        name: login,
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 800),
        page: () => const LoginScreen()),
    GetPage(
        name: loginMfa,
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 800),
        page: () => const LoginMfaScreen()),
    GetPage(
        name: otp,
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 800),
        page: () => const LoginOtpScreen()),
    GetPage(
        name: stapePage,
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 800),
        page: () => const StapePage()),
    GetPage(
        name: home,
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 800),
        page: () => const HomeScreen()),
    GetPage(
        name: homePage,
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 800),
        page: () => const HomePageScreen()),
    GetPage(
        name: profile,
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 800),
        page: () => const ProfileScreen()),
    GetPage(
        name: dashboard,
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 800),
        page: () => const DashboardScreen()),
    GetPage(
        name: subMenu,
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 800),
        page: () => const SelectedSubMenuPage()),
    GetPage(
        name: resetPassw,
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 800),
        page: () => const ResetPasswordScreen()),
    GetPage(
        name: signUp,
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 800),
        page: () => const SignUpPage()),
  ];
}
