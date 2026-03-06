import 'dart:convert';
import 'package:flutter_lowfit/core/interfaces/auth_interface.dart';
import 'package:flutter_lowfit/core/models/login_request.dart';
import 'package:flutter_lowfit/core/models/login_response.dart';
import 'package:http/http.dart' as http;

class AuthService implements AuthInterface {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: _jsonHeaders(),
      body: jsonEncode(request.toJson()),
    );

    if (_isSuccess(response.statusCode)) {
      final Map<String, dynamic> body =
          jsonDecode(response.body) as Map<String, dynamic>;
      final loginResponse = LoginResponse.fromJson(body);
      if (loginResponse.token.isEmpty) {
        throw Exception('Token no recibido');
      }
      return loginResponse;
    }

    final Map<String, dynamic> error =
        jsonDecode(response.body) as Map<String, dynamic>;
    throw Exception(error['message'] ?? 'Login error');
  }

  bool _isSuccess(int statusCode) => statusCode >= 200 && statusCode < 300;

  Map<String, String> _jsonHeaders() => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
}
