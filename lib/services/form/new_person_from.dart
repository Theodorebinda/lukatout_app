import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lukatout/common/common_service.dart';
import 'package:lukatout/constant/colors.dart';
import 'package:lukatout/models/person.dart';
import 'package:lukatout/providers/dynamic_provider.dart';
import 'package:lukatout/providers/person_provider.dart';
import 'package:lukatout/services/form/entity_card_viewer.dart';
import 'package:lukatout/widgets/app_fullcontent_spin.dart';
import 'package:provider/provider.dart';

// import 'dart:math';

class ISelectedFile {
  String path;
  String name;
  ISelectedFile({required this.name, required this.path});
}

class NewPersonFormDynamic extends StatefulWidget {
  //final Function(Map<String, dynamic>) onSave;
  //final void onSave;
  final Function(int) updateStep;
  // final ValueChanged<int> updateStep;

  const NewPersonFormDynamic({
    super.key,
    required this.updateStep,
  });

  @override
  // ignore: library_private_types_in_public_api

  _NewPersonFormDynamicState createState() => _NewPersonFormDynamicState();
}

class _NewPersonFormDynamicState extends State<NewPersonFormDynamic> {
  final _formKey = GlobalKey<FormState>();
  String firstName = '';
  String lastName = '';
  String middlename = '';

  final CommonService commonService = CommonService();
  Map<String, dynamic>? _submittedData;

  // final _birthdateFocusNode = FocusNode();

  // final _emailFocusNode = FocusNode();
  // final _phoneFocusNode = FocusNode();

  List<String> recognizedLines = [];
  List<String> extractedData = [];

  bool _isLoading = false;
  // IEntity? _selectedProvinceEntity; // Pour le premier SelectInputWidget
  // IEntity? _selectedBirthProvinceEntity;
  // IEntity? _selectedBirthProvinceOnlyEntity;

  // IEntity? _selectedTowshipProvinceEntity;
  // IEntity? _selectedQuartieripProvinceEntity;

  List<dynamic> _dynamicFields = [];
  // List<dynamic> _dynamicCorporationFields = [];
  List<dynamic> _identityCard = [];
  final Map<String, List<Map<String, dynamic>>> _selectedFiles = {};
  Map<String, List<Map<String, dynamic>>> _dynamicSelectedFiles = {};

  // File? _image;
  late ImagePicker imagePicker;

  final Map<String, TextEditingController> _textControllers = {};
  Map<String, TextEditingController> _dynamicTextControllers = {};
  late List<ISelectedFile> _selectedPhotos = [];

  int currentStep = 0;
  // final _formKeyStep0 = GlobalKey<FormState>();
  // final _formKeystream = GlobalKey<FormState>();
  // final _formKeystream1 = GlobalKey<FormState>();
  late BuildContext _ctx;

  String? _selectedTaxPayerType;

  String? type;

  /////////////
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();

  // final Map<String, TextEditingController> _controllers = {};
  // final Map<String, FocusNode> _focusNodes = {};
  Map<String, dynamic> newPerson = {};

  //  final path = file.path
  //  _upload(File(path));
  // late List<dynamic> _selectedIdentityCard;
  // final _emailTaxPayerEditingController = TextEditingController();
  // final _phoneTaxPayerEditingController = TextEditingController();
  List<Widget> _dynamicFieldsForm = [];

  IPerson? person;
  // String? _typeTaxpayer;
  // String? _typeTaxpayerId;
  // dynamic _selectedGendeValue;

  IPerson? selectedPerson;

  @override
  void initState() {
    super.initState();

    fetchFormFields();
    // fetchFormFieldsCorporation();
    imagePicker = ImagePicker();
    // commonService.getTaxPayerTypes();
    // commonService.getJuridicForms();
    commonService.geAllEntities(
        '/core/entity?parent=null&include__childrens__include__childrens__include__childrens=true');
    // commonService.getEntities('/core/entity');
//
    // commonService.getGoods(
    // '/core/goods?include__childrens__include__childrens__include__childrens=true');
    // commonService.getPersonHead('/id-bio/person/head');
    // commonService.getCorporationHead('/id-bio/corporation/head');
  }

  @override
  void dispose() {
    _textControllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _takePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      // Utiliser length() pour obtenir la taille du fichier de manière asynchrone

      setState(() {
        _selectedPhotos.add(ISelectedFile(name: photo.name, path: photo.path));
      });

      debugPrint('::::::::::::::::::::::$_selectedPhotos');
    }
  }

  // _imgFromCamera() async {
  //   XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //       _recognizeText(_image!);
  //     });
  //   }
  // }

  Future<void> fetchFormFields() async {
    setState(() {
      _isLoading = true; // Activer le chargement
    });

    try {
      final response = await commonService.getPersonHead('/id-bio/person/head');
      debugPrint('\n\n ----------------- head person data: $response',
          wrapWidth: 1024);
      setState(() {});
      Provider.of<DynamicFormProvider>(_ctx, listen: false).setFormField(
          context: _ctx,
          dynamicFields: response['data'],
          commonService: commonService);
    } catch (e) {
      debugPrint('Erreur lors de la récupération des champs : $e');
    } finally {
      setState(() {
        _isLoading = false; // Désactiver le chargement
      });
    }
  }

  Map<String, dynamic> extractData(List<String> lines) {
    Map<String, dynamic> data = {};

    for (String line in lines) {
      String cleanedLine = line.replaceAll(" ", "");
      if (cleanedLine.startsWith("Nom:")) {
        data["Nom"] = cleanedLine.replaceFirst("Nom:", "").trim();
      } else if (cleanedLine.startsWith("Postnom/Prenom:") ||
          cleanedLine.startsWith("Post-nom / Prénom:") ||
          cleanedLine.startsWith("Post-nom / Prénom :")) {
        /*String postnomPrenom = line.replaceFirst("Postnom/Prenom:", "").trim() || line.replaceFirst("Postnom/Prenom:", "").trim();
        List<String> parts = postnomPrenom.split('/');
        data["Postnom"] = parts[0].trim();
        data["Prenom"] = parts.length >  l l1 ? parts[1].trim() : ''; */

        String postnomPrenom = cleanedLine
            .replaceFirst(
                RegExp(
                    r"^(Postnom/Prenom:|Post-nom / Prénom:|Post-nom / Prénom :)"),
                "")
            .trim();

        // Divisez par '/' et enlevez les espaces superflus pour chaque partie
        List<String> parts =
            postnomPrenom.split('/').map((part) => part.trim()).toList();

        // Assignez les valeurs pour "Postnom" et "Prenom" en vérifiant qu'elles existent
        data["Postnom"] = parts.isNotEmpty ? parts[0] : '';
        data["Prenom"] = parts.length > 1 ? parts[1] : '';
      } else if (cleanedLine.startsWith("Date / Lieu de naissance:")) {
        data["Date / Lieu de naissance"] =
            line.replaceFirst("Date / Lieu de naissance:", "").trim();
      } else if (cleanedLine.startsWith("Sexe :")) {
        data["Sexe"] =
            cleanedLine.replaceFirst("Sexe :", "").replaceAll(",", "").trim();
      } else if (cleanedLine.length == 9 && cleanedLine.startsWith("A")) {
        data["Numero Carte"] = cleanedLine.trim();
      }
    }

    debugPrint("data extracted from lines $data");
    updateFormFields(data);
    setState(() {}); // Update UI with extracted data
    return data;
  }

  void updateFormFields(Map<String, dynamic> data) {
    // Mapper les champs extraits aux labels attendus
    Map<String, String> labelMap = {
      'firstName': 'Prenom',
      'lastName': 'Nom',
      'middlename': 'Postnom',
      'birthplace': 'Date / Lieu de naissance',
      'gender': 'Sexe',
      'cardNumber': 'Numero Carte'
    };

    data.forEach((key, value) {
      // Trouver le contrôleur de texte correspondant au champ
      String? controllerKey = labelMap.entries
          .firstWhere((entry) => entry.value == key,
              orElse: () => const MapEntry('', ''))
          .key;

      // Si un contrôleur existe pour le champ, mettre à jour son texte
      if (controllerKey.isNotEmpty && _textControllers[controllerKey] != null) {
        _textControllers[controllerKey]!.text = value;
        debugPrint("Updated field $controllerKey with value: $value");
      }
    });

    // Mettre à jour l'interface
    setState(() {});
  }

  String _formatPhone(String input) {
    // Retirer tout caractère non numérique
    String digits = input.replaceAll(RegExp(r'\D'), '');

    // Ajouter toujours '243' comme préfixe s'il n'est pas présent
    if (!digits.startsWith('243')) {
      digits = '243' + digits;
    }

    // Limiter la saisie aux 12 caractères (9 chiffres + 3 pour '243')
    if (digits.length > 12) {
      digits = digits.substring(0, 12);
    }

    // Formatage avec les traits
    StringBuffer formatted = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      formatted.write(digits[i]);
      // Ajouter un trait après 3, 6, et 9 chiffres
      if ((i == 2 || i == 5 || i == 8) && i != digits.length - 1) {
        formatted.write('-');
      }
    }

    return formatted.toString();
  }

  bool _isValidPhone(String input) {
    // Retirer les traits pour vérifier uniquement les chiffres
    String digits = input.replaceAll(RegExp(r'\D'), '');
    return digits.length == 12 && digits.startsWith('243');
  }

  // Méthode pour collecter les données du formulaire
  Map<String, dynamic> _collectFormData() {
    debugPrint("start collecting");
    Map<String, dynamic> newPersonCreated = {};

    debugPrint("_selectedTaxPayerType : $_selectedTaxPayerType");
    debugPrint("list : $_dynamicFields ");
    for (var field in _dynamicFields) {
      String key = field['proprety'];
      debugPrint(key);

      // Vérifie si le champ est de type "file" pour récupérer le chemin du fichier
      if (field['type'] == 'file') {
        if (_selectedFiles.containsKey(key) &&
            _dynamicSelectedFiles[key]!.isNotEmpty) {
          // Ajoute uniquement le chemin du premier fichier sélectionné comme une chaîne
          newPersonCreated[key] = _dynamicSelectedFiles[key]!.first['path'];
          debugPrint(
              "la clé $key  : ${_dynamicSelectedFiles[key]!.first['path']}.");
        } else {
          debugPrint("Aucun fichier sélectionné pour la clé $key.");
        }
      } else {
        // Pour les autres champs, vérifie le contrôleur de texte
        if (_dynamicTextControllers.containsKey(key)) {
          debugPrint("Clé $key : ${_dynamicTextControllers[key]!.text}.");
          newPersonCreated[key] = _dynamicTextControllers[key]!.text;
        } else {
          debugPrint("Contrôleur pour la clé $key n'existe pas.");
        }
      }
    }

    return newPersonCreated;
  }

  void _resetForm() {
    // Réinitialiser tous les contrôleurs de texte
    _dynamicTextControllers.clear();
    _dynamicTextControllers.clear();

    // Réinitialiser le dropdown ou autres champs si nécessaire
    setState(() {
      _selectedTaxPayerType = null; // Réinitialiser la sélection
    });

    // Si vous avez d'autres types de contrôleurs (image, fichiers, etc.), réinitialisez-les aussi.
  }

  // Soumission du formulaire
  void _submitForm() {
    debugPrint("start submission:");
    if (_formKey.currentState!.validate()) {
      debugPrint("before calling _collectFormData:");
      Map<String, dynamic> formData = _collectFormData();
      debugPrint("after calling _collectFormData: $formData");
      setState(() {
        _submittedData = formData; // Stocker les données pour le récapitulatif
      });
      _createNewPerson(formData);
      debugPrint("Form Data: $formData");
      _resetForm();
    }
  }

  // Nettoyer les contrôleurs

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    _dynamicFieldsForm =
        Provider.of<DynamicFormProvider>(context, listen: false)
            .currentDynamicFieldWidgets;

    _dynamicTextControllers =
        Provider.of<DynamicFormProvider>(context, listen: false)
            .textControllers;

    _dynamicSelectedFiles =
        Provider.of<DynamicFormProvider>(context, listen: false).selectedFiles;
    _dynamicFields = Provider.of<DynamicFormProvider>(context, listen: false)
        .getDynamicFields;

    return AppFullcontentSpin(
      activityIsRunning: _isLoading,
      message: 'Patientez ...',
      child: Material(
        color: DigiPublicAColors.whiteColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 5.0),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Information Personnelle',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Construisez les champs du formulaire ici
                          //...buildFormFields(),
                          ..._dynamicFieldsForm,

                          if (_identityCard.isNotEmpty)
                            IdentityCardDataViewer(
                                extractedData: extractData(recognizedLines)),

                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: DigiPublicAColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              _submitForm();
                              // widget.updateStep(3);
                            },
                            child: const SizedBox(
                                width: 330,
                                height: 50,
                                child: Center(child: Text("Suivant"))),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _createNewPerson(Map<String, dynamic> formData) {
    setState(() {
      _isLoading = true; // Démarre le loader
    });

    late String url;
    if (_selectedTaxPayerType == "MORAL") {
      url = "/id-bio/corporation";
    } else {
      url = '/id-bio/person';
    }

    debugPrint('newPersonCreated::::::::::::::::::::::::::::::: $formData');

    commonService.createPerson(url, formData).then((response) {
      if (response != null) {
        debugPrint('response ###');

        setState(() {
          _isLoading = false; // Stoppe le loader après l'opération
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              titlePadding: const EdgeInsets.all(20.0),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
              actionsPadding: const EdgeInsets.all(10.0),
              title: const Row(
                children: [
                  Icon(
                    Icons.person_add,
                    color: DigiPublicAColors.primaryColor,
                    size: 28.0,
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: Text(
                      "Demande envoyer!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1, // Limiter à 1 ligne
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 16.0),
                  Column(
                    children: [
                      Text(
                        '${response['data']['firstName']} ${response['data']['lastName']}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1, // Limiter à 1 ligne
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: <Widget>[
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: DigiPublicAColors.primaryColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 15.0),
                    side:
                        const BorderSide(color: DigiPublicAColors.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    Provider.of<PersonProvider>(context, listen: false)
                        .setPerson(IPerson.fromJson(response['data']));
                    Navigator.of(context).pop();
                    widget.updateStep(3);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
      setState(() {
        _isLoading = false; // Stoppe le loader après l'opération
      });
      debugPrint('New person response: $response');
    }).catchError((onError) {
      setState(() {
        _isLoading = false; // Stoppe le loader après l'opération
      });
      debugPrint('Error creating person: $onError');
      setState(() {
        _isLoading = false; // Stoppe le loader après l'opération
      });
    });
  }
}
