import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guichetier_scanner/controllers/model_database.dart';
import 'package:guichetier_scanner/home/components/profil/user_profile.dart';
import 'package:guichetier_scanner/home/components/scan/all_events.dart';
import 'package:guichetier_scanner/home/components/home/home.dart';
import 'package:guichetier_scanner/home/components/rapport/rapport.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/nav_bar_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final referenceController = TextEditingController();
  UserDatabaseService userDatabaseService = UserDatabaseService();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  String storeUserID = "";
  String uidSociete = "";
  bool spine = true;

  Future<void> _initData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    storeUserID = prefs.getString('storeUserID')!;
    await _getUserData();
  }

  Future<void> _getUserData() async {
    dynamic userAuthData =
        await userDatabaseService.getCurrentUserData(storeUserID);
    setState(() {
      uidSociete = userAuthData[0];
      spine = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> menu = [
      spine == true
          ? const Center(child: CircularProgressIndicator())
          : Accueil(
              storeUserID: storeUserID,
              uidSociete: uidSociete,
            ),
      Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
          right: 8.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              spine == true
                  ? const Center(child: CircularProgressIndicator())
                  : AllEvent(
                      uidSociete: uidSociete,
                      storeUserID: storeUserID,
                    ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
      spine == true
          ? const Center(child: CircularProgressIndicator())
          : Rapport(storeUserID: storeUserID),
      spine == true
          ? const Center(child: CircularProgressIndicator())
          : UserProfil(storeUserID: storeUserID, uidSociete: uidSociete),
    ];

    final providerNavBar = Provider.of<NavBarProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guichetier Pro"),
        centerTitle: true,
      ),
      body: menu[providerNavBar.currentIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: BottomNavigationBar(
          // type: BottomNavigationBarType.fixed,
          currentIndex: providerNavBar.currentIndex,
          // backgroundColor: const Color(0xFFDD3705),
          selectedItemColor: const Color(0xFFDD3705),
          unselectedItemColor: Colors.black26,
          elevation: 4,
          onTap: (value) {
            providerNavBar.currentIndex = value;
          },
          items: const [
            BottomNavigationBarItem(
              // backgroundColor: Color(0xFFDD3705),
              label: "Accueil",
              icon: Icon(
                CupertinoIcons.home,
              ),
            ),
            BottomNavigationBarItem(
              // backgroundColor: Color(0xFFDD3705),
              label: "Scan",
              icon: Icon(CupertinoIcons.qrcode_viewfinder),
            ),
            BottomNavigationBarItem(
              // backgroundColor: Color(0xFFDD3705),
              label: "Rapport",
              icon: Icon(
                CupertinoIcons.tickets,
              ),
            ),
            BottomNavigationBarItem(
              // backgroundColor: Color(0xFFDD3705),
              label: "profil",
              icon: Icon(
                CupertinoIcons.person_fill,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
