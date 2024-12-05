import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
// import 'package:digipublic_mobile_client/security/security_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';

// ignore: unused_element
Future<String> _getToken() async {
  final prefs = await SharedPreferences.getInstance();

  String accessToken = prefs.getString('accessToken') ?? '';

  debugPrint("Token isNotEmpty : ${accessToken.isNotEmpty}");
  return accessToken;
}

// Récupère les tokens à partir des SharedPreferences
Future<Map<String, String>> _getTokens() async {
  final prefs = await SharedPreferences.getInstance();
  String? mfaToken = prefs.getString('mfaToken');
  String? accessToken = prefs.getString('accessToken');
  String? refreshToken = prefs.getString('refreshToken');

  debugPrint(
      "Access Token isNotEmpty on dio: ${accessToken?.isNotEmpty ?? false}");
  debugPrint("MFA Token isNotEmpty on dio: ${mfaToken?.isNotEmpty ?? false}");
  debugPrint(
      "Refresh Token isNotEmpty on dio: ${refreshToken?.isNotEmpty ?? false}");

  // Retourne un map contenant les deux tokens
  return {
    'accessToken': accessToken ?? '',
    'mfaToken': mfaToken ?? '',
    'refreshToken': refreshToken ?? '',
  };
}

class DeviceInfoInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    // Add device info to the request headers or parameters
    String deviceInfo = '';

    if (options.headers['mobile_device_infos'] == null) {
      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo =
            await deviceInfoPlugin.androidInfo;
        deviceInfo = jsonEncode({
          'manufacturer': androidInfo.manufacturer,
          'model': androidInfo.model,
          'device_id': androidInfo.id,
          'version': androidInfo.version.toString(),
        });
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        deviceInfo = jsonEncode({
          'name': iosInfo.name,
          'model': iosInfo.model,
          'device_id': iosInfo.identifierForVendor,
          'systemVersion': iosInfo.systemVersion,
        });
      }
    }
    options.headers['mobile_device_infos'] = deviceInfo;
    super.onRequest(options, handler);
  }
}

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final tokens = await _getTokens();
    if (tokens['accessToken']?.isNotEmpty ?? false) {
      options.headers['Authorization'] = 'Bearer ${tokens['accessToken']}';
    } else if (tokens['mfaToken']?.isNotEmpty ?? false) {
      // Redirection vers l'écran MFA Login si le MFA token est non nul
      options.headers['Authorization'] = 'Bearer ${tokens['mfaToken']}';
    } else if (tokens['refreshToken']?.isNotEmpty ?? false) {
      options.headers['Authorization'] = 'Bearer ${tokens['refreshToken']}';
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    debugPrint(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');

    // Handle specific error codes
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      // await securityServiceSingleton.logout();
    }

    super.onError(err, handler);
  }
}

class AppTypeInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add app type or other custom headers
    options.headers['app'] = 'mobile';
    super.onRequest(options, handler);
  }
}

Dio _configureDio({Duration timeoutDuration = const Duration(seconds: 120)}) {
  final dio = Dio();

  // Set timeouts as Duration
  dio.options.connectTimeout = timeoutDuration; // Connect timeout
  dio.options.receiveTimeout = timeoutDuration; // Receive timeout

  // Add shared interceptors
  dio.interceptors.addAll([
    DeviceInfoInterceptor(),
    AuthInterceptor(),
    AppTypeInterceptor(),
  ]);

  return dio;
}

FutureOr<dynamic> postWithDio(String endpoint,
    {Map<String, dynamic>? body,
    Map<String, String>? headers,
    Duration timeoutDuration = const Duration(seconds: 60)}) async {
  final dio = _configureDio(timeoutDuration: timeoutDuration);
  final url = _baseUrl + endpoint;

  try {
    final response =
        await dio.post(url, data: body, options: Options(headers: headers));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception('Error : ${response.statusCode}');
    }
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      throw Exception('Request to $endpoint timed out');
    } else {
      throw Exception('Request failed: ${e.message}');
    }
  }
}

FutureOr<dynamic> postFormDataWithDio(String endpoint,
    {FormData? body,
    Map<String, String>? headers,
    Duration timeoutDuration = const Duration(seconds: 60)}) async {
  final dio = _configureDio(timeoutDuration: timeoutDuration);
  final url = _baseUrl + endpoint;

  try {
    final response =
        await dio.post(url, data: body, options: Options(headers: headers));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception('Error : ${response.statusCode}');
    }
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      throw Exception('Request to $endpoint timed out');
    } else {
      throw Exception('Request failed: ${e.message}');
    }
  }
}

FutureOr<dynamic> getWithDio(String endpoint,
    {Map<String, String>? headers,
    Duration timeoutDuration = const Duration(seconds: 60)}) async {
  final dio = _configureDio(timeoutDuration: timeoutDuration);
  final url = _baseUrl + endpoint;

  try {
    final response = await dio.get(url, options: Options(headers: headers));

    if (response.statusCode! >= 200 && response.statusCode! <= 201) {
      return response.data;
    } else {
      throw Exception('Error : ${response.statusCode}');
    }
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      throw Exception('Request to $endpoint timed out');
    } else {
      throw Exception('Request failed: ${e.message}');
    }
  }
}

FutureOr<dynamic> putWithDio(String endpoint,
    {Map<String, dynamic>? body,
    Map<String, String>? headers,
    Duration timeoutDuration = const Duration(seconds: 60)}) async {
  final dio = _configureDio(timeoutDuration: timeoutDuration);
  final url = _baseUrl + endpoint;

  try {
    final response =
        await dio.put(url, data: body, options: Options(headers: headers));

    if (response.statusCode! >= 200 && response.statusCode! <= 201) {
      return response.data;
    } else {
      throw Exception('Error : ${response.statusCode}');
    }
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      throw Exception('Request to $endpoint timed out');
    } else {
      throw Exception('Request failed: ${e.message}');
    }
  }
}

FutureOr<dynamic> deleteWithDio(String endpoint,
    {Map<String, String>? headers,
    Duration timeoutDuration = const Duration(seconds: 60)}) async {
  final dio = _configureDio(timeoutDuration: timeoutDuration);
  final url = _baseUrl + endpoint;

  try {
    final response = await dio.delete(url, options: Options(headers: headers));

    if (response.statusCode! >= 200 && response.statusCode! <= 201) {
      return response.data;
    } else {
      throw Exception('Error : ${response.statusCode}');
    }
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      throw Exception('Request to $endpoint timed out');
    } else {
      throw Exception('Request failed: ${e.message}');
    }
  }
}

FutureOr<dynamic> patchWithDio(String endpoint,
    {Map<String, dynamic>? body,
    Map<String, String>? headers,
    Duration timeoutDuration = const Duration(seconds: 60)}) async {
  final dio = _configureDio(timeoutDuration: timeoutDuration);
  final url = _baseUrl + endpoint;

  try {
    final response =
        await dio.patch(url, data: body, options: Options(headers: headers));

    if (response.statusCode! >= 200 && response.statusCode! <= 201) {
      return response.data;
    } else {
      throw Exception('Error : ${response.statusCode}');
    }
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      throw Exception('Request to $endpoint timed out');
    } else {
      throw Exception('Request failed: ${e.message}');
    }
  }
}
