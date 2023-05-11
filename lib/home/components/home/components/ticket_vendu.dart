import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NbrTicketVendu extends StatelessWidget {
  const NbrTicketVendu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width / 2.15,
      height: MediaQuery.of(context).size.height / 9,
      decoration: BoxDecoration(
        color: const Color(0xfff48a3c),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('tickets')
              .where('payement', isEqualTo: 'true')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            int sumTotal = 0;
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
                        Icons.shopping_cart_checkout_outlined,
                        color: Color.fromARGB(255, 228, 228, 228),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 47, 100, 49)
                              .withOpacity(0.5),
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
                        "Tickets vendu",
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
                sumTotal += int.parse(doc["montantTicket"]
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
                        Icons.shopping_cart_checkout_outlined,
                        color: Color.fromARGB(255, 228, 228, 228),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 141, 81, 2)
                              .withOpacity(0.5),
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
                        sumTotal == 1 ? "Ticket vendu" : "Tickets vendus",
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
