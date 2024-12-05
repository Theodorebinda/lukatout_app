import 'package:flutter/material.dart';
import 'package:lukatout/models/university.dart';

class FormRecapProvider extends ChangeNotifier {
  // IPerson? _currentPerson = IPerson.empty();
  IUniversity _studentSelections = IUniversity.empty();
  IFaculty _selectedFaculty = IFaculty.empty();
  IOption _selectedOption = IOption.empty();

  IUniversity? get studentSelections => _studentSelections;
  IFaculty? get selectedFaculty => _selectedFaculty;
  IOption? get selectedOption => _selectedOption;

  // void setPerson(IPerson person) {
  //   _currentPerson = person;
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     notifyListeners();
  //   });
  // }

  void setUniversity(IUniversity university) {
    _studentSelections = university;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void setFaculty(IFaculty faculty) {
    _selectedFaculty = faculty;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void setOption(IOption option) {
    _selectedOption = option;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Méthode pour réinitialiser la personne
  void clearFaculty() {
    _selectedFaculty = IFaculty.empty();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void clearOption() {
    _selectedOption = IOption.empty();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
