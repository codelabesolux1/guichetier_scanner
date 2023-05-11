import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Rapport extends StatefulWidget {
  const Rapport({
    Key? key,
    required this.storeUserID,
  }) : super(key: key);
  final String storeUserID;

  @override
  State<Rapport> createState() => _RapportState();
}

class _RapportState extends State<Rapport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('scanner')
              .doc(widget.storeUserID)
              .collection("ticket_scanner")
              .where('date',
                  isEqualTo:
                      DateFormat("dd/MM/yyyy", "fr").format(DateTime.now()))
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("");
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.error_outline_rounded,
                      color: Color.fromARGB(255, 112, 7, 0),
                    ),
                    Text("Erreur lors du chargement des données"),
                  ],
                ),
              );
            }
            if (snapshot.data?.size == 0) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.error_outline_rounded,
                      color: Color.fromARGB(255, 112, 7, 0),
                    ),
                    Text("Pas de ticket scanner aujourd'hui"),
                  ],
                ),
              );
            }
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Text("Ticket Scanner : "),
                          Text(
                            "${snapshot.data?.size}",
                            style: const TextStyle(
                              color: Color(0xFFDD3705),
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  const Text(
                    "Tickets scannés au cours de la journée",
                  ),
                  ListView.builder(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 10,
                    ),
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, int index) {
                      QueryDocumentSnapshot<Object?> documentSnapshot =
                          snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                        ),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "Propriétaire : ",
                                    ),
                                    Text(
                                      documentSnapshot["telephone"],
                                      style: const TextStyle(
                                        color: Color(0xFFDD3705),
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Prix : ",
                                    ),
                                    Text(
                                      documentSnapshot["montant"].toString(),
                                      style: const TextStyle(
                                        color: Color(0xFFDD3705),
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
