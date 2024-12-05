import 'package:digipublic_studiant/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GoodView extends StatelessWidget {
  final String title;
  final String details;
  final List<dynamic>? documents;
  final List<dynamic>? images;

  GoodView({
    super.key,
    required this.title,
    required this.details,
    required this.documents,
    required this.images,
  });

  // URL de base pour les images et documents
  final _baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: DigiPublicAColors.whiteColor,
        title: Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Détails du bien',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 10),
            Text(details, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text(
              'Images:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            images != null && images!.isNotEmpty
                ? Column(
                    children: images!.map((imagePath) {
                      final imageUrl = "$_baseUrl/img/$imagePath";
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Image.network(
                          imageUrl,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                                  'assets/images/image-not-supported.svg'),
                        ),
                      );
                    }).toList(),
                  )
                : const Text("Aucune image disponible"),
            const SizedBox(height: 20),
            const Text(
              'Documents:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            documents != null && documents!.isNotEmpty
                ? Column(
                    children: documents!.map((docPath) {
                      final docUrl =
                          "$_baseUrl/img/$docPath"; // Ajout de l'URL de base
                      return ListTile(
                        leading: const Icon(Icons.description),
                        title: Text(docPath.split('/').last), // Nom du document
                        onTap: () {
                          // Code pour ouvrir ou afficher le document, par exemple avec `url_launcher`
                        },
                      );
                    }).toList(),
                  )
                : const Text("Aucun document disponible"),
          ],
        ),
      ),
    );
  }
}
