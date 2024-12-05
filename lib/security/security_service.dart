import 'dart:convert';

import 'package:digipublic_studiant/common/dio_client.dart';
import 'package:digipublic_studiant/constant/colors.dart';
import 'package:digipublic_studiant/models/mfa.dart';
import 'package:digipublic_studiant/models/taxpayer.dart';
import 'package:digipublic_studiant/models/user.dart';
import 'package:digipublic_studiant/routes/apps_router.dart';
import 'package:digipublic_studiant/utils/app_show_local_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/subjects.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityService {
  String? studentId;

  final _accessTokenController = BehaviorSubject<String?>();
  final _refreshTokenController = BehaviorSubject<String?>();
  final _mfaController =
      BehaviorSubject<IMFaLoginData>.seeded(IMFaLoginData(mfas: []));

  final _loginSpinnerController = BehaviorSubject<bool>();
  final _globalSpinnerController = BehaviorSubject<bool?>();
  final _userInfoController = BehaviorSubject<IUser>();
  // GET
  // String? _accessToken;
  Stream<String?> get accessTokenStream => _accessTokenController.stream;
  Stream<String?> get refreshTokenStream => _refreshTokenController.stream;
  Stream<bool?> get loginSpinStream => _loginSpinnerController.stream;
  Stream<bool?> get globalSpinStream => _globalSpinnerController.stream;
  Stream<IUser> get userInfo => _userInfoController.stream;
  Stream<IMFaLoginData> get mfaController => _mfaController.stream;

  hideSpinners() {
    // HIDE SPINNER
    _loginSpinnerController.add(false);
  }

  showGlobalSpinners() {
    _globalSpinnerController.add(true);
  }

  hideGlobalSpinners() {
    _globalSpinnerController.add(false);
  }

  Future<void> init() async {
    _globalSpinnerController.add(false);
    final prefs = await SharedPreferences.getInstance();

    final keys = prefs.getKeys();
    for (String key in keys) {
      var value = prefs.get(key);
      debugPrint("$key: $value", wrapWidth: 1024);
    }

    String accessToken = prefs.getString('accessToken') ?? '';
    String refreshToken = prefs.getString('refreshToken') ?? '';
    String name = prefs.getString('name') ?? '';
    String email = prefs.getString('email') ?? '';
    String phone = prefs.getString('phone') ?? '';
    debugPrint("accessToken :: $accessToken");
    debugPrint("refreshToken :: $refreshToken");

    if (accessToken.isNotEmpty || refreshToken.isNotEmpty) {
      _accessTokenController.add(accessToken);
      _refreshTokenController.add(refreshToken);

      _userInfoController.add(IUser(
        accessToken: accessToken,
        email: email,
        id: '',
        name: name,
        phone: phone,
        refreshToken: refreshToken,
      ));
    }
  }

  Future<void> _clearAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('mfaToken');
    await prefs.remove('refreshToken');
    await prefs.clear();
  }

  Future<void> login(String email, String password) async {
    try {
      // SHOW SPINNER
      _loginSpinnerController.add(true);
      final Map<String, dynamic> body = {
        'identifier': email,
        'password': password
      };

      var response = await postWithDio('/auth/login', body: body);
      // debugPrint("response : $response");

      debugPrint("Login Response: ${jsonEncode(response)}", wrapWidth: 1024);
      if (response['code'] == 200) {
        final IUser user = IUser.fromData(response['data']);
        final List<dynamic> mfas = response['data']['mfas'];
        final List<IMfa> formattedList = [];
        for (var element in mfas) {
          formattedList.add(IMfa.fromData(element));
        }
        _userInfoController.add(user);
        if (response['data']['redirectToOTP'] == true) {
          // Navigate to OTP verification screen
          await _storeMfaToken(response['data']['token']);
          _mfaController.add(IMFaLoginData(mfas: formattedList));
          Get.offAllNamed(DigiPublicRouter.loginMfa);

          /// Assuming you're using GetX for navigation
        } else {
          // debugPrint(response['data']);
          debugPrint(response['data']['message']);

          _storeAccessToken(response['data']['token']['accessToken'],
              response['data']['token']['refreshToken']);
          _accessTokenController.add(response['data']['token']['accessToken']);
          Get.offAllNamed(DigiPublicRouter.choiseProfil);
          // Get.offAllNamed(DigiPublicRouter.home);
          //  Get.offAllNamed(DigiPublicRouter.loginMfa);
        }

        // await _saveAccessToken(response['data']['token']['accessToken']);
        //_mfaController.add(IMFaLoginData(mfas: formattedList));
        Get.offAllNamed(DigiPublicRouter.loginMfa);
      } else {
        // HIDE SPINNER
        _loginSpinnerController.add(false);
        Get.offAllNamed(DigiPublicRouter.choiseProfil);
        appShowGetXSnackBarFx(
            title: "Oops !",
            subtitle: response["message"],
            bgcolor: DigiPublicAColors.redColor,
            position: SnackPosition.TOP);
      }
    } catch (e) {
      // HIDE SPINNER
      _loginSpinnerController.add(false);
      Get.offAllNamed(DigiPublicRouter.choiseProfil);
      debugPrint('Error during login: $e');
      // SHOW SNACK BAR
      appShowGetXSnackBarFx(
          title: "Oops !",
          subtitle: 'Error : something went wrong while trying to login',
          bgcolor: DigiPublicAColors.redColor,
          position: SnackPosition.TOP);
    }
  }

  Future<void> sendOtp(String mfaflag) async {
    try {
      // SHOW SPINNER
      _loginSpinnerController.add(true);

      var response = await getWithDio('/auth/sent-spec-otp?mfa_type=$mfaflag');
      // _loginSpinnerController.add(false);

      debugPrint("response code : $response");
      if (response['code'] == 200) {
        appShowGetXSnackBarFx(
            title: "Yeah !",
            subtitle: response['message'],
            bgcolor: DigiPublicAColors.greenColor,
            position: SnackPosition.TOP);
        Get.offAllNamed(DigiPublicRouter.otp);
      } else {
        appShowGetXSnackBarFx(
            title: "Oops !",
            subtitle: response['message'],
            bgcolor: DigiPublicAColors.redColor,
            position: SnackPosition.TOP);
      }

      // HIDE SPINNER
      _loginSpinnerController.add(false);
    } catch (e) {
      // HIDE SPINNER
      _loginSpinnerController.add(false);

      debugPrint('Error during login: $e');
      // SHOW SNACK BAR
      appShowGetXSnackBarFx(
          title: "Oops !",
          subtitle: 'Une erreur est survenue lors de cette opération',
          bgcolor: DigiPublicAColors.redColor,
          position: SnackPosition.TOP);
    }
  }

  Future<void> verifyOtp({required String otp}) async {
    try {
      // SHOW SPINNER
      _loginSpinnerController.add(true);
      final Map<String, dynamic> body = {'otp': otp};

      var response = await postWithDio('/auth/check-otp', body: body);
      _loginSpinnerController.add(false);

      debugPrint("responseVerifyOTPtheodorebinda : $response", wrapWidth: 1024);
      if (response['code'] == 200) {
        final IUser user = IUser.fromJson(response['data']['user']);
        final ITaxPayer taxPayer =
            ITaxPayer.fromJson(response['data']['user']['taxPayer']);
        final String taxPayerId = taxPayer.id; // Récupérer l'ID d'Etudiant
        // final String userId = user.id;

        await _storeTaxPayerId(taxPayerId);
        debugPrint("taxPayerId: $taxPayerId");
        debugPrint("taxPayerId: $user");
        _storeUser(user);
        _userInfoController.add(user);
        // storeStudent(student);
        // _studentController.add(student);

        await _storeAccessToken(response['data']['token']['accessToken'],
            response['data']['token']['refreshToken']);
        _accessTokenController.add(response['data']['token']['accessToken']);
        _refreshTokenController.add(response['data']['token']['refreshToken']);

        Get.offAllNamed(DigiPublicRouter.home);
      } else {
        appShowGetXSnackBarFx(
            title: "Oops !",
            subtitle: response.message,
            bgcolor: DigiPublicAColors.redColor,
            position: SnackPosition.TOP);
      }
    } catch (e) {
      // HIDE SPINNER
      _loginSpinnerController.add(false);

      debugPrint('Error during login: $e');
      // SHOW SNACK BAR
      appShowGetXSnackBarFx(
          title: "Oops !",
          subtitle: 'Une erreur est survenue lors cette opération',
          bgcolor: DigiPublicAColors.redColor,
          position: SnackPosition.TOP);
    }
  }

  Future<void> logout() async {
    try {
      _globalSpinnerController.add(true);
      var response = await postWithDio('/auth/logout');
      debugPrint("LogoutMessage: $response");

      if (response['code'] == 200) {
        await _clearAccessToken();
        // Emit an event to redirect to the login page
        _accessTokenController.add(null);
        _globalSpinnerController.add(false);
        debugPrint('logout succeed: ');
        appShowGetXSnackBarFx(
            title: " Déconnexion Réussie  !",
            subtitle: "A Tres Bientot",
            bgcolor: DigiPublicAColors.greenColor,
            position: SnackPosition.TOP);
        Get.offAllNamed(DigiPublicRouter.login);
      }
    } catch (e) {
      debugPrint('logout failed $e: ');
      // Emit an event to redirect to the login page
      _accessTokenController.add(null);
      _globalSpinnerController.add(false);
      await _clearAccessToken();
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      final Map<String, dynamic> body = {'email': email};
      await postWithDio('/auth/reset-password', body: body);
    } catch (e) {
      debugPrint('Error reset request: $e');
    }
  }

  // Future<void> _saveAccessToken(dynamic token) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('accessToken', token);
  // }

  Future<void> _storeMfaToken(String token) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('mfaToken', token);
  }

  Future<void> _storeAccessToken(
      String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    // await prefs.clear();

    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
  }

  Future<void> _storeUser(IUser user) async {
    final prefs = await SharedPreferences.getInstance();
    _userInfoController.add(user);

    await prefs.setString('accessToken', user.accessToken);
    await prefs.setString('refreshToken', user.refreshToken);
    await prefs.setString('id', user.id);
    await prefs.setString('email', user.email);
    await prefs.setString('phone', user.phone);
    await prefs.setString('name', user.name);
  }

  Future<void> _storeTaxPayerId(String taxPayerId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('taxPayerId', taxPayerId);
  }

  Future<String?> getTaxPayerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('taxPayerId');
  }

  void dispose() {
    _accessTokenController.close();
    _loginSpinnerController.close();
    _userInfoController.close();
    _globalSpinnerController.close();
  }
}

final SecurityService securityServiceSingleton = SecurityService()..init();
