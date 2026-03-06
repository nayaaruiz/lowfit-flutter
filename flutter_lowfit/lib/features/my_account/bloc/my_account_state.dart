part of 'my_account_bloc.dart';

sealed class MyAccountState {}

final class MyAccountInitial extends MyAccountState {}

final class MyAccountLoading extends MyAccountState {}

final class MyAccountSuccess extends MyAccountState {
  final ClienteResponse cliente;
  final List<ReservaResponse> reservations;
  final List<ClassResponse> availableClasses;

  MyAccountSuccess({
    required this.cliente,
    this.reservations = const [],
    this.availableClasses = const [],
  });
}

final class MyAccountUpdating extends MyAccountState {
  final ClienteResponse cliente;

  MyAccountUpdating({required this.cliente});
}

final class MyAccountError extends MyAccountState {
  final String message;

  MyAccountError({required this.message});
}

final class MyAccountLoggedOut extends MyAccountState {}

