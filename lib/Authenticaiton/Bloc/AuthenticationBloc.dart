import 'dart:async';

import 'package:phone_authentication/Authenticaiton/Data/Providers/StorageProvider.dart';
import 'package:phone_authentication/Authenticaiton/Data/Repositories/AuthenticationRepository.dart';
import 'package:phone_authentication/Authenticaiton/Models/UserModel.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'AuthenticationEvent.dart';
part 'AuthenticationState.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;

  AuthenticationBloc(
      {@required AuthenticationRepository authenticationRepository})
      : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(AuthenticationInitial());

  StreamSubscription<UserModel> authStreamSub;

  @override
  Future<void> close() {
    authStreamSub?.cancel();
    return super.close();
  }

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationStarted) {
      try {
        yield AuthenticationLoading();
        authStreamSub = _authenticationRepository
            .getAuthDetailStream()
            .listen((authDetail) {
          add(AuthenticationStateChanged(model: authDetail));
        });
      } catch (error) {
        print(
            'Error occured while fetching authentication detail : ${error.toString()}');
        yield AuthenticationFailiure(
            message: 'Error occrued while fetching auth detail');
      }
    } else if (event is AuthenticationStateChanged) {
      if (event.model.isValid) {
        yield AuthenticationSuccess(model: event.model);
        // ##################
        UserModel currentUser =
            await _authenticationRepository.getByPhone(event.model.phoneNumber);
        StorageProvider storage = StorageProvider();
        if (currentUser != null) {
          await storage.setStorage(currentUser);
        } else {
          final user = UserModel(
              isValid: true,
              uid: event.model.uid,
              photoUrl: event.model.photoUrl,
              phoneNumber: event.model.phoneNumber,
              name: event.model.name);

          await _authenticationRepository.save(user);
          await storage.setStorage(user);
        }
        // ##################
      } else {
        yield AuthenticationFailiure(message: 'User has logged out');
      }
    } else if (event is AuthenticationExited) {
      try {
        yield AuthenticationLoading();
        await _authenticationRepository.unAuthenticate();
      } catch (error) {
        print('Error occured while logging out. : ${error.toString()}');
        yield AuthenticationFailiure(
            message: 'Unable to logout. Please try again.');
      }
    }
  }
}
