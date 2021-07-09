import 'package:phone_authentication/Authenticaiton/Bloc/AuthenticationBloc.dart';
import 'package:phone_authentication/Views/LoginMainView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeMainView extends StatefulWidget {
  @override
  _HomeMainViewState createState() => _HomeMainViewState();
}

class _HomeMainViewState extends State<HomeMainView> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: [
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
              ),
              onPressed: () => BlocProvider.of<AuthenticationBloc>(context).add(
                AuthenticationExited(),
              ),
            ),
          ],
        ),
        body: Center(
          child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              if (state is AuthenticationFailiure) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => LoginMainView()));
              }
            },
            builder: (context, state) {
              if (state is AuthenticationInitial) {
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(AuthenticationStarted());
                return CircularProgressIndicator();
              } else if (state is AuthenticationLoading) {
                return CircularProgressIndicator();
              } else if (state is AuthenticationSuccess) {
                return Padding(
                  padding: const EdgeInsets.only(top: 200.0),
                  child: Column(
                    children: [
                      Text('Welcome!'),
                      Text('ID from State: ${state.model.uid}'),
                    ],
                  ),
                );
              }
              return Text('Undefined state : ${state.runtimeType}');
            },
          ),
        ),
      ),
    );
  }
}
