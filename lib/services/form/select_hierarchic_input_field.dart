import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class SelectHierarchicInputField<T> extends StatelessWidget {
  final Stream<List<T>?> stream;
  final String label;
  final Widget Function(T, int)
      itemBuilder; // Fonction pour construire l'élément avec un niveau
  final void Function(T?)? onChanged;
  final bool isMultiSelect;
  final String? Function(T? value)? validator;

  // Ajout de fonctions pour déterminer parent/enfant
  final bool Function(T) isParent;
  final int Function(T) getParentLevel;

  const SelectHierarchicInputField({
    super.key,
    required this.stream,
    required this.label,
    required this.itemBuilder,
    required this.isParent,
    required this.getParentLevel,
    this.onChanged,
    this.isMultiSelect = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FadeInUp(
          from: 20,
          child: StreamBuilder<List<T>?>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text("Oops! Something went wrong"),
                );
              } else {
                var data = snapshot.data;
                if (data == null || data.isEmpty) {
                  return const Center(
                    child: Text("No data available"),
                  );
                } else {
                  return DropdownButtonFormField<T>(
                    items: data.map<DropdownMenuItem<T>>((T item) {
                      // Déterminer le niveau de profondeur de l'élément
                      int level = isParent(item) ? 0 : getParentLevel(item);
                      return DropdownMenuItem<T>(
                        value: item,
                        child: itemBuilder(item,
                            level), // Passer le niveau pour gérer l'indentation
                      );
                    }).toList(),
                    validator: validator,
                    onChanged: onChanged,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      labelText: label,
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 84, 83, 83),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  );
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
