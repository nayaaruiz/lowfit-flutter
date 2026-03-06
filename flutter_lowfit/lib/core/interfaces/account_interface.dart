import 'package:flutter_lowfit/core/models/cliente_response.dart';
import 'package:flutter_lowfit/core/models/reserva_response.dart';
import 'package:flutter_lowfit/core/models/update_cliente_request.dart';

abstract class ClienteInterface {
  Future<ClienteResponse> getProfile(String token);
  Future<ClienteResponse> updateProfile(
    int clienteId,
    UpdateClienteRequest request,
    String token,
  );
  Future<List<ReservaResponse>> getMyReservations(String token);
  Future<void> cancelReservation(int reservationId, String token);
  Future<void> cancelReservationBySessionId(int sessionId, String token);
  Future<void> logout(String token);
}
