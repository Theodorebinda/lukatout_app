import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:async';

import 'package:lukatout/models/entity.dart'; // Ajout de l'import pour StreamController

class SelectInputDWidget<T> extends StatelessWidget {
  final Stream<List<T>?> stream;
  final String label;
  final Widget Function(T) itemBuilder;
  final void Function(T?)? onChanged;
  final bool isMultiSelect;
  final String? Function(T? value)? validator;

  const SelectInputDWidget({
    super.key,
    required this.stream,
    required this.label,
    required this.itemBuilder,
    this.onChanged,
    this.isMultiSelect = false,
    this.validator,
    IEntity? selectedEntity,
    String? selectedOptionValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FadeInUp(
          from: 20,
          child: StreamBuilder<List<T>?>(
            stream:
                stream, // Assurez-vous que ce stream est un Broadcast Stream
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: DropdownButtonFormField<String>(
                    items: const [
                      DropdownMenuItem<String>(
                        value: "error",
                        child: Text(
                          "Oops! Something went wrong",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                    onChanged: null,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      labelText: "Error",
                      labelStyle: TextStyle(
                          color: Color.fromARGB(255, 84, 83, 83),
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                      border: OutlineInputBorder(),
                    ),
                  ),
                );
              } else {
                var data = snapshot.data;
                if (data == null || data.isEmpty) {
                  return Material(
                    child: Center(
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem<String>(
                            value: "no_data",
                            child: Text(
                              "No data available",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                        onChanged: null,
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
                    ),
                  );
                } else {
                  return Material(
                    child: Center(
                      child: DropdownButtonFormField<T>(
                        items: data.map<DropdownMenuItem<T>>((T item) {
                          return DropdownMenuItem<T>(
                            value: item,
                            child: itemBuilder(item),
                          );
                        }).toList(),
                        isExpanded: true,
                        validator: validator,
                        onChanged: onChanged,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          labelText: label,
                          labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 84, 83, 83),
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                          border: const OutlineInputBorder(),
                        ),
                        dropdownColor: Colors.grey[100],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
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
