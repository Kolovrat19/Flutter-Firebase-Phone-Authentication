import 'package:phone_authentication/Views/HomeMainView.dart';
import 'package:phone_authentication/AppBlocObserver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Authenticaiton/Bloc/AuthenticationBloc.dart';
import 'Authenticaiton/Data/Providers/AuthenticationFirebaseProvider.dart';
import 'Authenticaiton/Data/Repositories/AuthenticationRepository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = AppBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationBloc(
        authenticationRepository: AuthenticationRepository(
          authenticationFirebaseProvider: AuthenticationFirebaseProvider(
            firebaseAuth: FirebaseAuth.instance,
          ),
        ),
      ),
      child: MaterialApp(
        title: 'Phone Authentication',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeMainView(),
      ),
    );
  }
}
