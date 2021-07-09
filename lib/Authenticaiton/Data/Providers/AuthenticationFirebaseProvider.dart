import 'package:phone_authentication/Authenticaiton/Models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthenticationFirebaseProvider {
  final FirebaseAuth _firebaseAuth;
  CollectionReference _db;

  AuthenticationFirebaseProvider({
    @required FirebaseAuth firebaseAuth,
  })  : assert(firebaseAuth != null),
        _firebaseAuth = firebaseAuth,
        _db = FirebaseFirestore.instance.collection("Users");

  Stream<User> getAuthStates() {
    return _firebaseAuth.authStateChanges();
  }

  Future<User> login({
    @required AuthCredential credential,
  }) async {
    UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);
    return userCredential.user;
  }

  Future<UserModel> getUserByPhone(String phone) async {
    var query = await _db.where("phoneNumber", isEqualTo: phone).get();

    return query.docs.isEmpty ? null : UserModel.fromSnapshot(query.docs[0]);
  }

  Future<UserModel> saveToFirebase(UserModel model) async {
    if (model.uid == null) model.uid = _db.doc().id;
    await _db.doc(model.uid).set(model.toJson(), SetOptions(merge: true));
    return model;
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
