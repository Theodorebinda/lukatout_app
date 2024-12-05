import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:digipublic_studiant/common/common_service.dart';
import 'package:digipublic_studiant/constant/colors.dart';
import 'package:digipublic_studiant/models/entity.dart';
import 'package:digipublic_studiant/models/person.dart';
import 'package:digipublic_studiant/models/seleted_file.dart';
import 'package:digipublic_studiant/services/form/entity_provider.dart';
import 'package:digipublic_studiant/services/form/select_date_input_field.dart';
import 'package:digipublic_studiant/services/form/select_input_field.dart';
import 'package:digipublic_studiant/services/form/select_input_normal_widget.dart';
import 'package:digipublic_studiant/services/form/text_input_field.dart';
import 'package:digipublic_studiant/utils/validation.dart';
import 'package:digipublic_studiant/widgets/form_widgets/select_input_field.dart';
import 'package:digipublic_studiant/widgets/form_widgets/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class DynamicFormProvider extends ChangeNotifier {
  List<Widget> _dynamicWidgets = [];
  List<dynamic> _getDynamicFields = [];
  List<dynamic> get getDynamicFields => _getDynamicFields;
  CommonService commonService = CommonService();
  final Map<String, TextEditingController> _textControllers = {};
  Map<String, TextEditingController> get textControllers => _textControllers;
  late List<SelectedFile> _selectedPhotos = [];
  List<dynamic> _identityCard = [];
  List<String> recognizedLines = [];

  var _selectedProvinceEntity =
      IEntity.empty(); // Pour le premier SelectInputWidget
  IEntity? _selectedBirthProvinceEntity;
  IEntity? _selectedBirthProvinceOnlyEntity;
  TextEditingController searchController = TextEditingController();

  final _appAllEntityController = BehaviorSubject<List<IEntity>>.seeded([]);
  ValueStream<List<IEntity>> get allEntityStream =>
      _appAllEntityController.stream;

  List<IEntity> allEntityDataSource = [];
  List<IEntity> filteredProvinceEntityDataSource = [];
  List<IEntity> filteredTownEntityDataSource = [];
  List<IEntity> filteredTownshipEntityDataSource = [];

  // final _appTownEntityController = BehaviorSubject<List<IEntity>>.seeded([]);
  // ValueStream<List<IEntity>> get townEntityStream =>
  //     _appTownEntityController.stream;

  var selectedProvince = IEntity.empty();
  var selectedCity = IEntity.empty();
  var selectedTownship = IEntity.empty();

  IPerson? person;
  String? _typeTaxpayer;
  String? _typeTaxpayerId;
  dynamic _selectedGendeValue;
  File? _image;
  // late ImagePicker imagePicker;
  late BuildContext context;

  IPerson? selectedPerson;
  final Map<String, List<Map<String, dynamic>>> _selectedFiles = {};
  Map<String, List<Map<String, dynamic>>> get selectedFiles => _selectedFiles;

  final _birthdateFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final Map<String, FocusNode> _focusNodes = {};
  bool _isListVisible = true;

  final _formKeyStep0 = GlobalKey<FormState>();
  final _formKeystream = GlobalKey<FormState>();
  final _formKeystream1 = GlobalKey<FormState>();

  List<Widget> get currentDynamicFieldWidgets => _dynamicWidgets;
  Future<void> _takePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      // Utiliser length() pour obtenir la taille du fichier de manière asynchrone
      _selectedPhotos.add(SelectedFile(name: photo.name, path: photo.path));
      callNotifiers();
      debugPrint('::::::::::::::::::::::$_selectedPhotos');
    }
    callNotifiers();
  }

  void removeIdentityCardAt(int index) {
    _identityCard.removeAt(index);
    callNotifiers();
    debugPrint(
        'Identity card removed at index: $index'); // Notifie les widgets dépendants
  }

  void updateIdentityCard(List<Map<String, dynamic>> newCard) {
    _identityCard = newCard;
    callNotifiers();
  }

  void removeSelectedPhoto(int index) {
    _selectedPhotos.removeAt(index);
    callNotifiers();
    debugPrint(
        'Photo removed at index: $index'); // Notifie les widgets dépendants
  }

  void addPhotos(List<SelectedFile> photos) {
    _selectedPhotos.addAll(photos);
    notifyListeners();
  }

  Map<String, dynamic> extractData(List<String> lines) {
    Map<String, dynamic> data = {};
    for (String line in lines) {
      debugPrint("Analyzing line: $line"); // Log pour chaque ligne
      String cleanedLine = line.replaceAll(" ", "");
      if (line.startsWith(RegExp(r"^Nom\s*:", caseSensitive: false))) {
        String extractedNom = line
            .replaceFirst(RegExp(r"^Nom\s*:", caseSensitive: false), "")
            .trim();
        data["Nom"] = extractedNom;
      } else if (line.startsWith("Postnom/Prenom:") ||
          line.startsWith("Post-nom / Prénom:") ||
          line.startsWith("Post-nom / Prénom :")) {
        String postnomPrenom = line
            .replaceFirst(
                RegExp(
                    r"^(Postnom/Prenom:|Post-nom / Prénom:|Post-nom / Prénom :)"),
                "")
            .trim();
        List<String> parts =
            postnomPrenom.split('/').map((part) => part.trim()).toList();
        data["Postnom"] = parts.isNotEmpty ? parts[0] : '';
        data["Prenom"] = parts.length > 1 ? parts[1] : '';
      } else if (line.startsWith("Date/Lieu de naissance") ||
          line.startsWith("Date / Lieu de naissance")) {
        data["Date / Lieu de naissance"] = line
            .replaceFirst(RegExp(r"Date\s*/?\s*Lieu de naissance\s*:"), "")
            .trim();
      } else if (line.startsWith("Sexe :")) {
        data["Sexe"] =
            line.replaceFirst("Sexe :", "").replaceAll(",", "").trim();
      } else if (line.startsWith("A") && line.length >= 9) {
        data["Numero Carte"] = line.trim();
      }
    }
    // Log des données extraites
    debugPrint("Extracted data: $data");
    updateFormFields(data);
    return data;
  }

  Timer? _debounce;
  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    if (value.isEmpty) {
      // Reset the person list when the search input is cleared
      //commonService._appPersonLIstController.add([]);
    } else if (value.length >= 3) {
      _debounce = Timer(const Duration(milliseconds: 500), () {});
    }
  }

  Future<void> _recognizeText(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    // final textRecognizer = GoogleMlKit.vision.textRecognizer();

    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    String text = recognizedText.text;
    debugPrint("text found $text");
    for (TextBlock block in recognizedText.blocks) {
      final Rect rect = block.boundingBox;

      debugPrint("rect found $rect");
      final List<Point<int>> cornerPoints = block.cornerPoints;
      final String text = block.text;
      final List<String> languages = block.recognizedLanguages;

      debugPrint("second text found $text");
      //debugPrint("Current block : ${block}");

      for (TextLine line in block.lines) {
        // Same getters as TextBlock
        debugPrint("line ${line.text}");

        recognizedLines.add(line.text);
        for (TextElement element in line.elements) {
          // Same getters as TextBlock

          debugPrint("element $element");
        }
      }
    }

    debugPrint("recognizedLines : $recognizedLines");

    extractData(recognizedLines);
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
      String? controllerKey = labelMap.entries
          .firstWhere((entry) => entry.value == key,
              orElse: () => const MapEntry('', ''))
          .key;
      if (controllerKey.isNotEmpty && _textControllers[controllerKey] != null) {
        _textControllers[controllerKey]!.text = value;
        callNotifiers();
        debugPrint("Updated field $controllerKey with value: $value");
      } else {
        debugPrint(
            "No controller found for key: $key or controller not initialized.");
      }
    });
    // Mettre à jour l'interface
    // setState(() {});
  }

  int currentStep = 0;
  void updateStep(int step) {
    currentStep = step;
    // setState(() {
    // });
  }

  // final _appEntityController = BehaviorSubject<List<IEntity>>.seeded([]);
  Stream<List<IEntity>> filteredEntityStream = const Stream.empty();

  Stream<List<IEntity>> filteredSubEntityStream = const Stream.empty();

  Stream<List<IEntity>> filtereedSubEntityStream = const Stream.empty();

  Stream<List<IEntity>> filtereedTownshipStream = const Stream.empty();

  Stream<List<IEntity>> filteredTownshipStream = const Stream.empty();

  // List<IEntity> allEntities = [];
  final StreamController<List<IEntity>> _townStreamController =
      StreamController.broadcast();
  final StreamController<List<IEntity>> _townShipStreamController =
      StreamController.broadcast();

  Stream<List<IEntity>> get townStream => _townStreamController.stream;
  Stream<List<IEntity>> get townShipStream => _townShipStreamController.stream;

  @override
  void dispose() {
    _townStreamController.close();
    _townShipStreamController.close();

    super.dispose();
  }

  void callStreamNotifiers() async {
    // var entities = await commonService.fetchAllEntities();
    Map<String, dynamic> entities = await commonService.fetchAllEntities();

    allEntityDataSource.clear();
    allEntityDataSource.addAll(entities['data']);
    debugPrint("STREAM  £££££££££ : ${allEntityDataSource.length}");
    // debugPrint("STREAM  £££££££££ : ${allEntityDataSource}");
    filteredProvinceEntityDataSource = allEntityDataSource
        .where((entity) => entity.parentNumber == 0)
        .toList();
    callNotifiers();
  }

  void filterTownEntities(IEntity selectedEnt) async {
    filteredTownEntityDataSource.clear();
    _townShipStreamController.add([]);
    _townStreamController.add([]);
    selectedCity = IEntity.empty();
    selectedTownship = IEntity.empty();
    await Future.delayed(const Duration(milliseconds: 400));
    for (IEntity entity in allEntityDataSource) {
      if (entity.number == selectedEnt.number) {
        for (int i = 0; i < entity.childrens.length; i++) {
          IEntity subEntity = entity.childrens[i];
          if (i == 0) {
            if (filteredTownEntityDataSource.isNotEmpty) {
              selectedCity = filteredTownEntityDataSource[0];
            }
          }
          filteredTownEntityDataSource.add(subEntity);
        }
      }
    }
    // if (filteredTownEntityDataSource.isEmpty) {
    //   // Cas où il n'y a pas de sous-éléments
    //   debugPrint("Aucun sous-élément trouvé pour l'entité sélectionnée.");
    //   return;
    // }
    // if (filteredTownEntityDataSource.isNotEmpty) {
    //   selectedCity = filteredTownEntityDataSource[0];
    // }
    // // Diffuser les nouvelles données via le StreamController
    _townStreamController.add(filteredTownEntityDataSource);
    notifyListeners();
    debugPrint(
        " ---- filteredTownEntityDataSource ---- ${filteredTownEntityDataSource.length}  ");
  }

  void filterTownShipEntities(IEntity selectedCity) async {
    selectedTownship = IEntity.empty();
    filteredTownshipEntityDataSource.clear();
    // Vérifier si `selectedCity` a des enfants
    if (selectedCity.childrens.isNotEmpty) {
      for (IEntity subEntity in selectedCity.childrens) {
        filteredTownshipEntityDataSource.add(subEntity);
      }
    }
    // Diffuser les nouvelles données via le StreamController
    if (filteredTownshipEntityDataSource.isNotEmpty) {
      selectedTownship = filteredTownshipEntityDataSource[0];
    }
    _townShipStreamController.add(filteredTownshipEntityDataSource);
    // Notifier les autres listeners si nécessaire
    notifyListeners();
    debugPrint(
        " ---- filteredTownshipEntityDataSource ---- ${filteredTownshipEntityDataSource.length}  ");
  }

  void _buildField(Map<String, dynamic> field) {
    String label = field['verbose'] ?? field['proprety'];
    String fieldType = field['type'];
    String key = field['proprety'];
    var constraints = field['constraints'];

    switch (fieldType) {
      case 'string':
        _dynamicWidgets.add(Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: TextInputFielDdWidget(
            inputFocusNode: _focusNodes.putIfAbsent(
                key, () => FocusNode()), // FocusNode dynamique
            label: label,
            keyboardType: TextInputType.text,
            txtEditingController: _textControllers.putIfAbsent(
                key, () => TextEditingController()),
            maxLength: constraints['maxLength'] ?? 100,
            validator: (value) {
              bool isOptional = constraints['isOptional'] ?? true;
              if (!isOptional && (value == null || value.isEmpty)) {
                return "Veuillez insérer ${label.toLowerCase()}";
              }
              return null;
            },
          ),
        ));
        callNotifiers();
        break;
      case 'webCam':
        _dynamicWidgets.add(Padding(
          padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: const Border(
                top: BorderSide(color: Colors.grey, width: 1),
                left: BorderSide(color: Colors.grey, width: 1),
                right: BorderSide(color: Colors.grey, width: 1),
                bottom: BorderSide(color: Colors.grey, width: 1),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                FormBuilderFilePicker(
                  name: "photosAttachments",
                  previewImages: false,
                  allowMultiple: true,
                  withData: true,
                  maxFiles: 1,
                  customFileViewerBuilder: (files, filesSetter) {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Nombre de colonnes
                        crossAxisSpacing: 4.0, // Espacement entre les colonnes
                        mainAxisSpacing: 4.0, // Espacement entre les lignes
                      ),
                      shrinkWrap: true,
                      itemCount: _selectedPhotos.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(File(_selectedPhotos[index]
                                      .path)), // Utiliser FileImage
                                  fit: BoxFit
                                      .cover, // Adapter l'image au conteneur
                                ),
                                borderRadius: BorderRadius.circular(
                                    10), // Arrondir les coins
                              ),
                            ),
                            Positioned(
                              right: 5, // Ajuster la position
                              top: 5, // Ajuster la position
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(
                                      0.5), // Arrière-plan semi-transparent pour l'icône
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  iconSize: 20,
                                  padding: EdgeInsets
                                      .zero, // Supprimer les marges autour de l'icône
                                  onPressed: () {
                                    _selectedPhotos.removeAt(index);
                                    // setState(() {});
                                  },
                                  icon: const Icon(Icons.close_rounded,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onChanged: (val) {
                    if (val != null && val.isNotEmpty) {
                      _selectedPhotos = [
                        ..._selectedPhotos, // Garder les photos précédemment capturées
                        ...val.map((file) =>
                            SelectedFile(name: file.name, path: file.path!))
                      ];

                      // Vérifier si la clé existe dans _textControllers
                      if (_textControllers[key] == null) {
                        _textControllers[key] = TextEditingController();
                      }

                      if (_selectedPhotos.isNotEmpty) {
                        if (_textControllers[key] == null) {
                          _textControllers[key] = TextEditingController();
                        }

                        _textControllers[key]!.text =
                            _selectedPhotos.first.path;
                        debugPrint(
                            'Photo path updated in controller: ${_selectedPhotos.first.path}');
                      }

                      debugPrint('Selected photos: $_selectedPhotos');
                    }
                    // setState(() {
                    // });
                  },
                  onFileLoading: (val) {
                    debugPrint('$val');
                  },
                  typeSelectors: [
                    TypeSelector(
                      type: FileType.image,
                      selector: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Icon(Icons.add_photo_alternate,
                              color: DigiPublicAColors.primaryColor),
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text("Photos",
                                style: TextStyle(color: Colors.black54)),
                          ),
                          const SizedBox(
                            width: 100,
                          ),
                          TextButton.icon(
                            onPressed: _takePhoto,
                            label: const Text("Caméra",
                                style: TextStyle(color: Colors.black54)),
                            icon: const Icon(
                              Icons.camera_alt,
                              color: DigiPublicAColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
        callNotifiers();
//limite
      case 'date':
        _dynamicWidgets.add(SelectDateInputWidget(
          inputFocusNode:
              _birthdateFocusNode, // Utilisation du focusNode spécifique
          label: label, // Libellé du champ
          txtEditingController: _textControllers.putIfAbsent(
              key,
              () =>
                  TextEditingController()), // Utilisation du contrôleur de texte
          isYearOnly: false,
          onChanged: (value) {
            if (_textControllers[key] != null) {
              _textControllers[key]!.text = value.toString();
              debugPrint("Date sélectionnée: ${_textControllers[key]!.text}");
            }
            // setState(() {
            // });
          },

          validator: (value) {
            if (_textControllers[key]?.text.isEmpty ?? true) {
              return "Veuillez insérer ${label.toLowerCase()}"; // Message de validation
            }
            // Si la valeur du texte est une date valide (exemple simple)

            return null;
          },
        ));
        callNotifiers();
      case 'select':
        // Si le champ est `currentEntityId`, on utilise le stream `filteredEntityStream`
        if (key == 'birthEntityId') {
          _dynamicWidgets.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: SelectInputDWidget<IEntity>(
                stream: Stream.value(filteredProvinceEntityDataSource),
                label: _selectedBirthProvinceOnlyEntity != null
                    ? _selectedBirthProvinceOnlyEntity!.name
                    : "Province d'habitation actuelle...",
                itemBuilder: (IEntity entity) {
                  return Text(entity.name);
                },
                selectedEntity: _selectedBirthProvinceOnlyEntity,
                onChanged: (IEntity? selectedEntity) {
                  if (selectedEntity != null) {
                    _selectedBirthProvinceOnlyEntity = selectedEntity;
                    debugPrint(
                        'Selected Province: ${_selectedBirthProvinceOnlyEntity?.id}');
                    if (_textControllers[key] == null) {
                      _textControllers[key] = TextEditingController();
                    }
                    _textControllers[key]!.text = selectedEntity.id;
                    // setState(() {
                    // });
                  }
                },
                isMultiSelect: false,
                validator: (value) {
                  if (_selectedBirthProvinceOnlyEntity == null ||
                      _selectedBirthProvinceOnlyEntity!.name.isEmpty) {
                    return "Veuillez sélectionner une province d'habitation";
                  }
                  return null;
                },
              ),
            ),
          );
          callNotifiers();
        } else if (key == 'birthEntity') {
          // Si le champ est `birthEntityId`, on filtre les options en fonction de `selectedCurrentEntity`
          _dynamicWidgets.add(StreamBuilder<List<IEntity>>(
            stream: filteredEntityStream,
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SelectInputDWidget<IEntity>(
                  stream: filteredEntityStream,
                  label: _selectedProvinceEntity != null
                      ? _selectedProvinceEntity!.name
                      : "Province de naissance",
                  itemBuilder: (IEntity entity) {
                    return Text(entity.name);
                  },
                  selectedEntity: _selectedProvinceEntity,
                  onChanged: (IEntity? selectedEntity) {
                    if (selectedEntity != null) {
                      // if (mounted) {
                      //   setState(() {
                      // Vos modifications d'état ici
                      debugPrint(
                          'Selected Province: ${_selectedProvinceEntity?.id}');
                      if (_textControllers[key] == null) {
                        _textControllers[key] = TextEditingController();
                      }
                      _textControllers[key]!.text = selectedEntity.id;
                      // });
                      // }
                    }
                  },
                  isMultiSelect: false,
                  validator: (value) {
                    if (_selectedProvinceEntity == null ||
                        _selectedProvinceEntity!.name.isEmpty) {
                      return "Veuillez sélectionner une province d'habitation";
                    }
                    return null;
                  },
                ),
              );
            },
          ));
          callNotifiers();
        } else {
          // Utilisation de SelectInputWidget pour les autres cas
          _dynamicWidgets.add(Padding(
            padding: const EdgeInsets.only(bottom: 10.0, top: 8.0),
            child: SelectInputDWidget<String>(
              stream: Stream.value(field['fields'] is List<dynamic>
                  ? List<String>.from(field['fields'])
                  : []),
              label: (_textControllers[key]?.text.isNotEmpty ?? false)
                  ? _textControllers[key]!.text
                  : (field['verbose'] ?? 'Sélection'),
              itemBuilder: (String option) => Text(option),
              selectedOptionValue:
                  (_textControllers[key]?.text.isNotEmpty ?? false)
                      ? _textControllers[key]!.text
                      : null,
              onChanged: (String? selectedOption) {
                if (selectedOption != null) {
                  if (_textControllers[key] != null) {
                    _textControllers[key]!.text = selectedOption;
                  } else {
                    _textControllers[key] =
                        TextEditingController(text: selectedOption);
                  }
                }
              },
              isMultiSelect: field['constraints']['isMultipleChoici'] ?? false,
              validator: (value) {
                if (!(field['constraints']['isOptional'] ?? true) &&
                    (value == null || value.isEmpty)) {
                  return "Sélectionnez ${field['verbose']?.toLowerCase() ?? 'une option'}";
                }
                return null;
              },
            ),
          ));
          callNotifiers();
        }

      case 'entity':
        // Si le champ est `currentEntityId`, on utilise le stream `filteredEntityStream`
        if (key == 'birthEntityId') {
          _dynamicWidgets.add(StreamBuilder<List<IEntity>>(
            stream: Stream.value(filteredProvinceEntityDataSource),
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SelectInputDWidget<IEntity>(
                  stream: Stream.value(filteredProvinceEntityDataSource),
                  label: _selectedProvinceEntity != null
                      ? _selectedProvinceEntity!.name
                      : "Province d'habitation actuelle...",
                  itemBuilder: (IEntity entity) {
                    return Text(entity.name);
                  },
                  selectedEntity: _selectedProvinceEntity,
                  onChanged: (IEntity? selectedEntity) {
                    if (selectedEntity != null) {
                      // if (mounted) {
                      //   setState(() {
                      // Vos modifications d'état ici
                      debugPrint(
                          'Selected Province: ${_selectedProvinceEntity?.id}');
                      if (_textControllers[key] == null) {
                        _textControllers[key] = TextEditingController();
                      }
                      _textControllers[key]!.text = selectedEntity.id;
                      //   });
                      // }
                    }
                  },
                  isMultiSelect: false,
                  validator: (value) {
                    if (_selectedProvinceEntity == null ||
                        _selectedProvinceEntity!.name.isEmpty) {
                      return "Veuillez sélectionner une province d'habitation";
                    }
                    return null;
                  },
                ),
              );
            },
          ));
          callNotifiers();
        } else if (key == 'birthEntity') {
          // Si le champ est `birthEntityId`, on filtre les options en fonction de `selectedCurrentEntity`

          _dynamicWidgets.add(StreamBuilder<List<IEntity>>(
            stream: commonService.entityStream,
            builder: (context, snapshot) {
              List<IEntity> entities = [];
              if (_selectedProvinceEntity != null) {
                if (snapshot.data != null) {
                  entities = snapshot.data!
                      .where((entity) =>
                          entity.parentNumber ==
                          _selectedProvinceEntity!.number)
                      .toList();
                }
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SelectInputDWidget<IEntity>(
                  stream: filteredSubEntityStream,
                  label: _selectedBirthProvinceEntity != null
                      ? _selectedBirthProvinceEntity!.name
                      : "Lieu de Naissance...",
                  itemBuilder: (IEntity entity) {
                    return Text(entity.name);
                  },
                  selectedEntity: _selectedBirthProvinceEntity,
                  onChanged: (IEntity? selectedEntity) {
                    if (selectedEntity != null) {
                      if (_textControllers[key] != null) {
                        _textControllers[key]!.text =
                            selectedEntity.id.toString();
                      } else {
                        _textControllers[key] = TextEditingController(
                            text: selectedEntity.id.toString());
                      }
                      // if (mounted) {
                      //   setState(() {
                      _selectedBirthProvinceEntity = selectedEntity;
                      debugPrint("Entité sélectionnée: ${selectedEntity.name}");
                      //   });
                      // }
                    }
                  },
                  isMultiSelect: false,
                  validator: (value) {
                    if (_selectedBirthProvinceEntity == null ||
                        _selectedBirthProvinceEntity!.id.isEmpty) {
                      return "Veuillez sélectionner un lieu de naissance";
                    }
                    return null;
                  },
                ),
              );
            },
          ));
          callNotifiers();
        } else if (key == 'commune') {
          _dynamicWidgets.add(Consumer<EntitySelectionProvider>(
            builder: (context, provider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sélection de la province
                  SelectInputDWidget<IEntity>(
                    stream: Stream.value(filteredProvinceEntityDataSource),
                    label: selectedProvince.name.isNotEmpty
                        ? selectedProvince.name
                        : "Province",
                    itemBuilder: (IEntity entity) => Text(entity.name),
                    selectedEntity: selectedProvince,
                    onChanged: (IEntity? selectedEntity) async {
                      debugPrint(" ---- before map ----  ");
                      if (selectedEntity != null) {
                        selectedProvince = selectedEntity;
                        // filteredTownEntityDataSource.clear();
                        // filteredTownshipEntityDataSource.clear();
                        // _townStreamController.add([]);
                        // _townShipStreamController.add([]);
                        selectedCity = IEntity.empty();
                        selectedTownship = IEntity.empty();
                        filterTownEntities(selectedEntity);
                        debugPrint(" ---- in if map ----  ");
                        if (_textControllers[key] != null) {
                          _textControllers[key]!.text =
                              selectedEntity.id.toString();
                        } else {
                          _textControllers[key] = TextEditingController(
                              text: selectedEntity.id.toString());
                        }
                      }
                    },
                    isMultiSelect: false,
                    validator: (value) {
                      if (selectedProvince.name.isEmpty) {
                        return "Veuillez sélectionner une province";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Sélection de la ville
                  StreamBuilder<List<IEntity>>(
                    stream: context.read<DynamicFormProvider>().townStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        debugPrint("\n\n\n snapshot.data : ${snapshot.data}");
                        return SelectInputNormalWidget<IEntity>(
                          dataList: snapshot.data!,
                          label: selectedCity.name.isNotEmpty
                              ? selectedCity.name
                              : "Ville",
                          itemBuilder: (IEntity entity) => Text(entity.name),
                          selectedEntity: selectedCity,
                          onChanged: (IEntity? selectedEntity) {
                            if (selectedEntity != null) {
                              selectedTownship = IEntity.empty();
                              selectedCity = selectedEntity;
                              filterTownShipEntities(selectedEntity);
                              if (_textControllers[key] != null) {
                                _textControllers[key]!.text =
                                    selectedEntity.id.toString();
                              } else {
                                _textControllers[key] = TextEditingController(
                                  text: selectedEntity.id.toString(),
                                );
                              }
                            }
                          },
                          isMultiSelect: false,
                          validator: (value) {
                            if (selectedCity == null) {
                              return "Veuillez sélectionner une ville";
                            }
                            return null;
                          },
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  StreamBuilder<List<IEntity>>(
                    stream: context.read<DynamicFormProvider>().townShipStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return SelectInputNormalWidget<IEntity>(
                          dataList: snapshot.data!,
                          label: selectedTownship.name.isNotEmpty
                              ? selectedTownship.name
                              : "Commune",
                          itemBuilder: (IEntity entity) => Text(entity.name),
                          selectedEntity: selectedTownship,
                          onChanged: (IEntity? selectedEntity) {
                            if (selectedEntity != null) {
                              selectedTownship = selectedEntity;
                              // Provider.of<EntitySelectionProvider>(context,
                              //         listen: false)
                              //     .setTownshipEntity(selectedEntity);
                              if (_textControllers[key] != null) {
                                _textControllers[key]!.text =
                                    selectedEntity.id.toString();
                              } else {
                                _textControllers[key] = TextEditingController(
                                    text: selectedEntity.id.toString());
                              }
                            }
                          },
                          isMultiSelect: false,
                          validator: (value) {
                            if (selectedTownship == null) {
                              return "Veuillez sélectionner une commune";
                            }
                            return null;
                          },
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          ));
          callNotifiers();
        } else {
          // Utilisation de SelectInputWidget pour les autres cas
          _dynamicWidgets.add(Padding(
            padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
            child: SelectInputDWidget<String>(
              stream: Stream.value(field['fields'] is List<dynamic>
                  ? List<String>.from(field['fields'])
                  : []),
              label: (_textControllers[key]?.text.isNotEmpty ?? false)
                  ? _textControllers[key]!.text
                  : (field['verbose'] ?? 'Sélection'),
              itemBuilder: (String option) => Text(option),
              selectedOptionValue:
                  (_textControllers[key]?.text.isNotEmpty ?? false)
                      ? _textControllers[key]!.text
                      : null,
              onChanged: (String? selectedOption) {
                if (selectedOption != null) {
                  // setState(() {
                  if (_textControllers[key] != null) {
                    _textControllers[key]!.text = selectedOption;
                  } else {
                    _textControllers[key] =
                        TextEditingController(text: selectedOption);
                  }
                  // });
                }
              },
              isMultiSelect: field['constraints']['isMultipleChoici'] ?? false,
              validator: (value) {
                if (!(field['constraints']['isOptional'] ?? true) &&
                    (value == null || value.isEmpty)) {
                  return "Sélectionnez ${field['verbose']?.toLowerCase() ?? 'une option'}";
                }
                return null;
              },
            ),
          ));
          callNotifiers();
        }

      case 'phone':
        _dynamicWidgets.add(TextInputFielDdWidget(
          inputFocusNode: _phoneFocusNode,
          label: label,
          keyboardType: TextInputType.phone,
          txtEditingController: _textControllers.putIfAbsent(
            key,
            () => TextEditingController(text: '243-'), // Préremplir avec '243-'
          ),
          maxLength: 16, // Longueur maximale avec les traits
          onChange: (value) {
            // Formater dynamiquement la saisie
            final formattedValue = formatPhoneNumber(value);

            // Éviter de boucler si la valeur est déjà formatée
            if (formattedValue != value) {
              final controller = _textControllers[key]!;

              // Mettre à jour le texte affiché dans l'input avec les traits
              controller.value = TextEditingValue(
                text: formattedValue,
                selection:
                    TextSelection.collapsed(offset: formattedValue.length),
              );
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Veuillez insérer un numéro de téléphone";
            } else if (!isValidPhone(value)) {
              return "Numéro de téléphone invalide";
            }
            return null;
          },
        ));
        callNotifiers();
        break;

      case 'file':
        if (key == 'identityCard') {
          _dynamicWidgets.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        children: [
                          Text(
                            "Carte d'identité",
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                    FormBuilderFilePicker(
                      name: label,
                      previewImages: true,
                      allowMultiple: false,
                      withData: true,
                      maxFiles: 1,
                      customFileViewerBuilder: (files, filesSetter) {
                        return Consumer<DynamicFormProvider>(
                          builder: (context, provider, child) {
                            return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 4.0,
                                mainAxisSpacing: 4.0,
                              ),
                              shrinkWrap: true,
                              itemCount: provider._identityCard.length,
                              itemBuilder: (context, index) {
                                final card = provider._identityCard[index];
                                return Stack(
                                  children: [
                                    Container(
                                      height: 70,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: FileImage(File(card['path'])),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    Positioned(
                                      right: 5,
                                      top: 5,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          iconSize: 20,
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            provider
                                                .removeIdentityCardAt(index);
                                          },
                                          icon: const Icon(Icons.close_rounded,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                      onChanged: (val) {
                        if (val != null && val.isNotEmpty) {
                          final List<Map<String, dynamic>> updatedCards =
                              val.map((file) {
                            return {
                              'name': file.name,
                              'size': file.size,
                              'path': file.path,
                              'format': file.extension,
                            };
                          }).toList();
                          // final provider = Provider.of<DynamicFormProvider>(
                          //     context,
                          //     listen: false);
                          updateIdentityCard(
                              updatedCards); // Mettre à jour la liste des cartes d'identité<DynamicFormProvider>(context,
                          // Mise à jour du TextEditingController associé
                          if (_textControllers[key] == null) {
                            _textControllers[key] = TextEditingController();
                          }
                          _textControllers[key]!.text = updatedCards[0]['path'];
                          debugPrint(
                              'Photo path updated: ${updatedCards[0]['path']}');
                        }
                      },
                      onFileLoading: (val) {
                        debugPrint('File loading status: $val');
                      },
                      typeSelectors: [
                        TypeSelector(
                          type: FileType.any,
                          selector: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.add_photo_alternate,
                                  color: DigiPublicAColors.primaryColor),
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text("Photos"),
                              ),
                              const SizedBox(width: 100),
                              TextButton.icon(
                                onPressed: () async {
                                  final ImagePicker picker = ImagePicker();
                                  final XFile? image = await picker.pickImage(
                                      source: ImageSource.camera);
                                  if (image != null) {
                                    _image = File(image.path);
                                    _recognizeText(_image!);
                                    final List<Map<String, dynamic>> newCard = [
                                      {
                                        'name': image.name,
                                        'size': await image.length(),
                                        'path': image.path,
                                        'format': image.path.split('.').last,
                                      }
                                    ];
                                    updateIdentityCard(newCard);
                                    if (_textControllers[key] == null) {
                                      _textControllers[key] =
                                          TextEditingController();
                                    }
                                    _textControllers[key]!.text = image.path;
                                    debugPrint('Photo captured: ${image.path}');
                                  }
                                },
                                label: const Text(
                                  "Caméra",
                                  style: TextStyle(color: Colors.black87),
                                ),
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: DigiPublicAColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
          callNotifiers();
        } else {
          _dynamicWidgets.add(Padding(
            padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: const Border(
                  top: BorderSide(color: Colors.grey, width: 1),
                  left: BorderSide(color: Colors.grey, width: 1),
                  right: BorderSide(color: Colors.grey, width: 1),
                  bottom: BorderSide(color: Colors.grey, width: 1),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      label,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w300),
                    ),
                  ),
                  FormBuilderFilePicker(
                    name: label,
                    previewImages: true,
                    allowMultiple: false,
                    withData: true,
                    maxFiles: 1,
                    customFileViewerBuilder: (files, filesSetter) {
                      // Initialiser la liste pour chaque clé si inexistante
                      _selectedFiles.putIfAbsent(key, () => []);
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0,
                        ),
                        shrinkWrap: true,
                        itemCount: _selectedFiles[key]!.length,
                        itemBuilder: (context, index) {
                          final fileData = _selectedFiles[key]![index];
                          return Stack(
                            children: [
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(File(fileData['path'])),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              Positioned(
                                right: 5,
                                top: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    iconSize: 20,
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      // Suppression de l'élément et mise à jour de l'état
                                      // setState(() {
                                      _selectedFiles[key]!.removeAt(index);
                                      // });
                                    },
                                    icon: const Icon(Icons.close_rounded,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onChanged: (val) {
                      // setState(() {
                      if (val != null && val.isNotEmpty) {
                        _selectedFiles[key] = val
                            .map((file) => {
                                  'name': file.name,
                                  'size': file.size,
                                  'path': file.path,
                                  'format': file.extension,
                                })
                            .toList();
                        if (_textControllers.containsKey(key)) {
                          _textControllers[key]!.text =
                              _selectedFiles[key]![0]['path'].toString();
                        }
                      } else {
                        // Vider la liste si aucune photo sélectionnée
                        _selectedFiles[key] = [];
                      }
                      // });
                    },
                  ),
                ],
              ),
            ),
          ));
          callNotifiers();
        }

      case 'email':
        _dynamicWidgets.add(Container(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: TextInputFieldWidget(
            inputFocusNode:
                _emailFocusNode, // Focus spécifique pour le champ de l'email
            label: label, // Libellé pour l'email
            keyboardType:
                TextInputType.emailAddress, // Type de clavier pour l'email
            txtEditingController: _textControllers.putIfAbsent(
                key, () => TextEditingController()), // Contrôleur de texte
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Veuillez insérer l'adresse mail"; // Validation si le champ est vide
              }
              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
              if (!emailRegex.hasMatch(value)) {
                return "Entrez un email valide"; // Message d'erreur si l'email est invalide
              }
              return null;
            },
          ),
        ));
        callNotifiers();
      default:
        return;
    }
  }

  void setFormField(
      {required BuildContext context,
      required CommonService commonService,
      required List<dynamic> dynamicFields}) {
    context = context;
    _getDynamicFields = dynamicFields;
    _dynamicWidgets.clear();

    callStreamNotifiers();

    for (var field in dynamicFields) {
      // debugPrint("field))))) : $field \N\N");
      _buildField(field);
    }
    // debugPrint("=============END LOOP))))) : ${_dynamicFields.length} ");

    // _currentPerson = person;
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   notifyListeners();
    // });
  }

  // Méthode pour réinitialiser les champs
  void clearFields() {
    _dynamicWidgets = [];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void callNotifiers() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
