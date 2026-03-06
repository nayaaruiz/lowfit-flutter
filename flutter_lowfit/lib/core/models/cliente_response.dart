import 'package:flutter_lowfit/core/models/plan_response.dart';

class ClienteResponse {
  final int id;
  final int? userId;
  final int? planId;
  final String name;
  final String surnames;
  final String email;
  final String? telefono;
  final DateTime? fechaNacimiento;
  final PlanResponse? plan;

  ClienteResponse({
    required this.id,
    this.userId,
    this.planId,
    required this.name,
    required this.surnames,
    required this.email,
    this.telefono,
    this.fechaNacimiento,
    this.plan,
  });

  String get fullName => '$name $surnames';
  String get avatarInitial => name.isNotEmpty ? name[0].toUpperCase() : '?';

  factory ClienteResponse.fromJson(Map<String, dynamic> json) {
    final dynamic userIdRaw = json['user_id'];
    final int? userId = switch (userIdRaw) {
      int value => value,
      String value => int.tryParse(value),
      _ => null,
    };

    return ClienteResponse(
      id: json['id'] as int,
      userId: userId,
      planId: json['plan_id'] as int?,
      name: json['name'] as String,
      surnames: json['surnames'] as String,
      email: json['email'] as String,
      telefono: json['telefono'] as String?,
      fechaNacimiento: json['fecha_nacimiento'] != null
          ? DateTime.parse(json['fecha_nacimiento'] as String)
          : null,
      plan: json['plan'] != null
          ? PlanResponse.fromJson(json['plan'] as Map<String, dynamic>)
          : null,
    );
  }
}
