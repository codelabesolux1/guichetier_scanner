import 'package:flutter/material.dart';
import 'package:guichetier_scanner/home/components/home/components/event_programmer.dart';

import 'package:guichetier_scanner/home/components/home/components/ticket_scanner.dart';
import 'package:guichetier_scanner/home/components/home/components/ticket_vendu.dart';

class Accueil extends StatefulWidget {
  const Accueil({
    Key? key,
    required this.storeUserID,
    required this.uidSociete,
  }) : super(key: key);
  final String storeUserID;
  final String uidSociete;

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  @override
  Widget build(BuildContext context) {
    // Nombre total de ticket vendu//
    //Nombre de ticket scanné//
    //Nombre de ticket restant a scanné
    //Montant de ticket restant a scanné
    //Montant du ticket vendu//
    //Montant du ticket scanné//
    //Nombre d'évenent programmé
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const NbrTicketVendu(),
            const SizedBox(
              height: 30,
            ),

            NbrTicketScanner(storeUserID: widget.storeUserID),
            const SizedBox(
              height: 30,
            ),
            EventProgrammer(uidSociete: widget.uidSociete)
            // Text(""),
          ],
        ),
      )),
    );
  }
}
