import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/config/config.dart';
import 'package:get/get.dart';
import 'package:lukatout/common/dio_client.dart';
import 'package:lukatout/constant/colors.dart';
import 'package:lukatout/security/security_service.dart';
// import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

class CommonService {
  // Controllers pour gérer les menus et le menu sélectionné
  final _appMenuController = BehaviorSubject<List<IAppMenu>>();
  final _appSelectedMenuController = BehaviorSubject<IAppMenu>();
  final _appPersonFormController =
      BehaviorSubject<List<Map<String, dynamic>>>();
  final _appPersonController = BehaviorSubject<Map<String, dynamic>>();
  final _appEntityController = BehaviorSubject<List<IEntity>>.seeded([]);
  final _appAllEntityController = BehaviorSubject<List<IEntity>>.seeded([]);

  // Streams exposés pour le menu et le menu sélectionné
  Stream<List<IAppMenu>> get appMenuStream => _appMenuController.stream;
  Stream<IAppMenu> get appSelectedMenuStream =>
      _appSelectedMenuController.stream;
  Stream<List<Map<String, dynamic>>> get appPersonFormStream =>
      _appPersonFormController.stream;
  ValueStream<List<IEntity>> get entityStream => _appEntityController.stream;
  ValueStream<List<IEntity>> get allEntityStream =>
      _appAllEntityController.stream;

  // Fonction pour définir le menu sélectionné
  void setSelectedMenu(IAppMenu selectedMenu) {
    debugPrint('Selected menu: $selectedMenu');
    _appSelectedMenuController.add(selectedMenu);
  }

  // Fonction pour récupérer le menu depuis l'API
  Future<void> fetchAppMenu() async {
    _showLoadingSpinner();
    try {
      debugPrint('Fetching menu...');
      final response = await getWithDio('/core/menu?include__subMenus=true');
      // debugPrint('Response: ${response["data"].toString()}');
      final List<IAppMenu> menuList = _parseMenu(response['data']);
      if (!_appMenuController.isClosed) {
        _appMenuController.add(menuList);
      }
    } catch (error) {
      _handleError('Error fetching menu', error);
    } finally {
      _hideLoadingSpinner();
    }
  }

  // Fonction pour récupérer un chemin sélectionné depuis l'API
  Future<void> getSelectedPath(String url) async {
    _showLoadingSpinner();
    try {
      // debugPrint('Fetching data from path: $url');
      final response = await getWithDio(url);
      debugPrint('Response: ${response["data"]["data"]}');
    } catch (error, stackTrace) {
      _handleError('Error fetching selected path', error, stackTrace);
    } finally {
      _hideLoadingSpinner();
    }
  }

  Future<Map<String, dynamic>?> createPerson(
      String url, Map<String, dynamic> content) async {
    final headers = {
      'application-id': '123e4567-e89b-12d3-a456-426614174000',
      'api-key':
          'a1b2c3d4e5f6g7h8i9j0k1l2m3n4p5q6r7s8t9u0v1w2x3y4z5a6b7c8d9e0f1g2h3',
      'application-key': '123e4567-e89b-12d3-a456-426614174000',
      'Content_Type': 'application/json',
    };
    try {
      securityServiceSingleton.showGlobalSpinners();
      final dynamic response =
          await postWithDio(url, body: content, headers: headers);
      debugPrint('response $response');
      final Map<String, dynamic> personData = response['data'];
      debugPrint('new operation data : $personData');
      _appPersonController.add(personData);
      securityServiceSingleton.hideGlobalSpinners();
      return response;
    } catch (e) {
      securityServiceSingleton.hideGlobalSpinners();
      debugPrint('Error during fetch operations: $e');
      //debugPrint('Stack trace: $stack');
      appShowGetXSnackBarFx(
        title: "Oops!",
        subtitle: 'Error: $e.',
        bgcolor: DigiPublicAColors.redColor,
        position: SnackPosition.TOP,
      );
    }
    return null;
  }

  Future<Map<String, dynamic>> fetchDynamicForm(String url) async {
    try {
      securityServiceSingleton.showGlobalSpinners();
      final dynamic response = await getWithDio("/id-bio/student/head");
      securityServiceSingleton.hideGlobalSpinners();
      debugPrint('DynamicForm $response');
      if (response != null) {
        // Si 'data' est une liste, retournez-la sous forme de Map
        if (response['data'] is List) {
          final List<Map<String, dynamic>> dataList =
              List<Map<String, dynamic>>.from(response['data']);
          _appPersonFormController
              .add(dataList); // Ajouter la liste au controller
          return {'data': dataList}; // Retourner un Map contenant la liste
        } else {
          _appPersonFormController
              .add([]); // Ajouter une liste vide si 'data' n'est pas une liste
          return {}; // Retourner un Map vide si 'data' n'est pas trouvé
        }
      } else {
        _appPersonFormController
            .add([]); // Retourner une liste vide si la réponse est nulle
        return {}; // Retourner un Map vide en cas de réponse nulle
      }
    } catch (e) {
      securityServiceSingleton.hideGlobalSpinners();
      debugPrint('Error during fetch form: $e');
      appShowGetXSnackBarFx(
        title: "Oops!",
        subtitle: 'Error: $e.',
        bgcolor: DigiPublicAColors.redColor,
        position: SnackPosition.TOP,
      );
      return {}; // Retourner un Map vide en cas d'erreur
    }
  }

  Future<Map<String, dynamic>> fetchAllEntities() async {
    List<IEntity> entityList = [];
    final headers = {
      'application-id': '123e4567-e89b-12d3-a456-426614174000',
      'api-key':
          'a1b2c3d4e5f6g7h8i9j0k1l2m3n4p5q6r7s8t9u0v1w2x3y4z5a6b7c8d9e0f1g2h3',
      'application-key': '123e4567-e89b-12d3-a456-426614174000',
      'Content_Type': 'application/json',
    };
    try {
      String url =
          '/core/entity?parent=null&include__childrens__include__childrens__include__childrens=true';
      securityServiceSingleton.showGlobalSpinners();
      final response = await getWithDio(url, headers: headers);
      List<dynamic> entityData = response['data'];

      // debugPrint('Entity List ok >>>>>>>>>>>> : ${entityData.length}',
      //     wrapWidth: 1024);
      if (entityData.isNotEmpty) {
        for (var entity in entityData) {
          // entityList.add(entity);
          entityList.add(IEntity.fromJson(entity));
        }
      }

      _appAllEntityController.add(entityList);
      securityServiceSingleton.hideGlobalSpinners();
      return {"success": true, "data": entityList};
    } catch (e, stack) {
      securityServiceSingleton.hideGlobalSpinners();
      return {"success": false, "data": entityList};
    }
  }

//   Future<Map<String, dynamic>> fetchDynamicForm() async {
//   const endpoint = '/form/dynamic'; // Remplacez par votre endpoint réel.
//   return await getWithDio(endpoint);
// }

  Future<Map<String, dynamic>> getPersonHead(String url) async {
    final headers = {
      'application-id': '123e4567-e89b-12d3-a456-426614174000',
      'api-key':
          'a1b2c3d4e5f6g7h8i9j0k1l2m3n4p5q6r7s8t9u0v1w2x3y4z5a6b7c8d9e0f1g2h3',
      'application-key': '123e4567-e89b-12d3-a456-426614174000',
      'Content_Type': 'application/json',
    };

    try {
      securityServiceSingleton.showGlobalSpinners();
      final dynamic response = await getWithDio(url, headers: headers);
      securityServiceSingleton.hideGlobalSpinners();
      debugPrint('Person head data: $response');

      if (response != null && response['data'] is List) {
        final List<Map<String, dynamic>> dataList =
            List<Map<String, dynamic>>.from(response['data']);
        _appPersonFormController
            .add(dataList); // Ajouter la liste au contrôleur
        return {'data': dataList};
      } else {
        _appPersonFormController
            .add([]); // Ajouter une liste vide si pas de données
        return {};
      }
    } catch (e) {
      securityServiceSingleton.hideGlobalSpinners();
      debugPrint('Erreur lors de la récupération des données: $e');
      appShowGetXSnackBarFx(
        title: "Oops!",
        subtitle: 'Error: $e.',
        bgcolor: DigiPublicAColors.redColor,
        position: SnackPosition.TOP,
      );
      return {};
    }
  }

  // Future<void> getEntities(String url) async {
  //   final headers = {
  //     'application-id': '123e4567-e89b-12d3-a456-426614174000',
  //     'api-key':
  //         'a1b2c3d4e5f6g7h8i9j0k1l2m3n4p5q6r7s8t9u0v1w2x3y4z5a6b7c8d9e0f1g2h3',
  //     'application-key': '123e4567-e89b-12d3-a456-426614174000',
  //     'Content_Type': 'application/json',
  //   };
  //   try {
  //     securityServiceSingleton.showGlobalSpinners();
  //     final response = await getWithDio(url, headers: headers);
  //     List<dynamic> entityData = response['data'];
  //     List<IEntity> entityList = [];
  //     debugPrint('Entity List : $entityData');
  //     if (entityData.isNotEmpty) {
  //       for (var entity in entityData) {
  //         //entityList.add(entity);
  //         entityList.add(IEntity.fromJson(entity));
  //       }
  //     }
  //     _appEntityController.add(entityList);
  //     securityServiceSingleton.hideGlobalSpinners();
  //   } catch (e, stack) {
  //     securityServiceSingleton.hideGlobalSpinners();
  //     debugPrint('Error during fetch operations: $e');
  //     debugPrint('Stack trace: $stack');
  //     appShowGetXSnackBarFx(
  //       title: "Oops!",
  //       subtitle: 'Error: $e',
  //       bgcolor: DigiPublicAColors.redColor,
  //       position: SnackPosition.TOP,
  //     );
  //   }
  // }

  Future<void> geAllEntities(String url) async {
    final headers = {
      'application-id': '123e4567-e89b-12d3-a456-426614174000',
      'api-key':
          'a1b2c3d4e5f6g7h8i9j0k1l2m3n4p5q6r7s8t9u0v1w2x3y4z5a6b7c8d9e0f1g2h3',
      'application-key': '123e4567-e89b-12d3-a456-426614174000',
      'Content_Type': 'application/json',
    };
    try {
      securityServiceSingleton.showGlobalSpinners();
      final response = await getWithDio(url, headers: headers);
      List<dynamic> entityData = response['data'];
      List<IEntity> entityList = [];
      debugPrint('Entity List : $entityData', wrapWidth: 1024);
      if (entityData.isNotEmpty) {
        for (var entity in entityData) {
          //entityList.add(entity);
          entityList.add(IEntity.fromJson(entity));
        }
      }
      _appAllEntityController.add(entityList);
      securityServiceSingleton.hideGlobalSpinners();
    } catch (e, stack) {
      securityServiceSingleton.hideGlobalSpinners();
      debugPrint('Error during fetch operations: $e');
      debugPrint('Stack trace: $stack');
      appShowGetXSnackBarFx(
        title: "Oops!",
        subtitle: 'Error: $e',
        bgcolor: DigiPublicAColors.redColor,
        position: SnackPosition.TOP,
      );
    }
  }

  // Fonction pour nettoyer les contrôleurs
  void dispose() {
    _appMenuController.close();
    _appSelectedMenuController.close();
  }

  // Méthode utilitaire pour afficher le spinner
  void _showLoadingSpinner() {
    securityServiceSingleton.showGlobalSpinners();
  }

  // Méthode utilitaire pour cacher le spinner
  void _hideLoadingSpinner() {
    securityServiceSingleton.hideGlobalSpinners();
  }

  // Méthode utilitaire pour parser la réponse du menu
  List<IAppMenu> _parseMenu(List<dynamic> menus) {
    if (menus.isEmpty) return [];
    return menus.map((menu) => IAppMenu.fromJson(menu)).toList();
  }

  // Méthode utilitaire pour gérer les erreurs et afficher un snackbar
  void _handleError(String message, Object error, [StackTrace? stackTrace]) {
    debugPrint('$message: $error');
    if (stackTrace != null) {
      debugPrint('Stack trace: $stackTrace');
    }
    // appShowGetXSnackBarFx(
    //   title: "Oops!",
    //   subtitle: 'Error: $error',
    //   bgcolor: DigiPublicAColors.redColor,
    //   position: SnackPosition.TOP,
    // );
  }
}
