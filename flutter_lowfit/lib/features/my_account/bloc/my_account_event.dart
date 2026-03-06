part of 'my_account_bloc.dart';

sealed class MyAccountEvent {}

final class FetchMyAccountEvent extends MyAccountEvent {
  FetchMyAccountEvent();
}

final class UpdateMyAccountEvent extends MyAccountEvent {
  final int clienteId;
  final String? name;
  final String? surnames;
  final String? email;
  final String? telefono;
  final DateTime? fechaNacimiento;

  UpdateMyAccountEvent({
    required this.clienteId,
    this.name,
    this.surnames,
    this.email,
    this.telefono,
    this.fechaNacimiento,
  });
}

final class FetchMyReservationsEvent extends MyAccountEvent {}

final class CancelReservationEvent extends MyAccountEvent {
  final int reservationId;
  CancelReservationEvent(this.reservationId);
}

final class ReserveClassEvent extends MyAccountEvent {
  final int classId;
  ReserveClassEvent(this.classId);
}

final class LogoutMyAccountEvent extends MyAccountEvent {}

