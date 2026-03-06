import 'dart:convert';
import 'package:flutter_lowfit/core/interfaces/account_interface.dart';
import 'package:flutter_lowfit/core/models/cliente_response.dart';
import 'package:flutter_lowfit/core/models/reserva_response.dart';
import 'package:flutter_lowfit/core/models/update_cliente_request.dart';
import 'package:http/http.dart' as http;

class ClienteService implements ClienteInterface {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  @override
  Future<ClienteResponse> getProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/me/cliente'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}');
    }

    final Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;

    return ClienteResponse.fromJson(body['data'] as Map<String, dynamic>);
  }

  @override
  Future<ClienteResponse> updateProfile(
    int clienteId,
    UpdateClienteRequest request,
    String token,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/clientes/$clienteId'),
      headers: {
        ..._authHeaders(token),
        'Content-Type': 'application/json',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}');
    }

    final Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;

    return ClienteResponse.fromJson(body['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> logout(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: _authHeaders(token),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error ${response.statusCode}');
    }
  }

  @override
  Future<List<ReservaResponse>> getMyReservations(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/me/reservas'),
      headers: _authHeaders(token),
    );

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}');
    }

    final Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;

    final List<dynamic> data = body['data'] as List<dynamic>;
    return data.map((json) => ReservaResponse.fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> cancelReservation(int reservationId, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/me/reservas/$reservationId'),
      headers: _authHeaders(token),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error ${response.statusCode}');
    }
  }

  @override
  Future<void> cancelReservationBySessionId(int sessionId, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/sesiones/$sessionId/reservar'),
      headers: _authHeaders(token),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error ${response.statusCode}');
    }
  }

  Map<String, String> _authHeaders(String token) => {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

}
