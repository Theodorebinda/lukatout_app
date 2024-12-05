import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lukatout/constant/colors.dart';
import 'package:lukatout/utils/app_show_bottom_sheet.dart';
import 'package:lukatout/widgets/demande_doc.dart';

class MultiDocumentUploader extends StatefulWidget {
  // final ValueChanged<int> updateStep;
  final Function(int) updateStep;
  final Function(Map<String, File>) onDocumentsUploaded;

  const MultiDocumentUploader({
    Key? key,
    required this.onDocumentsUploaded,
    required this.updateStep,
  }) : super(key: key);

  @override
  State<MultiDocumentUploader> createState() => _MultiDocumentUploaderState();
}

class _MultiDocumentUploaderState extends State<MultiDocumentUploader> {
  final Map<String, File?> _documents = {
    "Bonne Vue et Mœurs": null,
    "Aptitude Physique": null,
    "Diplôme ou Attestation de Réussite": null,
  };

  final Set<String> _confirmedDocuments = {};

  Future<void> _pickFile(String documentType) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _documents[documentType] = File(result.files.single.path!);
      });
    }
  }

  void _confirmDocument(String documentType) {
    setState(() {
      if (_documents[documentType] != null) {
        _confirmedDocuments.add(documentType);
      }
    });
  }

  void _submitDocuments() {
    if (_confirmedDocuments.length == _documents.keys.length) {
      widget.onDocumentsUploaded(
          _documents.map((key, value) => MapEntry(key, value!)));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Documents soumis avec succès!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Veuillez confirmer tous les documents avant de soumettre."),
        ),
      );
    }
  }

  Widget _buildPreview(String documentType) {
    final File? file = _documents[documentType];
    if (file == null) {
      return const Text("Cliquez ici pour ajouter");
    }

    final extension = file.path.split('.').last.toLowerCase();

    if (['png', 'jpg', 'jpeg'].contains(extension)) {
      return Image.file(
        file,
        height: 200,
        fit: BoxFit.cover,
      );
    } else if (extension == 'pdf') {
      return const Icon(Icons.picture_as_pdf, size: 100, color: Colors.red);
    } else {
      return const Icon(Icons.insert_drive_file, size: 100, color: Colors.blue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._documents.keys.map((documentType) {
          final isConfirmed = _confirmedDocuments.contains(documentType);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  documentType,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                GestureDetector(
                  onTap: () => _pickFile(documentType),
                  child: Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(child: _buildPreview(documentType)),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: isConfirmed
                            ? null
                            : () => _confirmDocument(documentType),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isConfirmed
                              ? Colors.green
                              : DigiPublicAColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Ajustez la valeur ici
                          ),
                        ),
                        child: Text(
                          isConfirmed ? "Confirmé" : "Confirmé",
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await digiPublicShowBottomSheet(
                            context: context,
                            child:
                                DocumentRequestPage(), // Remplacez par le widget que vous souhaitez afficher
                            height: 600, // Ajustez la hauteur si nécessaire
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Faire Une Demande"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: () {
              _submitDocuments();

              widget.updateStep(2);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const SizedBox(
                width: 330, height: 50, child: Center(child: Text("Suivant"))),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }
}
