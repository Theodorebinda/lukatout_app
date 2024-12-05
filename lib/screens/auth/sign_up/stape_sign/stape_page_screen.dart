import 'dart:io';

import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lukatout/common/common_service.dart';
import 'package:lukatout/constant/colors.dart';
import 'package:lukatout/models/person.dart';
import 'package:lukatout/models/university.dart';
import 'package:lukatout/providers/person_provider.dart';
import 'package:lukatout/providers/student_form.dart';
import 'package:lukatout/widgets/steps_sign_up/choise_program.dart';
import 'package:lukatout/widgets/steps_sign_up/uploaded_docs.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;

class StapePage extends StatefulWidget {
  const StapePage({super.key});

  @override
  State<StapePage> createState() => _StapePageState();
}

class _StapePageState extends State<StapePage> {
  final CommonService commonService = CommonService();
  List<String> recognizedLines = [];
  List<String> extractedData = [];
  bool _isLoading = false;

  Map<String, dynamic>? personHeadData;
  int activeStep = 0;
  int activeStep2 = 0;
  int reachedStep = 0;
  int upperBound = 5;
  double progress = 0.2;
  Set<int> reachedSteps = <int>{0, 2, 4, 5};
  final dashImages = [
    'assets/images/StudentProgramme.jpg',
    'assets/images/photoPrepareDemande.jpg',
    "assets/images/s'inscriphoto.jpg",
    'assets/images/SoumettreDemande.jpeg',
    'assets/images/AdmisPhoto.jpg',
  ];
  final List<Widget> dashImagesByStep = [
    Stack(children: [
      Container(
        width: double.infinity,
        height: 250.0,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(1.0),
          image: const DecorationImage(
            image: AssetImage('assets/images/StudentProgramme.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      const Positioned(
        bottom: 10,
        right: 5.0,
        child: SizedBox(
          width: 300.0,
          child: Column(
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Trouve avec soin Ton Université',
                  style: TextStyle(
                      color: DigiPublicAColors.whiteColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Roboto"),
                ),
              ),
              SizedBox(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Choisi l'université de ton choix",
                        style: TextStyle(
                            color: DigiPublicAColors.whiteColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto"),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Trouve ta faculté et Choisi ton option",
                        style: TextStyle(
                            color: DigiPublicAColors.whiteColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ]),
    Stack(children: [
      Container(
        width: double.infinity,
        height: 250.0,
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 10.0,
            image: AssetImage('assets/images/photoPrepareDemande.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      const Positioned(
        top: 20,
        left: 10.0,
        child: SizedBox(
          width: 300.0,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              'Prepare Toi !',
              style: TextStyle(
                  color: DigiPublicAColors.whiteColor,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Roboto"
                  // fontFamily: ,
                  ),
            ),
          ),
        ),
      ),
      const Positioned(
        bottom: 20,
        right: 5.0,
        child: SizedBox(
          width: 250.0,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Les Documents necessaire",
                  style: TextStyle(
                      color: DigiPublicAColors.whiteColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Roboto"),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Certain Document Te Manque ?",
                  style: TextStyle(
                      color: DigiPublicAColors.whiteColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Roboto"),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Tu Peux Faire une Demande",
                  style: TextStyle(
                      color: DigiPublicAColors.whiteColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Roboto"),
                ),
              ),
            ],
          ),
        ),
      )
    ]),
    Stack(children: [
      Container(
        width: double.infinity,
        height: 280.0,
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 8.0,
            image: AssetImage("assets/images/s'inscriphoto.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      ),
      const Positioned(
        top: 20,
        left: 10.0,
        child: SizedBox(
          width: 200.0,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              'Inscris Toi !',
              style: TextStyle(
                  color: DigiPublicAColors.whiteColor,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Roboto"),
            ),
          ),
        ),
      ),
      const Positioned(
        bottom: 20,
        right: 5.0,
        child: SizedBox(
          width: 250.0,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Nous vous prions de bien vouloir prendre quelques minutes pour remplir le formulaire ci-dessous",
              style: TextStyle(
                  color: DigiPublicAColors.whiteColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Roboto"),
            ),
          ),
        ),
      )
    ]),
    Stack(children: [
      Container(
        width: double.infinity,
        height: 250.0,
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 8.0,
            image: AssetImage('assets/images/SoumettreDemande.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      const Positioned(
        bottom: 20,
        right: 5.0,
        child: SizedBox(
          width: 250.0,
          child: Column(
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Verifies Tes Information',
                  style: TextStyle(
                      color: DigiPublicAColors.whiteColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Roboto"),
                ),
              ),
              SizedBox(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Rassure Toi Que Chaque Champs Soit Bien Remplit Avant La Soumission",
                    style: TextStyle(
                        color: DigiPublicAColors.whiteColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Roboto"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ]),
    Stack(children: [
      Container(
        width: double.infinity,
        height: 250.0,
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 10.0,
            image: AssetImage('assets/images/AdmisPhoto.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      const Positioned(
        top: 20,
        left: 10.0,
        child: SizedBox(
          width: 300.0,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "C'est Fait !",
              style: TextStyle(
                  color: DigiPublicAColors.whiteColor,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Roboto"),
            ),
          ),
        ),
      ),
      const Positioned(
        bottom: 20,
        right: 5.0,
        child: SizedBox(
          width: 320.0,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Votre Demande d'admission Va Etre Traité",
              style: TextStyle(
                  color: DigiPublicAColors.whiteColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Roboto"),
            ),
          ),
        ),
      )
    ]),
  ];

  List<Widget> stepWidgets = [];

  @override
  void initState() {
    super.initState();
    // formServiceSingleton.fetchForm();
    updateStep(2);
    // imagePicker = ImagePicker();
  }

  void increaseProgress() {
    if (progress < 1) {
      setState(() => progress += 0.2);
    } else {
      setState(() => progress = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    stepWidgets = [
      //Trouve Ton Programme
      UniversitySelectionPage(
        updateStep: (value) {
          debugPrint("next step clicked: $value");
          activeStep = value;
          setState(() {});
          // updateStep(value);
        },
      ),

      //Prepare Ta Demande

      MultiDocumentUploader(onDocumentsUploaded: (documents) {
        documents.forEach((type, file) {
          debugPrint("$type: ${file.path}");
        });
      }, updateStep: (value) {
        debugPrint("next step clicked: $value");
        activeStep = value;
        setState(() {});
        // updateStep(value)
      }),

      //Inscris Toi Rempli le Formulaire
      NewPersonFormDynamic(
        updateStep: (value) {
          debugPrint("next step clicked: $value");
          activeStep = value;
          setState(() {});
          // updateStep(value);
        },
      ),

      //Verifies Tes Information Recaptulation
      SummaryComponent(
        updateStep: (value) {
          debugPrint("next step clicked: $value");
          activeStep = value;
          setState(() {});
          // updateStep(value);
        },
      ),

      //C'est Fait! Demande Traité Recap
      const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle,
              size: 100, color: DigiPublicAColors.greenColor),
          SizedBox(height: 10),
          Text(
            "Votre Demande d'admission a été envoyer avec succes !",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text("Un Mail vous est envoyé avec vos identifiant."),
        ],
      ),
    ];
    return MaterialApp(
      title: 'Step-sign-up',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.grey,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Demande D'admission"),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 199, 239, 243),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    dashImagesByStep[activeStep],
                  ],
                ),

                // Stepper
                EasyStepper(
                  activeStep: activeStep,
                  lineStyle: const LineStyle(
                    lineLength: 60,
                    lineType: LineType.normal,
                    lineThickness: 3,
                    lineSpace: 1,
                    lineWidth: 10,
                    unreachedLineType: LineType.dashed,
                  ),
                  stepShape: StepShape.rRectangle,
                  stepBorderRadius: 15,
                  borderThickness: 2,
                  internalPadding: 10,
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 30,
                    vertical: 20,
                  ),
                  stepRadius: 28,
                  finishedStepBorderColor: DigiPublicAColors.primaryColor,
                  finishedStepTextColor: DigiPublicAColors.primaryColor,
                  finishedStepBackgroundColor: DigiPublicAColors.greenColor,
                  activeStepIconColor: DigiPublicAColors.primaryColor,
                  showLoadingAnimation: false,
                  steps: [
                    EasyStep(
                      customStep: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Opacity(
                          opacity: activeStep >= 0 ? 1 : 0.3,
                          child: Image.asset('assets/logo/ico-etape-01.png'),
                        ),
                      ),
                      customTitle: const Text(
                        'Trouve Ton Programme',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    EasyStep(
                      customStep: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Opacity(
                          opacity: activeStep >= 1 ? 1 : 0.3,
                          child: Image.asset('assets/logo/ico-etape-02.png'),
                        ),
                      ),
                      customTitle: const Text(
                        "Prépare Ta Demande",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    EasyStep(
                      customStep: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Opacity(
                          opacity: activeStep >= 2 ? 1 : 0.3,
                          child: Image.asset('assets/logo/ico-etape-03.png'),
                        ),
                      ),
                      customTitle: const Text(
                        'Remplis Le Formulaire',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    EasyStep(
                      customStep: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Opacity(
                          opacity: activeStep >= 3 ? 1 : 0.3,
                          child: Image.asset('assets/logo/ico-etape-03.png'),
                        ),
                      ),
                      customTitle: const Text(
                        'Soumets Ta Demande',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    EasyStep(
                      customStep: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Opacity(
                          opacity: activeStep >= 4 ? 1 : 0.3,
                          child: Image.asset('assets/logo/ico-etape-03.png'),
                        ),
                      ),
                      customTitle: const Text(
                        'Lance Toi',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  onStepReached: (index) => setState(() => activeStep = index),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    width: double.infinity,
                    // height: double.negativeInfinity,
                    child: stepWidgets[activeStep],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _allowTabStepping(int index, StepEnabling enabling) {
    return enabling == StepEnabling.sequential
        ? index <= reachedStep
        : reachedSteps.contains(index);
  }

  /// Returns the next button.
  Widget _nextStep(StepEnabling enabling) {
    return IconButton(
      onPressed: () {
        if (activeStep2 < upperBound) {
          setState(() {
            if (enabling == StepEnabling.sequential) {
              ++activeStep2;
              if (reachedStep < activeStep2) {
                reachedStep = activeStep2;
              }
            } else {
              activeStep2 =
                  reachedSteps.firstWhere((element) => element > activeStep2);
            }
          });
        }
      },
      icon: const Icon(Icons.arrow_forward_ios),
    );
  }

  /// Returns the previous button.
  Widget _previousStep(StepEnabling enabling) {
    return IconButton(
      onPressed: () {
        if (activeStep2 > 0) {
          setState(() => enabling == StepEnabling.sequential
              ? --activeStep2
              : activeStep2 =
                  reachedSteps.lastWhere((element) => element < activeStep2));
        }
      },
      icon: const Icon(Icons.arrow_back_ios),
    );
  }

  void updateStep(int step) {
    setState(() {
      activeStep2 = step;
    });
  }
}

enum StepEnabling { sequential, individual }

// ignore: must_be_immutable
class SummaryComponent extends StatelessWidget {
  final Function(int) updateStep;
  SummaryComponent({
    super.key,
    required this.updateStep,
  });

  IUniversity university = IUniversity.empty();
  IFaculty faculty = IFaculty.empty();
  IOption option = IOption.empty();
  IPerson person = IPerson.empty();

  // Méthode pour générer le PDF
  Future<void> generatePdf(BuildContext context) async {
    final pdf = pw.Document();

    // Ajouter le contenu dans le PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Résumé de l'inscription",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Text("Université : ${university.name ?? 'Non spécifié'}"),
              pw.Text("Faculté : ${faculty.name}"),
              pw.Text("Option : ${option.name ?? 'Non spécifiée'}"),
              pw.SizedBox(height: 16),
              pw.Text("Nom : ${person.firstName} ${person.lastName}"),
              pw.Text(
                  "Email : ${person.currentEmailAddress ?? 'Non spécifié'}"),
              pw.Text("Téléphone : ${person.currentPhoneNumber}"),
            ],
          );
        },
      ),
    );

    // Sauvegarder le PDF dans un fichier
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/summary.pdf");
    await file.writeAsBytes(await pdf.save());

    // Ouvrir ou partager le fichier
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF enregistré dans : ${file.path}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Récupération des données depuis les Providers
    university = Provider.of<FormRecapProvider>(context).studentSelections!;
    faculty = Provider.of<FormRecapProvider>(context).selectedFaculty!;
    option = Provider.of<FormRecapProvider>(context).selectedOption!;
    person = Provider.of<PersonProvider>(context).currentPerson!;

    return Material(
      color: DigiPublicAColors.whiteColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Formulaire d'Inscription",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                const Text("Etablissement",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text("Nom de l'université  :   ${university.name!}"),
                const SizedBox(height: 10),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text("La Faculté                 :"),
                    const SizedBox(width: 15),
                    Flexible(child: Text(faculty.name)),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(),
                Row(
                  children: [
                    const Text("Département             :"),
                    const SizedBox(width: 15),
                    Flexible(
                      child: Text(option.name!),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                const Text("Information Personelle",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text("Nom                         :"),
                        const SizedBox(width: 15),
                        Text(person.firstName),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(),
                    Row(
                      children: [
                        const Text("Post Nom                 :"),
                        const SizedBox(width: 15),
                        Text(person.lastName),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(),
                    Row(
                      children: [
                        const Text("Post Nom                 :"),
                        const SizedBox(width: 15),
                        Text(person.middlename!),
                      ],
                    ),
                    const SizedBox(height: 5.0),
                    const Divider(),
                    Row(
                      children: [
                        const Text("Email                        :  "),
                        Text(person.currentEmailAddress!),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(),
                    Row(
                      children: [
                        const Text("Téléphone                :  "),
                        Text(person.currentPhoneNumber),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Divider(),
                    Row(
                      children: [
                        const Text("Adresse                    :  "),
                        Text(person.address!),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Divider(),
                    Text("Niveau d'étude        :  ${person.schoolLevel}"),
                    const SizedBox(height: 5),
                    const Divider(),
                    const SizedBox(height: 5),
                    Text(
                        "État civil                   :  ${person.maritalStatus}"),
                    const SizedBox(height: 5),
                    const Divider(),
                    const SizedBox(height: 5),
                    Text("Nationalité              :  ${person.nationality}"),
                    const SizedBox(height: 5),
                    const Divider(),
                    Row(
                      children: [
                        Text(
                            "Option                     :  ${person.studyField!}"),
                      ],
                    ),
                    const Divider(),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const SizedBox(
                  height: 10.0,
                ),
              ],
            ),
            const SizedBox(height: 50),
            // Bouton pour générer le PDF
            Center(
              child: ElevatedButton(
                onPressed: () {
                  updateStep(4);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const SizedBox(
                    width: 330,
                    height: 50,
                    child: Center(child: Text("Valider"))),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
