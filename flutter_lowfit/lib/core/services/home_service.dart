import 'dart:convert';
import 'package:flutter_lowfit/core/interfaces/home_interface.dart';
import 'package:flutter_lowfit/core/models/home_response.dart';
import 'package:http/http.dart' as http;

class HomeService implements HomeInterface {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  @override
  Future<HomeResponse> getHome(String token) async {

    final response = await http.get(
      Uri.parse('$baseUrl/home'),
      headers: _authHeaders(token),
    );
    
    if (!_isSuccess(response.statusCode)) {
      throw Exception('Error ${response.statusCode}');
    }

    final Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;
    return HomeResponse.fromJson(body);
  }

  bool _isSuccess(int statusCode) => statusCode >= 200 && statusCode < 300;

  Map<String, String> _authHeaders(String token) => {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
}
