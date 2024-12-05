import 'package:digipublic_studiant/constant/colors.dart';
import 'package:flutter/material.dart';

class EditAvatarPage extends StatelessWidget {
  final String imageUrl;

  const EditAvatarPage(String s, {Key? key, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Profil"),
        backgroundColor: DigiPublicAColors.whiteColor,
      ),
      body: Center(
        child: Hero(
          tag: 'image',
          child: Image.network(
            imageUrl,
            errorBuilder: (context, error, stackTrace) {
              return const Image(
                image: AssetImage('assets/icon/app-icon.png'),
              );
            },
          ),
        ),
      ),
    );
  }
}
