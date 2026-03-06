part of 'login_bloc.dart';

sealed class LoginEvent {}

final class FetchLogin extends LoginEvent {
  final LoginRequest request;

  FetchLogin({required this.request});
}
