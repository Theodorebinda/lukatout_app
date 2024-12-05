import 'package:flutter/material.dart';
import 'package:lukatout/widgets/steps_sign_up/uploaded_docs.dart';

class DocumentRequestPage extends StatelessWidget {
  const DocumentRequestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        //  Scaffold(
        // appBar: AppBar(
        //   title: const Text("Demande de Documents"),
        //   backgroundColor:
        //       Colors.blue, // Vous pouvez personnaliser la couleur ici
        // ),
        SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MultiDocumentUploader(
          onDocumentsUploaded: (documents) {
            // Action une fois que tous les documents sont téléchargés
            print("Documents uploadés : $documents");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("Tous les documents ont été soumis!")),
            );
          },
          updateStep: (step) {
            // Mettez à jour une étape ou une logique particulière
            print("Étape mise à jour : $step");
          },
        ),
      ),
    );
    // );
  }
}
