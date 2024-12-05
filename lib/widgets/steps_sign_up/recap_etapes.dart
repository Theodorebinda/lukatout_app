// import 'package:digipublic_studiant/providers/student_form.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class SummaryComponent extends StatelessWidget {
//   // Changement de nom de classe
//   @override
//   Widget build(BuildContext context) {
//     final formProvider = Provider.of<FormRecapProvider>(context);

//     return Padding(
//       // Retrait du Scaffold
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ...formProvider.studentSelections!.toMap().entries.map((entry) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0),
//               child: Text(
//                 '${entry.key} : ${entry.value ?? "Non sélectionné"}',
//                 style: TextStyle(fontSize: 16),
//               ),
//             );
//           }).toList(),
//           Spacer(),
//           Center(
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('Modifier les sélections'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
