import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lukatout/models/entity.dart';

class SelectInputNormalWidget<T> extends StatelessWidget {
  final List<T> dataList;
  final String label;
  final Widget Function(T) itemBuilder;
  final void Function(T?)? onChanged;
  final bool isMultiSelect;
  final String? Function(T? value)? validator;
  //final T defaultValue;

  const SelectInputNormalWidget({
    super.key,
    required this.dataList,
    required this.label,
    required this.itemBuilder,
    this.onChanged,
    this.isMultiSelect = false,
    this.validator,
    IEntity? selectedEntity,
    String? selectedOptionValue,
    //required this.defaultValue
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FadeInUp(
          from: 20,
          //child: Expanded(
          child: Center(
            child: DropdownButtonFormField<T>(
              items: dataList.map<DropdownMenuItem<T>>((T item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: itemBuilder(item),
                );
              }).toList(),
              isExpanded: true,
              validator: validator,
              onChanged: onChanged,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                labelText: label,
                labelStyle: const TextStyle(
                    color: Color.fromARGB(255, 84, 83, 83),
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
                border: const OutlineInputBorder(),
              ),
              dropdownColor: Colors.grey[100], // Couleur de fond du menu
              style: const TextStyle(
                fontSize: 14, // Taille de texte des éléments de la liste
                color: Colors.black87,
              ),
            ),
          ),
          //),
        ),
      ],
    );
  }
}
