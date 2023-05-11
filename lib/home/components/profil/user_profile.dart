import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProfil extends StatefulWidget {
  const UserProfil({
    Key? key,
    required this.storeUserID,
    required this.uidSociete,
  }) : super(key: key);
  final String storeUserID;
  final String uidSociete;

  @override
  State<UserProfil> createState() => _UserProfilState();
}

class _UserProfilState extends State<UserProfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text("Informations personnelles"),
                  SizedBox(
                    height: 20,
                  ),
                  Icon(
                    CupertinoIcons.profile_circled,
                    size: 100,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('scanner')
                  .doc(widget.storeUserID)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(""),
                    ),
                  );
                }
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text("Nom d'utilisateur : "),
                            Text(
                              snapshot.data.data()["username"],
                              style: const TextStyle(
                                color: Color(0xFFDD3705),
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            const Text("Dernière connection : "),
                            Text(
                              snapshot.data.data()["lastConnect"],
                              style: const TextStyle(
                                color: Color(0xFFDD3705),
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('societe')
                              .doc(widget.uidSociete)
                              .snapshots(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot2) {
                            if (snapshot2.connectionState ==
                                ConnectionState.waiting) {
                              return const Text("Société : ");
                            }
                            return Row(
                              children: [
                                const Text("Société : "),
                                Text(
                                  snapshot2.data.data()["raison_sociale"],
                                  style: const TextStyle(
                                    color: Color(0xFFDD3705),
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      )),
    );
  }
}
