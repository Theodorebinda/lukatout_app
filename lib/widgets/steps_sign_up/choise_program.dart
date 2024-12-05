import 'package:digipublic_studiant/constant/colors.dart';
import 'package:digipublic_studiant/models/university.dart';
import 'package:digipublic_studiant/models/university.dart';
import 'package:digipublic_studiant/providers/student_form.dart';
import 'package:digipublic_studiant/widgets/steps_sign_up/recap_etapes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UniversitySelectionPage extends StatefulWidget {
  // final ValueChanged<int> updateStep;
  final Function(int) updateStep;

  const UniversitySelectionPage({
    super.key,
    required this.updateStep,
  });
  @override
  _UniversitySelectionPageState createState() =>
      _UniversitySelectionPageState();
}

class _UniversitySelectionPageState extends State<UniversitySelectionPage> {
  final List<IUniversity> universities = [
    IUniversity(
      name: 'UNIKIN',
      image: 'assets/icon/logo-unikin.png',
      faculties: [
        IFaculty(
          name: 'Faculté de Médecine',
          options: [
            IOption(name: 'Département de la chirurgie'),
            IOption(name: 'CNPP'),
            IOption(name: 'Medecine interne'),
            IOption(name: 'Gynecologie de CUK'),
            IOption(name: 'Odonto-Stomatologie'),
          ],
        ),
        IFaculty(
          name: 'Faculté Sciences',
          options: [
            IOption(
                name: 'Mention de Mathématiques Statistique et Informatique'),
            IOption(name: 'Mention Sciences de la Vie'),
            IOption(name: 'Mention de Géosciences'),
            IOption(name: 'Mention de Physique et Technologie'),
            IOption(name: 'Mention de la Chimie et Industrie'),
          ],
        ),
        IFaculty(
          name: 'Faculté Psychologie',
          options: [
            IOption(name: 'Psychologie'),
            IOption(name: "Science de l'education"),
            IOption(name: 'Gestion des entreprises et organisation de travail'),
            IOption(name: "Departement d'Agregation"),
          ],
        ),
        IFaculty(
          name: 'Faculté de Droit',
          options: [
            IOption(name: 'Département de droit économique et social'),
            IOption(name: 'Département des droits de l’homme'),
            IOption(
                name:
                    'Droit international public et relations internationales'),
            IOption(name: "Département de droit pénal et criminologie"),
            IOption(name: "Département de droit privé et judiciaire"),
            IOption(name: "Département de Droit public interne"),
            IOption(
                name: "Droit de l'environnement et du développement durable"),
          ],
        ),
      ],
    ),
    IUniversity(
      name: 'ISTA',
      image: 'assets/icon/logo-ISTA.png',
      faculties: [
        IFaculty(
          name: 'Faculté d\'Ingénierie',
          options: [
            IOption(name: 'Electricité'),
            IOption(name: 'Energies renouvelables '),
            IOption(name: 'Ingénierie Biomédicale '),
            IOption(name: 'Electronique'),
            IOption(name: 'Télécommunications'),
            IOption(name: 'Mécanique'),
          ],
        ),
        IFaculty(
          name: 'Faculté des Sciences',
          options: [
            IOption(name: 'Informatique'),
            IOption(name: 'Météorologie')
          ],
        ),
      ],
    ),
    IUniversity(
      name: 'ISIPA',
      image: 'assets/icon/logo-isipa.png',
      faculties: [
        IFaculty(
          name: 'Faculté des Sciences Informatiques',
          options: [
            IOption(name: 'Informatique de gestion'),
            IOption(name: 'Technique de maintenance'),
            IOption(name: 'Communication numérique'),
            IOption(name: 'Intelligence artificielle'),
            IOption(
                name:
                    "Système d'information et administration des bases des données"),
            IOption(name: 'Télécommunication et administration réseau'),
          ],
        ),
        IFaculty(
          name: "Sciences commerciales et financières",
          options: [
            IOption(name: 'Gestion financière'),
            IOption(name: 'Douane et accises'),
            IOption(name: 'Commerce extérieur'),
            IOption(name: 'Fiscalité'),
          ],
        ),
      ],
    ),
    IUniversity(
      name: 'UPN',
      image: 'assets/icon/logo-UPN.png',
      faculties: [
        IFaculty(
          name: 'FACULTE DES SCIENCES ET TECHNOLOGIES',
          options: [
            IOption(name: 'Departement de Chimie'),
            IOption(name: 'Physique et Technique appliquée'),
            IOption(name: 'Mathematique statistique et informatique'),
          ],
        ),
        IFaculty(
          name: 'FACULTE DES SCIENCES AGRONOMIQUE',
          options: [
            IOption(name: 'Departement 1'),
            IOption(name: 'Departement 8')
          ],
        ),
      ],
    ),
    IUniversity(
      name: 'ISP',
      image: 'assets/icon/logo-ISP-GOMBE.png',
      faculties: [
        IFaculty(
          name: 'Faculté De Lettres et Sciences Humaines',
          options: [
            IOption(name: 'Orientation Scolaire et Professionnelle'),
            IOption(
                name:
                    'Gestion et Administration des Institutions Scolaires et de Formation')
          ],
        ),
        IFaculty(
          name:
              'Sciences Commerciales, Informatique et Gestions Des Entreprises',
          options: [
            IOption(name: 'Gestion des Entreprises'),
            IOption(name: 'Informatique de Gestion'),
            IOption(name: 'Gestion Commerciale et Financière'),
          ],
        ),
      ],
    ),
    IUniversity(
      name: 'ISPT',
      image: 'assets/icon/isptkinLogo-1.png',
      faculties: [
        IFaculty(
          name: 'Faculté des Sciences',
          options: [IOption(name: 'Option 5'), IOption(name: 'Option 6')],
        ),
        IFaculty(
          name: 'Faculté d\'Ingénierie',
          options: [IOption(name: 'Option 7'), IOption(name: 'Option 8')],
        ),
      ],
    ),
    IUniversity(
      name: 'ISC',
      image: 'assets/icon/logo-isc.png',
      faculties: [
        IFaculty(
          name: 'Faculté des Sciences Informatiques',
          options: [
            IOption(name: 'Informatique de gestion'),
            IOption(name: 'Technique de maintenance'),
            IOption(name: 'Communication numérique'),
            IOption(name: 'Intelligence artificielle'),
            IOption(
                name:
                    "Système d'information et administration des bases des données"),
            IOption(name: 'Télécommunication et administration réseau'),
          ],
        ),
        IFaculty(
          name: "Sciences commerciales et financières",
          options: [
            IOption(name: 'Gestion financière'),
            IOption(name: 'Douane et accises'),
            IOption(name: 'Commerce extérieur'),
            IOption(name: 'Fiscalité'),
          ],
        ),
      ],
    ),
  ];

  // Sélections actuelles
  IUniversity? selectedUniversity;
  IFaculty? selectedFaculty;
  IOption? selectedOption;

  List<IFaculty> get faculties => selectedUniversity?.faculties ?? [];
  List<IOption> get options => selectedFaculty?.options ?? [];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DigiPublicAColors.whiteColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menu déroulant Université
            DropdownButtonFormField<IUniversity>(
              decoration: const InputDecoration(
                  labelText: 'Choisir une université',
                  hintStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              value: selectedUniversity,
              items: universities.map((university) {
                return DropdownMenuItem<IUniversity>(
                  value: university,
                  child: SizedBox(
                    height: 60.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(university.name ?? ''),
                        SizedBox(),
                        Image.asset(
                          university.image ?? '',
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedUniversity = value;
                  selectedFaculty = null;
                  selectedOption = null;
                });
              },
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              dropdownColor: Colors.white, // Couleur de fond du menu déroulant
              iconEnabledColor: Colors.blue,
            ),

            // Menu déroulant Faculté
            if (faculties.isNotEmpty) const SizedBox(height: 16),
            if (faculties.isNotEmpty)
              DropdownButtonFormField<IFaculty>(
                decoration: InputDecoration(labelText: 'Choisir une faculté'),
                value: selectedFaculty,
                items: faculties.map((faculty) {
                  return DropdownMenuItem<IFaculty>(
                    value: faculty,
                    child: Text(faculty.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedFaculty = value;
                    selectedOption = null;
                  });
                },
              ),

            // Menu déroulant Options
            if (options.isNotEmpty) const SizedBox(height: 16),
            if (options.isNotEmpty)
              DropdownButtonFormField<IOption>(
                decoration:
                    InputDecoration(labelText: 'Choisir un departement'),
                value: selectedOption,
                items: options.map((option) {
                  return DropdownMenuItem<IOption>(
                    value: option,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: Text(option.name ?? '',
                          overflow: TextOverflow.ellipsis),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedOption = value;
                  });
                },
              ),

            // Bouton de confirmation
            const SizedBox(height: 44),
            if (selectedOption != null)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Provider.of<FormRecapProvider>(context, listen: false)
                        .setUniversity(selectedUniversity!);
                    Provider.of<FormRecapProvider>(context, listen: false)
                        .setFaculty(selectedFaculty!);
                    Provider.of<FormRecapProvider>(context, listen: false)
                        .setOption(selectedOption!);
                    widget.updateStep(1);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Ajustez la valeur ici
                    ),
                  ),
                  child: const SizedBox(
                      width: 330,
                      height: 50,
                      child: Center(child: Text("Suivant"))),
                ),
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // RecapEtapes() {}
}
