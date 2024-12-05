import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class UsernameWidget extends StatelessWidget {
  const UsernameWidget({
    super.key,
    required TextEditingController usernameEditingController,
  }) : _usernameEditingController = usernameEditingController;

  final TextEditingController _usernameEditingController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // FadeInUp(
        //   // from: 60,
        //   // delay: const Duration(milliseconds: 800),
        //   // duration: const Duration(milliseconds: 1000),
        //   child: Container(
        //     margin: const EdgeInsets.symmetric(horizontal: 30),
        //     child: const Row(
        //       children: [
        //         Text(
        //           "Nom d'utilisateur",
        //           style: TextStyle(
        //             fontSize: 14.0,
        //           ),
        //         )
        //       ],
        //     ),
        //   ),
        // ),
        FadeInUp(
          // from: 60,
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
              controller: _usernameEditingController,
              keyboardType: TextInputType.text,
              cursorColor: Colors.black,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
              decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  // hintText: "nom d'utilisateur ici",
                  label: Text("nom d'utilisateur ici"),
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
