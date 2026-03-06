import 'package:flutter_lowfit/core/models/login_request.dart';
import 'package:flutter_lowfit/core/models/login_response.dart';

abstract class AuthInterface {
  Future<LoginResponse> login(LoginRequest dto);
}