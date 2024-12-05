import 'package:digipublic_studiant/constant/colors.dart';
import 'package:digipublic_studiant/utils/app_show_local_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FullScreenDocument extends StatelessWidget {
  final String imageUrl;

  // ignore: use_super_parameters
  const FullScreenDocument({Key? key, required this.imageUrl})
      : super(key: key);

  Future<void> _downloadImage(BuildContext context) async {
    try {
      // Demande la permission d'accéder au stockage (nécessaire pour Android)
      if (await Permission.storage.request().isGranted) {
        var dio = Dio();
        var tempDir = await getTemporaryDirectory();
        String fullPath = '${tempDir.path}/downloaded_image.jpg';

        // Téléchargement de l'image
        await dio.download(imageUrl, fullPath);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image téléchargée dans : $fullPath')),
        );
      } else {
        appShowGetXSnackBarFx(
          title: "Permission Refusé!",
          subtitle: 'Activez la permission ou Prenez une capture',
          bgcolor: DigiPublicAColors.redColor,
          position: SnackPosition.TOP,
        );
      }
    } catch (e) {
      // En cas d'erreur, affichez un message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              _downloadImage(context);
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey,
      body: InteractiveViewer(
        panEnabled: true,
        minScale: 0.5,
        maxScale: 4.0,
        child: Image.network(
          imageUrl,
          height: (MediaQuery.of(context).size.height * 90) / 100,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Image.network(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqGVGf1MbRIenHlupz_bqCZCCzq0zH9sS0BQ&s',
              fit: BoxFit.contain,
            );
          },
        ),
      ),
    );
  }
}
