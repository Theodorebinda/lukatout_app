import 'dart:convert';
import 'package:digipublic_studiant/common/dio_client.dart';
import 'package:digipublic_studiant/security/security_service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentService {
  final _accessTokenController = BehaviorSubject<String?>();
  final _refreshTokenController = BehaviorSubject<String?>();
  // final _mfaController =
  //     BehaviorSubject<IMFaLoginData>.seeded(IMFaLoginData(mfas: []));

  final _loginSpinnerController = BehaviorSubject<bool>();
  final _globalSpinnerController = BehaviorSubject<bool?>();
  // final _userInfoController = BehaviorSubject<IUser>();

  Stream<String?> get accessTokenStream => _accessTokenController.stream;
  // Stream<IUser> get userInfo => _userInfoController.stream;

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
    // String name = prefs.getString('name') ?? '';

    if (accessToken.isNotEmpty || refreshToken.isNotEmpty) {
      _accessTokenController.add(accessToken);
      _refreshTokenController.add(refreshToken);

      // _userInfoController.add(IUser(
      //   accessToken: accessToken,
      //   email: email,
      //   id: '',
      //   name: name,
      //   phone: phone,
      //   refreshToken: refreshToken,
      // ));
    }
  }

  Future<void> fetchStudent(String taxPayerId) async {
    try {
      String? taxPayerId = await securityServiceSingleton.getTaxPayerId();
      debugPrint("Student ID: $taxPayerId");

      if (taxPayerId == null) {
        debugPrint("Pas Id D'etudiant trouver");
      } else {
        final response = await getWithDio(
            '/id-bio/data-student/3833e3a5-5db9-4fe1-a2b0-f7f896ca45b5');

        debugPrint('Student Response: $response', wrapWidth: 1024);
        debugPrint("Student Response: ${jsonEncode(response)}",
            wrapWidth: 1024);

        if (response['code'] == 200) {
        } else {
          // _personController.addError('Failed to fetch person data');
        }
      }
    } catch (e) {
      // _possessionController.addError('Error fetching possession data: $e');
      debugPrint("Error: $e");
    }
  }

  // Future<void> _storeAccessToken(
  //     String accessToken, String refreshToken) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   // await prefs.clear();

  //   await prefs.setString('accessToken', accessToken);
  //   await prefs.setString('refreshToken', refreshToken);
  // }

  // Future<void> _storeUser(IUser user) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   _userInfoController.add(user);

  //   await prefs.setString('accessToken', user.accessToken);
  //   await prefs.setString('refreshToken', user.refreshToken);
  //   await prefs.setString('id', user.id);
  //   await prefs.setString('email', user.email);
  //   await prefs.setString('phone', user.phone);
  //   await prefs.setString('name', user.name);
  // }

  void dispose() {
    _accessTokenController.close();
    _loginSpinnerController.close();
    _globalSpinnerController.close();
  }
}

final StudentService studentServiceSingleton = StudentService()..init();
