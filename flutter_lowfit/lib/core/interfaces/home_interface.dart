import 'package:flutter_lowfit/core/models/home_response.dart';

abstract class HomeInterface {
  Future<HomeResponse> getHome(String token);
}
