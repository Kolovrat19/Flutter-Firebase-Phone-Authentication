part of 'AuthenticationBloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationStarted extends AuthenticationEvent {}

class AuthenticationStateChanged extends AuthenticationEvent {
  final UserModel model;
  AuthenticationStateChanged({
    @required this.model,
  });
  @override
  List<Object> get props => [model];
}

class AuthenticationExited extends AuthenticationEvent {}
