import 'package:phone_authentication/Authenticaiton/Bloc/AuthenticationBloc.dart';
import 'package:phone_authentication/Authenticaiton/Bloc/PhoneAuthBloc.dart';

import 'package:phone_authentication/Authenticaiton/Data/providers/PhoneAuthFirebaseProvider.dart';
import 'package:phone_authentication/Authenticaiton/Data/repositories/PhoneAuthRepository.dart';
import 'package:phone_authentication/Views/HomeMainView.dart';
import 'package:phone_authentication/Views/LoginPhoneNumberView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginMainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Builder(
          builder: (context) {
            return BlocConsumer<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                if (state is AuthenticationSuccess) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomeMainView()));
                } else if (state is AuthenticationFailiure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                }
              },
              buildWhen: (current, next) {
                if (next is AuthenticationSuccess) {
                  return false;
                }
                return true;
              },
              builder: (context, state) {
                if (state is AuthenticationInitial ||
                    state is AuthenticationFailiure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                        create: (context) => PhoneAuthBloc(
                                          phoneAuthRepository:
                                              PhoneAuthRepository(
                                            phoneAuthFirebaseProvider:
                                                PhoneAuthFirebaseProvider(
                                                    firebaseAuth:
                                                        FirebaseAuth.instance),
                                          ),
                                        ),
                                        child: LoginPhoneNumberView(),
                                      )),
                            );
                          },
                          child: Text('Login with Phone Number'),
                        ),
                      ],
                    ),
                  );
                } else if (state is AuthenticationLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                return Center(
                    child: Text('Undefined state : ${state.runtimeType}'));
              },
            );
          },
        ),
      ),
    );
  }
}
