import 'package:digipublic_studiant/models/person.dart';
import 'package:flutter/material.dart';

class PersonProvider extends ChangeNotifier {
  IPerson? _currentPerson = IPerson.empty();
  Map<String, dynamic>? _currentCorporation = {};

  IPerson? get currentPerson => _currentPerson;
  Map<String, dynamic>? get currentCorporation => _currentCorporation;

  void setPerson(IPerson person) {
    _currentPerson = person;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void setCorporation(Map<String, dynamic> corporation) {
    _currentCorporation = corporation;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Méthode pour réinitialiser la personne
  void clearCporporation() {
    _currentCorporation = {};
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Méthode pour réinitialiser la personne
  void clearPerson() {
    _currentPerson = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
