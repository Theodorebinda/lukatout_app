import 'package:flutter/material.dart';
import 'package:lukatout/models/entity.dart';

class EntitySelectionProvider extends ChangeNotifier {
  // Entités sélectionnées
  IEntity? _selectedProvinceEntity = IEntity.empty();
  IEntity? _selectedCityEntity = IEntity.empty();
  IEntity? _selectedTownshipEntity = IEntity.empty();

  // Getters
  IEntity? get selectedProvinceEntity => _selectedProvinceEntity;
  IEntity? get selectedCityEntity => _selectedCityEntity;
  IEntity? get selectedTownshipEntity => _selectedTownshipEntity;

  // Setter explicite pour la province
  // void setProvinceEntity(IEntity entity) {
  //   _selectedProvinceEntity = entity;
  //   _selectedCityEntity = null; // Réinitialiser la ville
  //   _selectedTownshipEntity = null; // Réinitialiser la commune
  //   notifyListeners();
  // }

  void setProvinceEntity(IEntity entity) {
    _selectedProvinceEntity = entity;
    _selectedCityEntity = null; // Réinitialiser la ville
    _selectedTownshipEntity = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Setter explicite pour la ville
  // void setCityEntity(IEntity entity) {
  //   _selectedCityEntity = entity;
  //   _selectedTownshipEntity = null; // Réinitialiser la commune
  //   notifyListeners();
  // }

  void setCityEntity(IEntity entity) {
    _selectedCityEntity = entity;
    _selectedTownshipEntity = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Setter explicite pour la commune
  // void setTownshipEntity(IEntity entity) {
  //   _selectedTownshipEntity = entity;
  //   notifyListeners();
  // }
  void setTownshipEntity(IEntity entity) {
    _selectedTownshipEntity = entity;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void clearAllEntity() {
    _selectedCityEntity = IEntity.empty();
    _selectedProvinceEntity = IEntity.empty();
    _selectedTownshipEntity = IEntity.empty();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Méthode pour filtrer les entités par parentId
  List<IEntity> filterEntitiesByParentId(
      List<IEntity> entities, int? parentId) {
    return entities.where((entity) => entity.parentNumber == parentId).toList();
  }

  // Méthodes de filtrage pour chaque niveau de l'entité
  List<IEntity> filterProvinces(List<IEntity> entities) {
    return filterEntitiesByParentId(
        entities, 0); // Filtrer les provinces (parentNumber == 0)
  }

  List<IEntity> filterCities(List<IEntity> entities, int? provinceId) {
    return filterEntitiesByParentId(entities, provinceId);
  }

  List<IEntity> filterTownships(List<IEntity> entities, int? cityId) {
    return filterEntitiesByParentId(entities, cityId);
  }
}
