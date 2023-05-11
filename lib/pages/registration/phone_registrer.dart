// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guichetier_scanner/pages/registration/validation.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../controllers/local_storage.dart';

class PhoneNumberRegistration extends StatefulWidget {
  const PhoneNumberRegistration({super.key});

  @override
  State<PhoneNumberRegistration> createState() =>
      _PhoneNumberRegistrationState();
}

class _PhoneNumberRegistrationState extends State<PhoneNumberRegistration> {
  //
  final TextEditingController phoneController = TextEditingController();
  LocalStorage localStorage = LocalStorage();
  final _formKey = GlobalKey<FormState>();
  String initialCountry = 'TG';
  PhoneNumber numberCode = PhoneNumber(isoCode: 'TG');
  // ignore: prefer_typing_uninitialized_variables
  var phoneNumber;
  // bool _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> scanUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('scanner')
          .where('username', isEqualTo: _usernameController.value.text)
          .where('password', isEqualTo: _passwordController.value.text)
          .get()
          .then((querySnapshot) =>
              querySnapshot.docs.isEmpty ? null : querySnapshot.docs.first);

      setState(() {
        _isLoading = false;
      });

      if (userDoc != null) {
        // ignore: use_build_context_synchronously
        await localStorage.storeUserID(userDoc.id).then((value) async {
          await localStorage.saveBoolConnexion().then((value) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const ValidationPage(),
              ),
              (r) => false,
            );
          });
        });
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Le nom d\'utilisateur ou le mot de passe est incorrect.',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            e.toString(),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
      print(e);
      // Afficher une alerte pour indiquer que quelque chose s'est mal passé
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("AUTHENTIFICATION"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/design.png"),
                  fit: BoxFit.contain,
                ),
              ),
              padding: const EdgeInsets.only(
                left: 30,
                right: 30,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/login.png',
                    fit: BoxFit.cover,
                    height: 210,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 20,
                    ),
                    child: Text(
                      'Veillez entrer vos identifiants',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  customTextField(_usernameController, "Nom d'utilisateur"),
                  const SizedBox(
                    height: 30,
                  ),
                  customTextField(_passwordController, "Mots de passe"),
                  const SizedBox(
                    height: 60,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 3.5,
                        right: MediaQuery.of(context).size.width / 3.5,
                      ),
                    ),
                    onPressed: _usernameController.text.isEmpty ||
                            _passwordController.text.isEmpty
                        ? null
                        : _isLoading
                            ? null
                            : scanUser,
                    // () {
                    //     Navigator.pushAndRemoveUntil(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) =>
                    //             const ValidationPage(),
                    //       ),
                    //       (r) => false,
                    //     );
                    //   },
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                            semanticsLabel: "Patienté",
                            backgroundColor: Color.fromARGB(255, 199, 198, 198),
                            color: Colors.black,
                            strokeWidth: 3,
                          )
                        : const Text("S'authentifier"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextField customTextField(
      TextEditingController controller, String labelText) {
    return TextField(
      controller: controller,
      onChanged: (value) {
        // setState(() {
        //   btnStatus = true;
        // });
      },
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
        color: Colors.black.withOpacity(0.9),
      ),
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        floatingLabelStyle: GoogleFonts.lato(
          fontWeight: FontWeight.bold,
          color: const Color(0xFFDD3705),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFDD3705), width: 2),
        ),
        contentPadding: const EdgeInsets.only(bottom: 3, left: 18),
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: '',
        hintStyle: GoogleFonts.roboto(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
    );
  }
}


// StreamBuilder(
//                   stream: FirebaseFirestore.instance
//                       .collection('scanner')
//                       .snapshots(),
//                   builder: (BuildContext context, AsyncSnapshot snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Text("");
//                     }
//                     if (snapshot.data!.docs.length == 0) {
//                       return const Text(
//                         "pas de données",
//                         style: TextStyle(color: Colors.black),
//                       );
//                     }
//                     return ListView.builder(
//                         padding: const EdgeInsets.only(
//                           top: 0,
//                           bottom: 10,
//                         ),
//                         scrollDirection: Axis.vertical,
//                         physics: const NeverScrollableScrollPhysics(),
//                         shrinkWrap: true,
//                         itemCount: snapshot.data!.docs.length,
//                         itemBuilder: (context, int index) {
//                           QueryDocumentSnapshot<Object?>? documentSnapshot =
//                               snapshot.data!.docs[index];
//                           return Dismissible(
//                             key: Key(documentSnapshot!.id),
//                             onDismissed: (DismissDirection direction) {
//                               FirebaseFirestore.instance
//                                   .collection('scanner')
//                                   .doc(documentSnapshot.id)
//                                   .delete();
//                             },
//                             background: Container(
//                               color: Colors.red,
//                               child: const Align(
//                                   // alignment: Alignment.centerRight,
//                                   child: Icon(Icons.delete)),
//                             ),
//                             child: Card(
//                               child: Text(
//                                 documentSnapshot["username"],
//                                 style: const TextStyle(color: Colors.black),
//                               ),
//                             ),
//                           );
//                         });
//                   }),