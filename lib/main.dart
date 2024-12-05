import 'package:face_camera/face_camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:lukatout/constant/colors.dart';
import 'package:lukatout/routes/apps_router.dart';
import 'package:provider/provider.dart';

void main() async {
  if (kDebugMode) {
    await dotenv.load(
      fileName: "dev.env",
    );
  } else {
    await dotenv.load(
      fileName: "prod.env",
    );
  }
//   WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
//   FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
//   runApp(const MyApp());
// }
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FaceCamera.initialize();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => FormRecapProvider()),
      ChangeNotifierProvider(create: (_) => PersonProvider()),
      ChangeNotifierProvider(create: (_) => EntitySelectionProvider()),
      ChangeNotifierProvider(create: (_) => DynamicFormProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Digi Public',
      initialRoute: DigiPublicRouter.getChoiseProfilScreen(),
      localizationsDelegates: const [
        // AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr'),
        Locale('en'),
      ],
      theme: ThemeData(
        primaryColor: DigiPublicAColors.primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.poppinsTextTheme(textTheme),
      ),
      getPages: DigiPublicRouter.routes,
    );
  }
}
