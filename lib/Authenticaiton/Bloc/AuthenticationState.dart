part of 'AuthenticationBloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationFailiure extends AuthenticationState {
  final String message;
  AuthenticationFailiure({
    @required this.message,
  });
  @override
  List<Object> get props => [message];
}

class AuthenticationSuccess extends AuthenticationState {
  final UserModel model;
  AuthenticationSuccess({
    @required this.model,
  });
  @override
  List<Object> get props => [model];
}
