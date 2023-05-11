import 'package:flutter/material.dart';
import 'package:guichetier_scanner/home/home_page.dart';
import 'package:guichetier_scanner/pages/onborading_page/onboarding.dart';
import 'package:guichetier_scanner/pages/registration/phone_registrer.dart';
import 'package:guichetier_scanner/providers/nav_bar_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';

int? isViewed;
bool? boolConnexion;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isViewed = prefs.getInt('GetStartPage');
  boolConnexion = prefs.getBool('loggedIn');
  timeago.setLocaleMessages('fr', timeago.FrMessages());
  timeago.setLocaleMessages('fr_short', timeago.FrShortMessages());
  initializeDateFormatting('fr_FR', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFDD3705), // <-- SEE HERE
        statusBarIconBrightness:
            Brightness.light, //<-- For Android SEE HERE (dark icons)
        statusBarBrightness:
            Brightness.light, //<-- For iOS SEE HERE (dark icons)
        systemNavigationBarColor: Color(0xFFDD3705),
        systemNavigationBarIconBrightness: Brightness.light,
        // systemNavigationBarDividerColor: Color(0xFF03BE0C),
      ),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NavBarProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Guichetier',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 2,
            foregroundColor: Color(0xFFE0E0E0),
            color: Color(0xFFDD3705),
          ),
          scaffoldBackgroundColor: const Color(0xFFE9E9E9),
          bottomAppBarColor: const Color(0xFFDD3705),
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
          useMaterial3: true,
          primarySwatch: Colors.deepOrange,
        ),
        home: isViewed != 0
            ? const Onbording()
            : boolConnexion != true
                ? const PhoneNumberRegistration()
                : const HomePage(),
        // const UplodSociete(),
      ),
    );
  }
}
