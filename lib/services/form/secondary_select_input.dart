import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class SecondarySelectInputWidget<T> extends StatelessWidget {
  final List<T>? items;
  final String label;
  final Text Function(T) itemBuilder;
  final void Function(T?)? onChanged;
  final bool isMultiSelect;
  final String? Function(T? value)? validator;
  final T? selectedValue; // Add this to manage the selected value

  const SecondarySelectInputWidget({
    super.key,
    this.items,
    required this.label,
    required this.itemBuilder,
    this.onChanged,
    this.isMultiSelect = false,
    this.validator,
    this.selectedValue, // Add this to manage the selected value
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          FadeInUp(
            from: 20,
            child: items == null
                ? Center(
                    child: DropdownButtonFormField<String>(
                      items: const [
                        DropdownMenuItem<String>(
                          value: "no_data",
                          child: Text("No data available"),
                        ),
                      ],
                      onChanged:
                          null, // Disable selection as it's just a message
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        labelText: "No Data",
                        labelStyle: TextStyle(
                            color: Color.fromARGB(255, 84, 83, 83),
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  )
                : Center(
                    child: DropdownButtonFormField<T>(
                      isExpanded: true,
                      value: selectedValue, // Set the currently selected value
                      items: items!.map<DropdownMenuItem<T>>((T item) {
                        return DropdownMenuItem<T>(
                          value: item,
                          child: itemBuilder(item),
                        );
                      }).toList(),
                      // Gestion de l'affichage de l'élément sélectionné
                      /*selectedItemBuilder: (BuildContext context) {
                        return items!.map<Widget>((T item) {
                          return Text(
                            //item.toString(),
                            item != null
                                ? item.toString()
                                : 'Sélectionner un élément', // Texte par défaut
                            overflow:
                                TextOverflow.ellipsis, // Empêche le débordement
                            maxLines: 1,
                            style: const TextStyle(fontSize: 14),
                          );
                        }).toList(); 
                      }, */
                      validator: validator,
                      onChanged: onChanged,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        labelText: label,
                        labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 84, 83, 83),
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
