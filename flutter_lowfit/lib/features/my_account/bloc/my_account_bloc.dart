import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lowfit/core/models/class_response.dart';
import 'package:flutter_lowfit/core/models/cliente_response.dart';
import 'package:flutter_lowfit/core/models/reserva_response.dart';
import 'package:flutter_lowfit/core/models/update_cliente_request.dart';
import 'package:flutter_lowfit/core/services/class_service.dart';
import 'package:flutter_lowfit/core/services/cliente_service.dart';
import 'package:flutter_lowfit/core/services/storage_service.dart';

part 'my_account_event.dart';
part 'my_account_state.dart';

class MyAccountBloc extends Bloc<MyAccountEvent, MyAccountState> {
  final ClienteService clienteService;
  final ClassService classService;
  final StorageService storageService;

  MyAccountBloc(this.clienteService, this.classService, this.storageService)
      : super(MyAccountInitial()) {
    on<FetchMyAccountEvent>(_onFetchMyAccount);
    on<UpdateMyAccountEvent>(_onUpdateMyAccount);
    on<FetchMyReservationsEvent>(_onFetchMyReservations);
    on<CancelReservationEvent>(_onCancelReservation);
    on<ReserveClassEvent>(_onReserveClass);
    on<LogoutMyAccountEvent>(_onLogout);
  }

  Future<void> _onFetchMyAccount(
    FetchMyAccountEvent event,
    Emitter<MyAccountState> emit,
  ) async {
    emit(MyAccountLoading());

    try {
      final token = await storageService.getToken();
      if (token == null) {
        emit(MyAccountError(message: 'Token no encontrado'));
        return;
      }

      final cliente = await clienteService.getProfile(token);
      
      List<ReservaResponse> reservations = [];
      try {
        reservations = await clienteService.getMyReservations(token);
      } catch (e) {
        print('Error loading reservations: $e');
      }
      
      List<ClassResponse> availableClasses = [];
      try {
        availableClasses = await classService.getClassesForDate(DateTime.now(), token);
      } catch (e) {
        print('Error loading available classes: $e');
      }
      
      emit(MyAccountSuccess(
        cliente: cliente,
        reservations: reservations,
        availableClasses: availableClasses,
      ));
    } catch (e) {
      print('Error loading profile: $e');
      emit(MyAccountError(message: 'Error al cargar el perfil: $e'));
    }
  }

  Future<void> _onUpdateMyAccount(
    UpdateMyAccountEvent event,
    Emitter<MyAccountState> emit,
  ) async {
    final currentState = state;
    if (currentState is MyAccountSuccess) {
      emit(MyAccountUpdating(cliente: currentState.cliente));
    }

    try {
      final token = await storageService.getToken();
      if (token == null) {
        emit(MyAccountError(message: 'Token no encontrado'));
        return;
      }

      final request = UpdateClienteRequest(
        name: event.name,
        surnames: event.surnames,
        email: event.email,
        telefono: event.telefono,
        fechaNacimiento: event.fechaNacimiento,
      );

      final updated = await clienteService.updateProfile(
        event.clienteId,
        request,
        token,
      );

      emit(MyAccountSuccess(cliente: updated));
    } catch (_) {
      emit(MyAccountError(message: 'Error al actualizar el perfil'));
    }
  }

  Future<void> _onFetchMyReservations(
    FetchMyReservationsEvent event,
    Emitter<MyAccountState> emit,
  ) async {
    if (state is! MyAccountSuccess) return;

    final currentState = state as MyAccountSuccess;

    try {
      final token = await storageService.getToken();
      if (token == null) {
        emit(MyAccountError(message: 'Token no encontrado'));
        return;
      }

      final reservations = await clienteService.getMyReservations(token);
      final availableClasses = await classService.getClassesForDate(DateTime.now(), token);
      emit(MyAccountSuccess(
        cliente: currentState.cliente,
        reservations: reservations,
        availableClasses: availableClasses,
      ));
    } catch (_) {
      emit(MyAccountError(message: 'Error al cargar las reservas'));
    }
  }

  Future<void> _onCancelReservation(
    CancelReservationEvent event,
    Emitter<MyAccountState> emit,
  ) async {
    if (state is! MyAccountSuccess) return;

    final currentState = state as MyAccountSuccess;

    try {
      final token = await storageService.getToken();
      if (token == null) {
        emit(MyAccountError(message: 'Token no encontrado'));
        return;
      }

      await clienteService.cancelReservation(event.reservationId, token);

      final reservations = await clienteService.getMyReservations(token);
      final availableClasses = await classService.getClassesForDate(DateTime.now(), token);
      emit(MyAccountSuccess(
        cliente: currentState.cliente,
        reservations: reservations,
        availableClasses: availableClasses,
      ));
    } catch (_) {
      emit(MyAccountError(message: 'Error al cancelar la reserva'));
    }
  }

  Future<void> _onReserveClass(
    ReserveClassEvent event,
    Emitter<MyAccountState> emit,
  ) async {
    if (state is! MyAccountSuccess) return;

    final currentState = state as MyAccountSuccess;

    try {
      final token = await storageService.getToken();
      if (token == null) {
        emit(MyAccountError(message: 'Token no encontrado'));
        return;
      }

      await classService.reserveEvent(event.classId, token);

      final reservations = await clienteService.getMyReservations(token);
      final availableClasses = await classService.getClassesForDate(DateTime.now(), token);
      emit(MyAccountSuccess(
        cliente: currentState.cliente,
        reservations: reservations,
        availableClasses: availableClasses,
      ));
    } catch (_) {
      emit(MyAccountError(message: 'Error al reservar la clase'));
    }
  }

  Future<void> _onLogout(
    LogoutMyAccountEvent event,
    Emitter<MyAccountState> emit,
  ) async {
    try {
      final token = await storageService.getToken();
      if (token != null) {
        await clienteService.logout(token);
      }

      await storageService.deleteToken();
      await storageService.deleteClienteId();

      emit(MyAccountLoggedOut());
    } catch (_) {
      emit(MyAccountError(message: 'Error al cerrar sesión'));
    }
  }
}

