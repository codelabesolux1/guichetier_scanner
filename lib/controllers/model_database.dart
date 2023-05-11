import 'package:cloud_firestore/cloud_firestore.dart';

class UserDatabaseService {
  CollectionReference users = FirebaseFirestore.instance.collection('scanner');

  Future getCurrentUserData(String storeUserID) async {
    try {
      DocumentSnapshot data = await users.doc(storeUserID).get();
      String uidSociete = "${data['uidSociete']}";
      return [
        uidSociete,
      ];
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }
}
