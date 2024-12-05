import 'package:flutter/material.dart';
import 'package:lukatout/constant/colors.dart';
import 'package:lukatout/screens/dashboard/teachers/teachers.dart';
import 'package:lukatout/screens/profile/edite_profile/edite_profile_avatar.dart';
import 'package:lukatout/security/security_service.dart';
import 'package:lukatout/utils/app_show_bottom_sheet.dart';
import 'package:lukatout/widgets/custom_container.dart';
import 'package:lukatout/widgets/digi_progress_indicator.dart';
import 'package:lukatout/widgets/refrechable_page.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _oldPinFocusNode = FocusNode();
  final _newPinFocusNode = FocusNode();
  final _oldPinTextEditingController = TextEditingController();
  final _newPinTextEditingController = TextEditingController();
  bool _isLoading = false;
  @override
  void initState() {
    final student = securityServiceSingleton.userInfo.first;
    // final studentId = student.
    debugPrint("StudentID : $student");

    // studentServiceSingleton.fetchStudent(studentId!);
    super.initState();
  }

  @override
  void dispose() {
    _oldPinFocusNode.dispose();
    _newPinFocusNode.dispose();
    _oldPinTextEditingController.dispose();
    _newPinTextEditingController.dispose();
    super.dispose();
  }

  //  fonction a appelée lorsque l'utilisateur tirera pour rafraîchir
  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true; // Commence le chargement
    });

    try {
      final student = await securityServiceSingleton.userInfo.first;
      // final studentId = student!.id;
      // debugPrint("Student ID: $studentId");
      // await securityServiceSingleton.fetchStudent(studentId);
    } catch (e) {
      debugPrint('Erreur lors de la récupération des données : $e');
    } finally {
      setState(() {
        _isLoading = false; // Termine le chargement
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshablePage(
      onRefresh: _handleRefresh,
      indicatorColor: DigiPublicAColors.primaryColor,
      backgroundColor: Colors.white,
      child: Column(
        children: [
          if (_isLoading) // Vérifie si le chargement est actif
            const DigiProgressIndicator(),
          if (!_isLoading) ...[
            _buildProfileDetail(),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileDetail() {
    return StreamBuilder(
        stream: securityServiceSingleton.userInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Oops une erreur s'est produite"); //Skeletton a (faire)
          } else if (snapshot.hasError || !snapshot.hasData) {
            debugPrint(snapshot.data.toString());
            return const Center(
              child: Text('Erreur de chargement'),
            ); // Gestion des erreurs
          } else {
            return Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 280.0,
                  child: Stack(
                    children: [
                      Positioned(
                        child: Container(
                          width: double.infinity,
                          height: 130.0,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 151, 237, 245),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 20.0,
                        left: 6.0,
                        child: CustomContainer.buildContainer(
                          child: Container(
                            width: 330.0,
                            height: 180.0,
                            color: DigiPublicAColors.whiteColor,
                            child: Center(
                              child: SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8.0, 8.0, 8.0, 10.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                              padding: EdgeInsets.all(2.0),
                                              decoration: const BoxDecoration(
                                                color: DigiPublicAColors
                                                    .primaryColor,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Hero(
                                                  tag: "image",
                                                  child: Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        onTap: () {
                                                          _navigateToEditAvatar(
                                                              context,
                                                              snapshot
                                                                  .data?.id);
                                                        },
                                                        child: Stack(
                                                          children: [
                                                            CircleAvatar(
                                                              radius: 35,
                                                              backgroundImage: (snapshot
                                                                              .data
                                                                              ?.id !=
                                                                          null &&
                                                                      snapshot
                                                                          .data!
                                                                          .id
                                                                          .isNotEmpty)
                                                                  ? const NetworkImage(
                                                                      "https://lh3.googleusercontent.com/a/ACg8ocKi7_sRkEisPwvp2TKaQQXOPC0DjsoGJ24BReynndwrm_7InhzT=s288-c-no")
                                                                  // "http://178.128.203.123:8000/api/v1/img${snapshot.data!.person.photoUrl}")
                                                                  : const AssetImage(
                                                                          'assets/icon/app-icon.png')
                                                                      as ImageProvider,
                                                            ),
                                                            Positioned(
                                                              bottom: 0,
                                                              right: 0,
                                                              child: InkWell(
                                                                onTap: () {
                                                                  digiPublicShowBottomSheet(
                                                                    context:
                                                                        context,
                                                                    child: const Text(
                                                                        "Logique pour changer la photo a faire"),
                                                                    height:
                                                                        300.0,
                                                                  );
                                                                  // Action à déclencher pour éditer l'avatar (A faire)
                                                                },
                                                                child:
                                                                    const CircleAvatar(
                                                                  radius: 12,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .blueAccent,
                                                                  child: Icon(
                                                                    Icons.edit,
                                                                    size: 16,
                                                                    color: DigiPublicAColors
                                                                        .whiteColor,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )))),
                                          const SizedBox(height: 10),
                                          Text(
                                            snapshot.data?.name ?? '_',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Roboto",
                                              color: DigiPublicAColors
                                                  .primaryColor,
                                            ),
                                          ),
                                          Text(
                                            snapshot.data?.email ??
                                                'Numéro Inconnu',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color:
                                                  DigiPublicAColors.greyColor,
                                            ),
                                          ),
                                          const Text(
                                            'Info. Industruelle',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  DigiPublicAColors.greyColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBlock(
                        "Syllabus",
                        //  snapshot.data,
                        "assets/icon/syllabus.png"),
                    _buildBlock(
                        "Payment",
                        //  snapshot.data,
                        "assets/icon/payment.png"),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBlock(
                        "Cours",
                        // snapshot.data,
                        "assets/icon/19-194546_icon-book-transparent-book-icon-png-png-download-removebg-preview.png"),
                    _buildBlock(
                        "Resultat",
                        // snapshot.data,
                        "assets/icon/Resultat.png"),
                  ],
                ),
                const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Professeurs",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: DigiPublicAColors.darkGreyColor,
                        fontFamily: "Helvetica",
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                _buildTeacherList(teachers, context),
                const SizedBox(
                  height: 30.0,
                )
              ],
            );
          }
        });
  }
}

void _navigateToEditAvatar(BuildContext context, String? imageUrl) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => EditAvatarPage(
          imageUrl!,
          imageUrl:
              'https://lh3.googleusercontent.com/a/ACg8ocKi7_sRkEisPwvp2TKaQQXOPC0DjsoGJ24BReynndwrm_7InhzT=s288-c-no'),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 0.1);
        const end = Offset(0.0, 0.0);
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    ),
  );
}

Widget _buildBlock(String name, String imageUrl) {
  return CustomContainer.buildContainer(
    child: SizedBox(
      width: 130,
      height: 130,
      child: Center(
        child: Column(
          children: [
            ClipOval(
              child: Container(
                width: double.infinity,
                height: 80.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    opacity: 5,
                    image: AssetImage(imageUrl),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5.0),
            Column(
              children: [
                Text(
                  name, // Utilisation du paramètre name
                  style: const TextStyle(
                      fontSize: 20.0,
                      color: DigiPublicAColors.darkGreyColor,
                      fontWeight: FontWeight.w600),
                ),
                // Text(
                //   data?.name ?? 'Nom Inconnu',
                //   style:
                //       const TextStyle(color: DigiPublicAColors.secondaryColor),
                // ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

final teachers = [
  {
    "name": "Jean Dupont",
    "course": "Mathématiques",
    "profileImageUrl":
        "https://media.licdn.com/dms/image/v2/D4E03AQGHpmTwUe6QDw/profile-displayphoto-shrink_400_400/profile-displayphoto-shrink_400_400/0/1687356763478?e=1737590400&v=beta&t=Ozxtj8PoRh2YsDN20IdcVjmuuCvjLc4jWRg34cpQveg"
  },
  {
    "name": "Marie Curie",
    "course": "Physique",
    "profileImageUrl":
        "https://media.licdn.com/dms/image/v2/D4E03AQHxELeYegivDQ/profile-displayphoto-shrink_400_400/profile-displayphoto-shrink_400_400/0/1731347846852?e=1737590400&v=beta&t=wZD85UH2lXXNRzbhYwv9GZpO4BhhQtKidQEWuG-v2Co"
  },
  {
    "name": "Victor Hugo",
    "course": "Littérature",
    "profileImageUrl":
        "https://media.licdn.com/dms/image/v2/D4D03AQG6dhQgF6oIMg/profile-displayphoto-shrink_400_400/profile-displayphoto-shrink_400_400/0/1727102587896?e=1737590400&v=beta&t=0_6eeiDRfuUYZLOF4w-EMKKBNHe-nn31Es8wGnxRi1g"
  },
  {
    "name": "Sophie Germain",
    "course": "Informatique",
    "profileImageUrl":
        "https://media.licdn.com/dms/image/v2/D4E03AQEBV8i__MYwCA/profile-displayphoto-shrink_400_400/profile-displayphoto-shrink_400_400/0/1692694815064?e=1737590400&v=beta&t=Ut-jWU-PZHUZ6x2jQaH7lnOkmBLv_PujHHE1ZCx4Qs4"
  },
  {
    "name": "Léonard Vinci",
    "course": "Arts",
    "profileImageUrl":
        "https://media.licdn.com/dms/image/v2/D4E03AQHaHU_CRH_Znw/profile-displayphoto-shrink_400_400/profile-displayphoto-shrink_400_400/0/1695626593300?e=1737590400&v=beta&t=AqBZZChkFnD7xVD8sfxQLulH2eyecSAY31mToRpX7v8"
  }
];

Widget _buildTeacherList(
  List<Map<String, String>> teachers,
  BuildContext context,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 0.0),
    child: Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: teachers.map((teacher) {
            return GestureDetector(
              onTap: () {
                // Naviguer vers la page du profil du professeur
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TeacherProfilePage(
                      teacher: teacher,
                      heroTag: '',
                    ),
                  ),
                );
              },
              child: Container(
                width: 80.0,
                height: 80.0,
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(teacher['profileImageUrl'] ?? ''),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    ),
  );
}
