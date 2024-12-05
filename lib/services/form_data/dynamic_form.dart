import 'dart:convert';
import 'package:digipublic_studiant/common/dio_client.dart';
import 'package:digipublic_studiant/models/form_dynamic_student.dart';
import 'package:digipublic_studiant/security/security_service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormService {
  final _dynamicFormStudent = BehaviorSubject<IFormulary>();

  Future<void> init() async {
    // _dynamicFormStudent.add();
    final prefs = await SharedPreferences.getInstance();

    final keys = prefs.getKeys();
    for (String key in keys) {
      var value = prefs.get(key);
      debugPrint("$key: $value", wrapWidth: 1024);
    }
  }

  Future<void> fetchForm() async {
    try {
      final response = await getWithDio('/id-bio/person/head');

      debugPrint('Student Response: $response', wrapWidth: 1024);
      debugPrint("Student Response: ${jsonEncode(response)}", wrapWidth: 1024);

      if (response['code'] == 200) {
        debugPrint("Student Response: ${jsonEncode(response)}",
            wrapWidth: 1024);

        final dynamicFormStudent = IFormulary.fromJson(response['data']);

        _dynamicFormStudent.add(dynamicFormStudent);
        _storeFormStudent(dynamicFormStudent);
      } else {
        _dynamicFormStudent.addError('Failed to fetch person data');
      }
    } catch (e) {
      // _possessionController.addError('Error fetching possession data: $e');
      debugPrint("Error: $e");
    }
  }

  Future<void> _storeFormStudent(IFormulary form) async {
    final prefs = await SharedPreferences.getInstance();
    _dynamicFormStudent.add(form);

    await prefs.setString('property', form.property);
    await prefs.setString('type', form.type);
  }

  void dispose() {
    _dynamicFormStudent.close();
  }
}

final FormService formServiceSingleton = FormService()..init();
