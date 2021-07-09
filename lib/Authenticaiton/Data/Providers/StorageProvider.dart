import 'dart:convert';

import 'package:phone_authentication/Authenticaiton/Models/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageProvider {

  
  Future<UserModel> getStorage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var user = pref.getString("user");
    var result = user == null
        ? null
        : UserModel.fromJson(UserModel.stringToMap(user.toString()));
    return result;
  }

  Future setStorage(UserModel customer) async {
    try {
      SharedPreferences storageData = await SharedPreferences.getInstance();
      await storageData.setString('user', json.encode(customer.toJson()));
    } catch (ex) {
      throw ('Error in SetCardStorage' + ex);
    }
  }
}
