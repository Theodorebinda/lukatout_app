import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class TextInputFielDdWidget extends StatefulWidget {
  final String label;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String? value)? validator;
  final int? maxLength;
  final int? maxLines;
  final ValueChanged<String>? onChange; // Nouveau champ

  const TextInputFielDdWidget({
    super.key,
    required TextEditingController txtEditingController,
    required FocusNode inputFocusNode,
    required this.label,
    required this.keyboardType,
    this.obscureText = false,
    this.maxLength,
    this.maxLines = 1,
    this.validator,
    this.onChange, // Ajouter onChange comme paramètre optionnel
  })  : _txtEditingController = txtEditingController,
        _inputFocusNode = inputFocusNode;

  final TextEditingController? _txtEditingController;
  final FocusNode _inputFocusNode;

  @override
  State<TextInputFielDdWidget> createState() => _TextInputFielDdWidgetState();
}

class _TextInputFielDdWidgetState extends State<TextInputFielDdWidget> {
  bool _obscureText = false;

  @override
  void initState() {
    _obscureText = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FadeInUp(
          from: 20,
          child: Stack(
            children: [
              TextFormField(
                key: widget.key,
                focusNode: widget._inputFocusNode,
                obscureText: _obscureText,
                controller: widget._txtEditingController,
                keyboardType: widget.keyboardType,
                cursorColor: Colors.black,
                validator: widget.validator,
                maxLength: widget.maxLength,
                maxLines: widget.maxLines,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  hintText: widget.label,
                  label: Text(widget.label),
                  labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 84, 83, 83),
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                  border: const OutlineInputBorder(),
                ),
                onChanged: widget.onChange, // Appel de onChange si défini
              ),
              if (widget.obscureText)
                Positioned(
                  top: 5,
                  right: 5,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    icon: Icon(
                      !_obscureText
                          ? Icons.remove_red_eye_outlined
                          : Icons.remove_red_eye,
                      size: 20.0,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
