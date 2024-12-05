import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lukatout/constant/colors.dart';

class UnderlineInputWidget extends StatefulWidget {
  final String label;
  final bool obscureText;
  final double horizontalMargin;
  final TextInputType keyboardType;
  const UnderlineInputWidget({
    super.key,
    required TextEditingController txtEditingController,
    required FocusNode inputFocusNode,
    required this.label,
    required this.keyboardType,
    this.obscureText = false,
    required this.horizontalMargin,
  })  : _txtEditingController = txtEditingController,
        _inputFocusNode = inputFocusNode;

  final TextEditingController _txtEditingController;
  final FocusNode _inputFocusNode;

  @override
  State<UnderlineInputWidget> createState() => _UnderlineInputWidgetState();
}

class _UnderlineInputWidgetState extends State<UnderlineInputWidget> {
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
          // from: 20,
          // from: 60,
          // delay: const Duration(milliseconds: 800),
          // duration: const Duration(milliseconds: 1000),
          child: AnimatedContainer(
            margin: EdgeInsets.symmetric(horizontal: widget.horizontalMargin),
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.2),
              borderRadius: BorderRadius.circular(8),
              border: const Border(
                bottom: BorderSide(
                  color: DigiPublicAColors.primaryColor, // Border color
                  width: 1.0, // Border width
                ),
              ),
              // border: Border.all(color: Colors.grey.shade300, width: 1.0),
              // // boxShadow:
            ),
            child: Stack(
              children: [
                TextField(
                  focusNode: widget._inputFocusNode,
                  obscureText: _obscureText,
                  controller: widget._txtEditingController,
                  keyboardType: widget.keyboardType,
                  cursorColor: Colors.black,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      // hintText: "nom d'utilisateur ici",
                      label: Text(widget.label),
                      labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 84, 83, 83),
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                      border: InputBorder.none),
                ),
                if (widget.obscureText)
                  Positioned(
                    top: 5,
                    right: 5,
                    child: IconButton(
                      onPressed: () {
                        _obscureText = !_obscureText;
                        setState(() {});
                        // debugPrint("$_obscureText");
                      },
                      icon: Icon(
                        !_obscureText
                            ? Icons.remove_red_eye_outlined
                            : Icons.remove_red_eye,
                        size: 20.0,
                      ),
                    ), //CircularAvatar
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
