import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guichetier_scanner/home/scanner.dart';
import 'package:intl/intl.dart';

class AllEvent extends StatefulWidget {
  final String uidSociete;
  final String storeUserID;
  const AllEvent({
    Key? key,
    required this.uidSociete,
    required this.storeUserID,
  }) : super(key: key);

  @override
  State<AllEvent> createState() => _AllEventState();
}

class _AllEventState extends State<AllEvent> {
  String datetime = DateTime.now().toString();

  @override
  Widget build(BuildContext context) {
    // var today = DateFormat("dd/MM/yyyy", "fr").format(DateTime.now());
    String capitalize(String s) =>
        s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : s;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('societe')
            .doc(widget.uidSociete)
            .collection("events")
            .where('date',
                isEqualTo:
                    DateFormat("dd/MM/yyyy", "fr").format(DateTime.now()))
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Center(child: CircularProgressIndicator()),
              ],
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
                  Text("Pas d'évenement à scanner  aujourd'hui"),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(
              top: 0,
              bottom: 10,
            ),
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, int index) {
              QueryDocumentSnapshot<Object?>? documentSnapshot =
                  snapshot.data!.docs[index];
              DateTime date =
                  DateFormat('dd/MM/yyyy').parse(documentSnapshot!["date"]);
              return Padding(
                padding: const EdgeInsets.only(
                  top: 5,
                  bottom: 5,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TransportQrCodeScan(
                          eventUID: documentSnapshot.id,
                          storeUserID: widget.storeUserID,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xffDDDDDD),
                          blurRadius: 6.0,
                          spreadRadius: 2.0,
                          offset: Offset(0.0, 0.0),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: documentSnapshot["afficheUrl"],
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                // fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 10,
                                left: 10,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF575757),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0xffDDDDDD),
                                        blurRadius: 1.0,
                                        spreadRadius: 0.0,
                                        offset: Offset(0.0, 0.0),
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 6,
                                      bottom: 6,
                                      left: 6,
                                      right: 6,
                                    ),
                                    child: Icon(
                                      documentSnapshot["category"] == "Concert"
                                          ? CupertinoIcons.music_albums
                                          : documentSnapshot["category"] ==
                                                  "Foire"
                                              ? Icons.stadium_outlined
                                              : documentSnapshot["category"] ==
                                                      "Miss"
                                                  ? FontAwesomeIcons.crown
                                                  : documentSnapshot[
                                                              "category"] ==
                                                          "Cinema"
                                                      ? Icons.ondemand_video
                                                      : documentSnapshot[
                                                                  "category"] ==
                                                              "Sport"
                                                          ? CupertinoIcons
                                                              .sportscourt_fill
                                                          : CupertinoIcons
                                                              .number_square,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFFFFF),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0xffDDDDDD),
                                        blurRadius: 1.0,
                                        spreadRadius: 0.0,
                                        offset: Offset(0.0, 0.0),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0xffDDDDDD),
                                        blurRadius: 1.0,
                                        spreadRadius: 0.0,
                                        offset: Offset(0.0, 0.0),
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 1,
                                      bottom: 1,
                                      left: 6,
                                      right: 6,
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          DateFormat('dd', 'fr_FR').format(
                                            date,
                                          ),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          capitalize(
                                            DateFormat('MMM', 'fr_FR').format(
                                              date,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  documentSnapshot["title"],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_sharp,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    documentSnapshot["lieu"],
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFFDD3705),
                                ),
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.qr_code_scanner,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 18,
                                      ),
                                      Text(
                                        "Scanner ticket",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
