import 'package:animate_do/animate_do.dart';
import 'package:digipublic_studiant/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectDateInputWidget<T> extends StatefulWidget {
  final String label;
  final TextEditingController txtEditingController;
  final FocusNode inputFocusNode;
  final String? Function(String? value)? validator;
  final Icon? suffixIcon;
  final void Function(T?)? onChanged;
  final bool
      isYearOnly; // Nouveau paramètre pour sélectionner l'année seulement

  const SelectDateInputWidget({
    super.key,
    required this.txtEditingController,
    required this.inputFocusNode,
    required this.label,
    this.validator,
    // this.onChanged,
    this.suffixIcon = const Icon(Icons.calendar_today),
    this.isYearOnly = false,
    this.onChanged,
    // Par défaut, sélection complète de date
  });

  @override
  State<SelectDateInputWidget> createState() => _SelectDateInputWidgetState();
}

class _SelectDateInputWidgetState extends State<SelectDateInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FadeInUp(
          from: 20,
          child: TextFormField(
            focusNode: widget.inputFocusNode,
            controller: widget.txtEditingController,
            readOnly: true,
            onTap: () async {
              if (widget.isYearOnly) {
                var currentYear = DateTime.now().year;
                final selectedYear = await showDialog<int>(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Material(
                        child: Theme(
                          data: ThemeData(
                            primaryColor: DigiPublicAColors.primaryColor,
                            colorScheme: const ColorScheme.light(
                              primary: DigiPublicAColors.primaryColor,
                              onPrimary: Colors.white,
                              onSurface: Colors.black,
                            ),
                          ),
                          child: YearPicker(
                            selectedDate: DateTime(currentYear),
                            firstDate: DateTime(1995),
                            lastDate: DateTime(currentYear),
                            onChanged: (DateTime dateTime) {
                              debugPrint("date : ${dateTime.year}");
                              Navigator.pop(context, dateTime.year);
                              if (widget.onChanged != null) {
                                currentYear = dateTime.year;
                                widget.onChanged!(dateTime.year);
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );

                if (selectedYear != null) {
                  setState(() {
                    widget.txtEditingController.text = selectedYear.toString();
                  });
                  //widget.onChanged?.call(selectedYear);
                }
              } else {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData(
                        colorScheme: const ColorScheme.light(
                          primary: DigiPublicAColors
                              .primaryColor, // Couleur principale
                          onPrimary:
                              Colors.white, // Texte sur couleur principale
                          onSurface: Colors.black, // Texte dans le picker
                        ),
                        dialogBackgroundColor:
                            Colors.white, // Couleur de fond du dialogue
                      ),
                      child: child!,
                    );
                  },
                );

                if (pickedDate != null) {
                  String formattedDate =
                      DateFormat('dd-MM-yyyy').format(pickedDate);
                  setState(() {
                    widget.txtEditingController.text = formattedDate;
                  });

                  // Check if onChanged is not null before calling
                  if (widget.onChanged != null) {
                    widget.onChanged!(formattedDate);
                  }
                  // Alternatively, use the null-aware operator
                  // widget.onChanged?.call(formattedDate);
                }
              }
            },
            validator: widget.validator,
            cursorColor: Colors.black,
            style: const TextStyle(
                color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              labelText: widget.label,
              labelStyle: const TextStyle(
                  color: Color.fromARGB(255, 84, 83, 83),
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
              border: const OutlineInputBorder(),
              suffixIcon: widget.suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}
