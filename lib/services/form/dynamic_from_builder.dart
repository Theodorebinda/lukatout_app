import 'package:flutter/material.dart';
import 'package:lukatout/widgets/form_widgets/secondary_select_input.dart';

List<Widget> buildDynamicFields(
  List<Map<String, dynamic>> dynamicFields,
  Map<String, TextEditingController> controllers,
  Map<String, FocusNode> focusNodes,
  void Function(void Function()) setState,
  List<Map<String, dynamic>> genderList,
  String? selectedGenderValue,
) {
  for (var field in dynamicFields) {
    controllers.putIfAbsent(field['proprety'], () => TextEditingController());
    focusNodes.putIfAbsent(field['proprety'], () => FocusNode());
  }

  return dynamicFields.map((field) {
    switch (field['type']) {
      case 'string':
        return TextFormField(
          controller: controllers[field['proprety']],
          decoration: InputDecoration(labelText: field['verbose']),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Veuillez insérer ${field['verbose']}";
            }
            return null;
          },
        );
      case 'email':
        return TextFormField(
          controller: controllers[field['proprety']],
          decoration: InputDecoration(labelText: field['verbose']),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Veuillez insérer le nom de l'entreprise";
            }
            return null;
          },
        );

      case 'select':
        return SecondarySelectInputWidget<dynamic>(
          items: genderList,
          label: 'Sélectionnez le champ ${field['proprety']}',
          itemBuilder: (dynamic item) {
            return Text(item['label'].toString());
          },
          onChanged: (dynamic selectedItem) {
            if (selectedItem != null) {
              setState(() {
                selectedGenderValue = selectedItem['label'];
              });
              debugPrint("selectedItem, $selectedItem");
            }
          },
          validator: (value) {
            if (value == null) {
              return 'Sélectionner le genre';
            }
            return null;
          },
          isMultiSelect: false,
        );

      case 'checkBox':
        return Column(
          children:
              (field['displayColumns'] as List<dynamic>).map<Widget>((option) {
            return CheckboxListTile(
              title: Text(option),
              value: false,
              onChanged: (bool? newValue) {},
            );
          }).toList(),
        );
      default:
        return Container();
    }
  }).toList();
}
