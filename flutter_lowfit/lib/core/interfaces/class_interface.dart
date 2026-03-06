import 'package:flutter_lowfit/core/models/class_response.dart';
import 'package:flutter_lowfit/core/models/reserva_response.dart';

abstract class ClassInterface {
  Future<List<ClassResponse>> getClassesForDate(DateTime date, String token,
      {int? trainerId});
  Future<(DateTime minDate, DateTime maxDate)> getClassRange(String token);
  Future<ClassResponse> getClassDetail(int id, String token);

  /// low-level session reservation (used when working with a specific session id)
  Future<ReservaResponse> reserveEvent(int sessionId, String token);

  /// high-level class booking/cancellation that uses the fitness class endpoints
  Future<ClassResponse> bookClass(int classId, String token);
  Future<ClassResponse> cancelClass(int classId, String token);
}
