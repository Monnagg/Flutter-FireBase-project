import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/model/brew.dart';
import 'package:firebase/model/user.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference coffeShop =
      FirebaseFirestore.instance.collection('coffe');
  Future updateUserData(String sugars, String name, int strength) async {
    return await coffeShop.doc(uid).set({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  List<Brew> _brewListFromSanpshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Brew(
        name: (doc.data() as Map<String, dynamic>)['name'] ?? '',
        sugars: (doc.data() as Map<String, dynamic>)['sugars'] ?? '0',
        strength: (doc.data() as Map<String, dynamic>)['strength'] ?? 0,
      );
    }).toList();
  }

  Stream<List<Brew>> get coffeShopSnapshot {
    return coffeShop.snapshots().map(_brewListFromSanpshot);
  }

  UserData _userDataFromSanpshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid ?? '',
      name: (snapshot.data() as Map<String, dynamic>)['name'] ?? '',
      sugars: (snapshot.data() as Map<String, dynamic>)['sugars'] ?? '0',
      strength: (snapshot.data() as Map<String, dynamic>)['strength'] ?? 0,
    );
  }

  Stream<UserData> get userDate {
    return coffeShop.doc(uid).snapshots().map((_userDataFromSanpshot) );
  }
}
