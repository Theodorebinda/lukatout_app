import 'package:flutter/material.dart';
import 'package:lukatout/constant/colors.dart';
import 'package:lukatout/widgets/underline_input_widget.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // ... existing code ...

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final FocusNode _oldPasswordFocusNode = FocusNode();
  final FocusNode _newPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _oldPasswordFocusNode.dispose();
    _newPasswordFocusNode.dispose();
  }

  void _savePassword() {
    // Implémenter ici la logique d'enregistrement du mot de passe (A faire)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier le Mot de Passe'),
        backgroundColor: DigiPublicAColors.whiteColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const ListTile(
              leading: Icon(
                Icons.lock,
                color: DigiPublicAColors.darkGreyColor,
              ),
              title: Text(
                "Modifier le Mot de Passe",
                style: TextStyle(
                  fontSize: 17.0,
                  color: DigiPublicAColors.darkGreyColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              subtitle: Text(
                "Votre mot de passe doit rester secret. Ne le partagez jamais avec .",
                style: TextStyle(
                  color: DigiPublicAColors.greyColor,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            const Divider(),
            const SizedBox(height: 20.0),
            UnderlineInputWidget(
              horizontalMargin: 0,
              inputFocusNode: _oldPasswordFocusNode,
              label: "Ancien Mot de Passe",
              obscureText: true,
              keyboardType: TextInputType.text,
              txtEditingController: _oldPasswordController,
            ),
            const SizedBox(height: 10.0),
            UnderlineInputWidget(
              horizontalMargin: 0,
              inputFocusNode: _newPasswordFocusNode,
              label: "Nouveau Mot de Passe",
              obscureText: true,
              keyboardType: TextInputType.text,
              txtEditingController: _newPasswordController,
            ),
            const SizedBox(height: 45.0),
            ElevatedButton(
              onPressed: _savePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: DigiPublicAColors.primaryColor,
                iconColor: DigiPublicAColors.whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0), // Coins arrondis
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 20.0),
              ),
              child: const Text(
                'Valider',
                style: TextStyle(
                  color: DigiPublicAColors.whiteColor,
                ),
              ),
            ),
            const SizedBox(height: 15.0),
          ],
        ),
      ),
    );
  }
}
