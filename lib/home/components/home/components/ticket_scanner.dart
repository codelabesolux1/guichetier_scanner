import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class NbrTicketScanner extends StatefulWidget {
  const NbrTicketScanner({
    Key? key,
    required this.storeUserID,
  }) : super(key: key);
  final String storeUserID;

  @override
  State<NbrTicketScanner> createState() => _NbrTicketScannerState();
}

class _NbrTicketScannerState extends State<NbrTicketScanner> {
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
              .collection('scanner')
              .doc(widget.storeUserID)
              .collection("ticket_scanner")
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
                        "0 CFA",
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          color: const Color.fromARGB(255, 236, 236, 236),
                          fontWeight: FontWeight.w500,
                          // color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        CupertinoIcons.qrcode_viewfinder,
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
                        "Ticket Scanné",
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
              for (var doc in snapshot.data!.docs) {
                sumTotal += int.parse(doc["montant"]
                    .toString()); // make sure you create the variable sumTotal somewhere
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "$sumTotal CFA",
                        style: GoogleFonts.openSans(
                          fontSize: 20,
                          color: const Color.fromARGB(255, 236, 236, 236),
                          fontWeight: FontWeight.w500,
                          // color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        CupertinoIcons.qrcode_viewfinder,
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
                        sumTotal == 1 ? "Ticket Scanné" : "Tickets Scannés",
                        style: GoogleFonts.openSans(
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
