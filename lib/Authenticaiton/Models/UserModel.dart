import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserModel {
  final bool isValid;
  String uid;
  final String photoUrl;
  final String phoneNumber;
  final String name;

  UserModel({
    @required this.isValid,
    this.uid,
    this.photoUrl,
    this.phoneNumber,
    this.name,
  });

  UserModel copyWith({
    bool isValid,
    String uid,
    String photoUrl,
    String phoneNumber,
    String name,
  }) {
    return UserModel(
      isValid: isValid ?? this.isValid,
      uid: uid ?? this.uid,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UserModel(
      isValid: map['isValid'],
      uid: map['uid'],
      photoUrl: map['photoUrl'],
      phoneNumber: map['phoneNumber'],
      name: map['name'],
    );
  }

  UserModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.uid = snapshot.id,
        this.isValid = snapshot["isValid"] as bool,
        this.phoneNumber = snapshot["phoneNumber"],
        this.name = snapshot["name"],
        this.photoUrl = snapshot["photoUrl"];

  toJson() {
    return {
      "uid": this.uid,
      "phoneNumber": this.phoneNumber,
      "name": this.name,
      "photoUrl": this.photoUrl,
      "isValid": this.isValid,
    };
  }

  UserModel.fromJson(Map<dynamic, dynamic> map)
      : isValid = map["isValid"] as bool,
        this.uid = map["uid"],
        this.phoneNumber = map["phoneNumber"],
        this.name = map["name"],
        this.photoUrl = map["photoUrl"];

  static Map<dynamic, dynamic> stringToMap(String s) {
    Map<dynamic, dynamic> map = jsonDecode(s) as Map<dynamic, dynamic>;
    return map;
  }

  @override
  String toString() {
    return 'UserModel(isValid: $isValid, uid: $uid, photoUrl: $photoUrl, phoneNumber: $phoneNumber, name: $name)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UserModel &&
        o.isValid == isValid &&
        o.uid == uid &&
        o.photoUrl == photoUrl &&
        o.phoneNumber == phoneNumber &&
        o.name == name;
  }

  @override
  int get hashCode {
    return isValid.hashCode ^
        uid.hashCode ^
        photoUrl.hashCode ^
        phoneNumber.hashCode ^
        name.hashCode;
  }
}
