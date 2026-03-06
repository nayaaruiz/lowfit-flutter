import 'dart:convert';
import 'package:flutter_lowfit/core/interfaces/class_interface.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_lowfit/core/models/class_response.dart';
import 'package:flutter_lowfit/core/models/reserva_response.dart';

class ClassService implements ClassInterface {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  @override
  Future<List<ClassResponse>> getClassesForDate(
    DateTime date,
    String token, {
    int? trainerId,
  }) async {
    final dateParam =
        '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    String url = '$baseUrl/classes?date=$dateParam';

    if (trainerId != null) {
      url += '&trainer_id=$trainerId';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: _authHeaders(token),
    );

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}');
    }

    final Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;

    final List<dynamic> items = body['data'] as List<dynamic>;

    return items
        .map((item) => ClassResponse.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<(DateTime minDate, DateTime maxDate)> getClassRange(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/classes/range'),
      headers: _authHeaders(token),
    );

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}');
    }

    final Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;

    final Map<String, dynamic> payload = body['data'] is Map<String, dynamic>
        ? body['data'] as Map<String, dynamic>
        : body;

    final DateTime minDate = DateTime.parse(payload['min_date']);
    final DateTime maxDate = DateTime.parse(payload['max_date']);

    return (minDate, maxDate);
  }

  @override
  Future<ClassResponse> getClassDetail(int id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/classes/$id'),
      headers: _authHeaders(token),
    );

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}');
    }

    final Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;

    return ClassResponse.fromJson(body['data']);
  }

  @override
  Future<ReservaResponse> reserveEvent(int sessionId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sesiones/$sessionId/reservar'),
      headers: _authHeaders(token),
    );

    if (response.statusCode != 201) {
      throw Exception('Error ${response.statusCode}');
    }

    final Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;

    return ReservaResponse.fromJson(body['data']);
  }

  @override
  Future<ClassResponse> bookClass(int classId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/classes/$classId/book'),
      headers: _authHeaders(token),
    );

    if (response.statusCode != 201) {
      throw Exception('Error ${response.statusCode}');
    }

    final Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;

    return ClassResponse.fromJson(body['data']);
  }

  @override
  Future<ClassResponse> cancelClass(int classId, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/classes/$classId/book'),
      headers: _authHeaders(token),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error ${response.statusCode}');
    }

    if (response.statusCode == 200) {
      final Map<String, dynamic> body =
          jsonDecode(response.body) as Map<String, dynamic>;
      return ClassResponse.fromJson(body['data']);
    }

    // 204 means no content – we can't parse the class, so reload later if needed
    throw Exception('Unexpected response cancelling class');
  }

  Map<String, String> _authHeaders(String token) => {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
}