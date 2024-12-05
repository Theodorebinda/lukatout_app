import 'package:flutter/material.dart';
import 'package:lukatout/constant/colors.dart';
import 'package:lukatout/helper/navigation_helper.dart';
import 'package:lukatout/screens/landing/landing_page.dart';
import 'package:lukatout/screens/profile/edite_profile/edite_profil.dart';
import 'package:lukatout/screens/profile/edite_profile/edite_profile_avatar.dart';
import 'package:lukatout/screens/profile/widget/profil_info_item.dart';
import 'package:lukatout/security/security_service.dart';
import 'package:lukatout/services/data_student_services.dart';
import 'package:lukatout/utils/app_show_bottom_sheet.dart';
import 'package:lukatout/widgets/custom_container.dart';
import 'package:lukatout/widgets/digi_progress_indicator.dart';
import 'package:lukatout/widgets/refrechable_page.dart';
import 'package:lukatout/widgets/skeletons/skeletons_conainer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _oldPinFocusNode = FocusNode();
  final _newPinFocusNode = FocusNode();
  final _oldPinTextEditingController = TextEditingController();
  final _newPinTextEditingController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeStudentData();
  }

  Future<void> _initializeStudentData() async {
    final studentId = await securityServiceSingleton.getTaxPayerId();
    debugPrint("StudentID : $studentId");

    if (studentId != null) {
      studentServiceSingleton.fetchStudent(
          "3833e3a5-5db9-4fe1-a2b0-f7f896ca45b5"); // Passer l'ID à la méthode
    }
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // const SizedBox(height: 10),
          if (_isLoading) // Vérifie si le chargement est actif
            const DigiProgressIndicator(),
          if (!_isLoading) ...[
            _buildProfileDetail(),
            const SizedBox(height: 10),
            _buildPersonnalInfoDetails(),
            _buildEditProfileButton(context),
            _buildLogoutButton(),
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
            return Text('Hey verifie ton code gars'); //Skeletton a (faire)
          } else if (snapshot.hasError || !snapshot.hasData) {
            debugPrint(snapshot.data.toString());
            return const Center(
              child: Text('Erreur de chargement'),
            ); // Gestion des erreurs
          } else {
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 360.0, // ou une hauteur fixe
                  child: Stack(
                    children: [
                      Positioned(
                        child: Container(
                          width: 500.0,
                          height: 180.0,
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
                            height: 230.0,
                            color: DigiPublicAColors.whiteColor,
                            // margin: EdgeInsets.only(top: 0),
                            child: Center(
                              child: Container(
                                // child: Container(
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
                                            'Informatique',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  DigiPublicAColors.greyColor,
                                            ),
                                          ),
                                          const Divider(height: 10.0),
                                          const Text('Information. Academique',
                                              style: TextStyle(
                                                fontSize: 14,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                // ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        });
  }
}

Widget _buildPersonnalInfoDetails() {
  return CustomContainer.buildContainer(
    child: Column(
      children: [
        ExpansionTile(
          leading: const Icon(
            Icons.person,
            size: 24.0,
            color: DigiPublicAColors.darkGreyColor,
          ),
          title: const Text(
            "Informations Personnel",
            style: TextStyle(
              fontSize: 16.0,
              color: DigiPublicAColors.darkGreyColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          children: [
            // const Divider(height: 10.0),
            const SizedBox(height: 15.0),
            StreamBuilder(
              stream: securityServiceSingleton.userInfo,
              builder: (context, snapshot) {
                // debugPrint(snapshot.data.toString());

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return buildInfoSectionSkeleton(context);
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return const SizedBox.shrink();
                } else {
                  final studentData = snapshot.data!;
                  // debugPrint(studentData.toString());
                  return Column(
                    children: [
                      ProfilInfoItem(
                        title: "Nom Complet",
                        info:
                            '${studentData.name} ${studentData.name} ${studentData.name}',
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 10.0),
                      ProfilInfoItem(
                        title: "Nationalite",
                        info: studentData.id,
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 10.0),
                      ProfilInfoItem(
                        title: "Anniversaire",
                        info: studentData.id,
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 10.0),
                      ProfilInfoItem(
                        title: "Etat civil",
                        info: studentData.id,
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 10.0),
                      ProfilInfoItem(
                        title: "Genre",
                        info: studentData.id,
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 10.0),
                      ProfilInfoItem(
                        title: "Adresse",
                        info: studentData.id,
                        icon: Icons.person,
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ],
    ),
  );
}

void _navigateToReferenceProfile(BuildContext context) {
  NavigationHelper.navigateWithTransition(
    context,
    const EditProfilePage(),
  );
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

Widget _buildEditProfileButton(BuildContext context) {
  return CustomContainer.buildContainer(
    child: Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: ListTile(
                  leading: Icon(
                    size: 24.0,
                    Icons.edit,
                    color: DigiPublicAColors.greenColor,
                  ),
                  title: Text(
                    "Edite Profile",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: DigiPublicAColors.greenColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.arrow_forward,
                  color: DigiPublicAColors.greyColor,
                ),
                onPressed: () => _navigateToEditProfile(context),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

void _navigateToEditProfile(BuildContext context) {
  NavigationHelper.navigateWithTransition(
    context,
    const EditProfilePage(),
  );
}

// Fonction pour naviguer vers une autre page
void _navigateToCorrespondences(BuildContext context) {
  NavigationHelper.navigateWithTransition(
    context,
    const LandingPage(),
  );
}

Widget _buildLogoutButton() {
  return CustomContainer.buildContainer(
    child: const Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListTile(
                  leading: Icon(
                    size: 24.0,
                    Icons.logout,
                    color: DigiPublicAColors.redColor,
                  ),
                  title: Text(
                    "Déconnexion",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: DigiPublicAColors.redColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_forward,
                  color: DigiPublicAColors.greyColor,
                ),
                onPressed: logoutRequest,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

// logout method
void logoutRequest() async {
  await securityServiceSingleton.logout();
}
// }
