import 'package:phone_authentication/Authenticaiton/Data/Providers/AuthenticationFirebaseProvider.dart';
import 'package:phone_authentication/Authenticaiton/Models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthenticationRepository {
  final AuthenticationFirebaseProvider _authenticationFirebaseProvider;

  AuthenticationRepository(
      {@required AuthenticationFirebaseProvider authenticationFirebaseProvider})
      : assert(authenticationFirebaseProvider != null),
        _authenticationFirebaseProvider = authenticationFirebaseProvider;

  Stream<UserModel> getAuthDetailStream() {
    return _authenticationFirebaseProvider.getAuthStates().map((user) {
      return _getAuthCredentialFromFirebaseUser(user: user);
    });
  }

  Future<void> unAuthenticate() async {
    await _authenticationFirebaseProvider.logout();
  }

  Future<void> save(UserModel model) async {
    await _authenticationFirebaseProvider.saveToFirebase(model);
  }

  Future<UserModel> getByPhone(String phone) async {
    UserModel user =
        await _authenticationFirebaseProvider.getUserByPhone(phone);
    return user;
  }

  UserModel _getAuthCredentialFromFirebaseUser({@required User user}) {
    UserModel authDetail;
    if (user != null) {
      authDetail = UserModel(
        isValid: true,
        uid: user.uid,
        phoneNumber: user.phoneNumber,
        photoUrl: user.photoURL,
        name: user.displayName,
      );
    } else {
      authDetail = UserModel(isValid: false);
    }
    return authDetail;
  }
}
