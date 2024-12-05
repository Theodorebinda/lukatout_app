import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class PasswordWidget extends StatelessWidget {
  const PasswordWidget({
    super.key,
    required TextEditingController passwordEditingController,
  }) : _passwordEditingController = passwordEditingController;

  final TextEditingController _passwordEditingController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FadeInUp(
          // from: 80,
          // delay: const Duration(milliseconds: 800),
          // duration: const Duration(milliseconds: 1000),
          child: AnimatedContainer(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300, width: 1.0),
              // // boxShadow:
            ),
            child: TextField(
              controller: _passwordEditingController,
              keyboardType: TextInputType.text,
              obscureText: true,
              // maxLength: 4,
              cursorColor: Colors.black,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
              decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  // hintText: "Pin",
                  label: Text("Pin"),
                  labelStyle: TextStyle(
                      color: Color.fromARGB(255, 84, 83, 83),
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                  border: InputBorder.none),
            ),
          ),
        ),
      ],
    );
  }
}
