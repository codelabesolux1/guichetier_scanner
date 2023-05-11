// ignore_for_file: avoid_print

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:timeago/timeago.dart' as timeago;

class TransportQrCodeScan extends StatefulWidget {
  final String eventUID;
  final String storeUserID;
  const TransportQrCodeScan({
    Key? key,
    required this.eventUID,
    required this.storeUserID,
  }) : super(key: key);

  @override
  State<TransportQrCodeScan> createState() => _TransportQrCodeScanState();
}

class _TransportQrCodeScanState extends State<TransportQrCodeScan> {
  Barcode? result;
  bool _flashOn = false;
  bool _frontCam = false;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    controller?.resumeCamera();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildQrView(context),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 60),
              child: const Text(
                "Scanner",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () async {
                    setState(() {
                      _flashOn = !_flashOn;
                    });
                    await controller?.toggleFlash();
                  },
                  icon: Icon(_flashOn ? Icons.flash_on : Icons.flash_off),
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: () async {
                    setState(() {
                      _frontCam = !_frontCam;
                    });
                    await controller?.flipCamera();
                  },
                  icon:
                      Icon(_frontCam ? Icons.camera_front : Icons.camera_rear),
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  color: Colors.white,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 230.0
        : 330.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: const Color(0xFFDD3705),
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (mounted) {
        this.controller?.dispose();
        Navigator.pop(context, scanData.code);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Scaffold(
              backgroundColor:
                  const Color.fromARGB(255, 5, 5, 5).withOpacity(0.7),
              body: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 3.5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: [
                        Container(
                          // height: MediaQuery.of(context).size.height / 4.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            gradient: LinearGradient(
                                colors: [
                                  const Color.fromARGB(255, 0, 44, 1)
                                      .withOpacity(0.9),
                                  const Color.fromARGB(255, 66, 66, 66),
                                ],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(1.2, 0.0),
                                stops: const [0.0, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                          child: FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('tickets')
                                .doc(scanData.code)
                                .get(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 4,
                                  child: Center(
                                    child: Text(
                                      "Qr non conforme",
                                      style: GoogleFonts.lato(
                                          letterSpacing: 0.5,
                                          color: Colors.red,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              }

                              if (snapshot.hasData && !snapshot.data!.exists) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 4,
                                  child: Center(
                                    child: Text(
                                      "Ticket invalide",
                                      style: GoogleFonts.lato(
                                          letterSpacing: 0.5,
                                          color: const Color.fromARGB(
                                              255, 151, 36, 0),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                Map<String, dynamic> data = snapshot.data!
                                    .data() as Map<String, dynamic>;
                                if (data['uidEvent'] == widget.eventUID &&
                                    data['payement'] == 'espiré') {
                                  return SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 4,
                                    child: Center(
                                      child: Text(
                                        "Ticket espiré",
                                        style: GoogleFonts.lato(
                                            letterSpacing: 0.5,
                                            color: const Color.fromARGB(
                                                255, 151, 36, 0),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                } else if (data['uidEvent'] ==
                                        widget.eventUID &&
                                    data['payement'] == 'true') {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0,
                                            bottom: 12.0,
                                            right: 8.0),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.5,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomRight: Radius.circular(5),
                                              bottomLeft: Radius.circular(5),
                                            ),
                                            color: const Color.fromARGB(
                                                    255, 233, 233, 233)
                                                .withOpacity(0.6),
                                            border: Border.all(
                                              color: const Color(0xFFDD3705)
                                                  .withOpacity(0.2),
                                              width: 0.5,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(timeago.format(
                                                data["date"].toDate(),
                                                locale: 'fr')),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0, bottom: 8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "${data["telephone"]}",
                                                  style: GoogleFonts.castoro(
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${data["montantTicket"]} ",
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 32,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          try {
                                            await FirebaseFirestore.instance
                                                .collection("tickets")
                                                .doc(scanData.code)
                                                .update({
                                              "payement": "espiré",
                                              "status": "true",
                                            });

                                            await FirebaseFirestore.instance
                                                .collection("scanner")
                                                .doc(widget.storeUserID)
                                                .collection("ticket_scanner")
                                                .add({
                                              "telephone": data["telephone"],
                                              "montant": data["montantTicket"],
                                              "date": Timestamp.now(),
                                            });
                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(context, 'OK');
                                            // ignore: empty_catches
                                          } catch (e) {}
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 1.5,
                                                color: const Color.fromARGB(
                                                    255, 0, 0, 0)),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Icon(Icons.close),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 4,
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text(
                                            "Ticket invalide",
                                            style: GoogleFonts.lato(
                                                letterSpacing: 0.5,
                                                color: const Color.fromARGB(
                                                    255, 102, 78, 1),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              // ignore: use_build_context_synchronously
                                              Navigator.pop(context, 'OK');
                                              // ignore: empty_catches
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    width: 1.5,
                                                    color: const Color.fromARGB(
                                                        255, 0, 0, 0)),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Icon(Icons.close),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              }
                              return SizedBox(
                                height: MediaQuery.of(context).size.height / 4,
                                child: const Center(
                                    child: CircularProgressIndicator()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );

        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return Scaffold(
        //       backgroundColor:
        //           const Color.fromARGB(255, 5, 5, 5).withOpacity(0.7),
        //       body: Column(
        //         children: [
        //           SizedBox(
        //             height: MediaQuery.of(context).size.height / 3.5,
        //           ),
        //           widget.eventUID == scanData.code
        //               ? const Center(
        //                   child: Icon(
        //                     CupertinoIcons.checkmark_circle_fill,
        //                     size: 200,
        //                     color: Color(0xFFDD3705),
        //                   ),
        //                 )
        //               : Center(
        //                   child: Column(
        //                     children: const [
        //                       Icon(
        //                         Icons.error,
        //                         size: 200,
        //                         color: Colors.red,
        //                       ),
        //                       Text("Ticket invalide")
        //                     ],
        //                   ),
        //                 ),
        //           const SizedBox(
        //             height: 12,
        //           ),
        //           GestureDetector(
        //             onTap: () {
        //               Navigator.pop(context, 'OK');
        //             },
        //             child: Container(
        //               decoration: BoxDecoration(
        //                 color: Colors.white,
        //                 shape: BoxShape.circle,
        //                 border: Border.all(
        //                     width: 1.5,
        //                     color: const Color.fromARGB(255, 0, 0, 0)),
        //               ),
        //               child: const Padding(
        //                 padding: EdgeInsets.all(10.0),
        //                 child: Icon(Icons.close),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        // );
      }
      setState(() {
        result = scanData;
      });

      if (result != null) {
        print(
            "Result"); // if you want to do any action with qr result then do code is here
        print(result!.code);
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
