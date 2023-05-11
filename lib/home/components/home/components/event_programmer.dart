import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventProgrammer extends StatefulWidget {
  const EventProgrammer({
    Key? key,
    required this.uidSociete,
  }) : super(key: key);
  final String uidSociete;

  @override
  State<EventProgrammer> createState() => _EventProgrammerState();
}

class _EventProgrammerState extends State<EventProgrammer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 9,
      decoration: BoxDecoration(
        color: const Color(0xff504adb),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('societe')
              .doc(widget.uidSociete)
              .collection("events")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            var sumTotal = 0;
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            } else if (snapshot.connectionState == ConnectionState.waiting ||
                (snapshot.hasData && snapshot.data!.size == 0)) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "",
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          color: const Color.fromARGB(255, 236, 236, 236),
                          fontWeight: FontWeight.w500,
                          // color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.event_note_outlined,
                        color: Color.fromARGB(255, 228, 228, 228),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 0, 41, 80)
                              .withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Text(
                            "0",
                            style: GoogleFonts.openSans(
                              color: const Color.fromARGB(255, 236, 236, 236),
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        "Evénement programmé",
                        style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 236, 236, 236),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "",
                        style: GoogleFonts.openSans(
                          fontSize: 12,
                          color: const Color.fromARGB(255, 236, 236, 236),
                          fontWeight: FontWeight.w500,
                          // color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.event_note_outlined,
                        color: Color.fromARGB(255, 228, 228, 228),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(173, 102, 95, 27)
                              .withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Text(
                            "${snapshot.data!.docs.length}",
                            style: GoogleFonts.poppins(
                              color: const Color.fromARGB(255, 236, 236, 236),
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        sumTotal == 1
                            ? "Evénement programmé"
                            : "Evénements programmés",
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          color: const Color.fromARGB(255, 236, 236, 236),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
