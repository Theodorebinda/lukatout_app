import 'package:flutter/material.dart';
import 'package:lukatout/constant/colors.dart';
import 'package:lukatout/widgets/action_button.dart';

class TeacherProfilePage extends StatefulWidget {
  final Map<String, String> teacher;
  final String heroTag;

  const TeacherProfilePage({
    Key? key,
    required this.teacher,
    required this.heroTag,
  }) : super(key: key);

  @override
  _TeacherProfilePageState createState() => _TeacherProfilePageState();
}

class _TeacherProfilePageState extends State<TeacherProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DigiPublicAColors.primaryColor,
      appBar: AppBar(
        title: Text(
          'Profil ${widget.teacher['name'] ?? ''}',
          style: const TextStyle(color: DigiPublicAColors.whiteColor),
        ),
        backgroundColor: DigiPublicAColors.primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          color: DigiPublicAColors.whiteColor,
        ),
      ),
      body: Column(
        children: [
          _profileHeader(context),
          _profileDetails(context),
        ],
      ),
    );
  }

  Widget _profileHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: DigiPublicAColors.primaryColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
              ),
            ],
          ),
          height: 230,
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Hero(
                      tag: widget.heroTag,
                      child: Material(
                        color: Colors.transparent,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: (widget
                                      .teacher['profileImageUrl']?.isNotEmpty ??
                                  false)
                              ? NetworkImage(widget.teacher['profileImageUrl']!)
                              : const AssetImage('assets/icon/app-icon.png')
                                  as ImageProvider,
                          backgroundColor: DigiPublicAColors.whiteColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 80),
                    IconButton(
                      icon: const Icon(
                        Icons.settings,
                        color: DigiPublicAColors.whiteColor,
                      ),
                      onPressed: () {
                        // Naviguer vers la page des paramètres si nécessaire
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  widget.teacher['name'] ?? 'Nom inconnu',
                  style: const TextStyle(
                    fontSize: 16,
                    color: DigiPublicAColors.whiteColor,
                  ),
                ),
                Text(
                  widget.teacher['email'] ?? 'Email inconnu',
                  style: const TextStyle(
                    fontSize: 14,
                    color: DigiPublicAColors.whiteColor,
                  ),
                ),
                Text(
                  widget.teacher['bio'] ?? 'Bio non disponible.',
                  style: const TextStyle(
                    fontSize: 14,
                    color: DigiPublicAColors.whiteColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ActionButton(
              label: 'Message',
              icon: Icons.message,
              color: DigiPublicAColors.whiteColor,
              iconColor: DigiPublicAColors.primaryColor,
              borderRadius: 50.0,
              onTap: (context) {
                // Action : Envoyer un message
              },
            ),
            ActionButton(
              label: 'Cours',
              icon: Icons.book,
              color: DigiPublicAColors.whiteColor,
              iconColor: DigiPublicAColors.primaryColor,
              borderRadius: 50.0,
              onTap: (context) {
                // Action : Accéder aux cours
              },
            ),
            ActionButton(
              label: 'Notes',
              icon: Icons.note,
              color: DigiPublicAColors.whiteColor,
              iconColor: DigiPublicAColors.primaryColor,
              borderRadius: 50.0,
              onTap: (context) {
                // Action : Voir les notes
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _profileDetails(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: 600.0,
        decoration: BoxDecoration(
          color: DigiPublicAColors.whiteColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(50.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Détails du Professeur',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: DigiPublicAColors.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Téléphone: ${widget.teacher['phone'] ?? 'Non disponible'}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Spécialité: ${widget.teacher['specialty'] ?? 'Non précisée'}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Statut: ${widget.teacher['status'] ?? 'Non spécifié'}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
