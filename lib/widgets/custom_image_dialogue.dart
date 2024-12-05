// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CustomImageDialog extends StatelessWidget {
  final String? imageUrl;
  final String placeholderUrl;
  final String downloadButtonText;
  final String closeButtonText;

  const CustomImageDialog({
    super.key,
    required this.imageUrl,
    this.placeholderUrl =
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqGVGf1MbRIenHlupz_bqCZCCzq0zH9sS0BQ&s',
    this.downloadButtonText = 'Télécharger',
    this.closeButtonText = 'Fermer',
  });

  Future<void> _downloadAndDisplayImage(BuildContext context) async {
    try {
      final response = await Dio().get(
        imageUrl!,
        options: Options(responseType: ResponseType.bytes),
      );
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/downloaded_image.png';
      final file = File(filePath);
      await file.writeAsBytes(response.data);

      // Ouvre un nouveau dialogue pour afficher l'image téléchargée
      Navigator.of(context).pop(); // Ferme le premier dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Image.file(file),
            actions: [
              TextButton(
                child: Text(closeButtonText),
                onPressed: () {
                  Navigator.of(context).pop(); // Ferme le dialog
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Affiche une erreur si le téléchargement échoue
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Erreur lors du téléchargement de l\'image.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Image.network(
        (imageUrl != null && Uri.tryParse(imageUrl!)?.isAbsolute == true)
            ? imageUrl!
            : placeholderUrl,
      ),
      actions: [
        TextButton(
          child: Text(downloadButtonText),
          onPressed: () async {
            if (imageUrl != null) {
              await _downloadAndDisplayImage(context);
            }
          },
        ),
        TextButton(
          child: Text(closeButtonText),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

// Fonction pour afficher le dialog personnalisé
void showCustomImageDialog({
  required BuildContext context,
  required String? imageUrl,
  String placeholderUrl =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqGVGf1MbRIenHlupz_bqCZCCzq0zH9sS0BQ&s',
  String downloadButtonText = 'Télécharger',
  String closeButtonText = 'Fermer',
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomImageDialog(
        imageUrl: imageUrl,
        placeholderUrl: placeholderUrl,
        downloadButtonText: downloadButtonText,
        closeButtonText: closeButtonText,
      );
    },
  );
}
