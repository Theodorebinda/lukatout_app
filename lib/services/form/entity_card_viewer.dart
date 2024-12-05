// ignore: file_names
import 'package:flutter/material.dart';

class IdentityCardDataViewer extends StatelessWidget {
  final Map<String, dynamic> extractedData;

  const IdentityCardDataViewer({
    super.key,
    required this.extractedData,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("extractedData : $extractedData");
    return extractedData.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: extractedData.entries.map((entry) {
              String key = entry.key;
              String value = entry.value.toString();
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  "$key : $value",
                  style: const TextStyle(fontSize: 16),
                ),
              );
            }).toList(),
          )
        : const Center(
            child: Text("Aucune donnée extraite."),
          );
  }
}
