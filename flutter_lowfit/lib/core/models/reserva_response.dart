class ReservaResponse {
  final int? id;
  final int? clienteId;
  final int? sesionId;
  final String? fechaReserva;
  final String? estado;

  ReservaResponse({
    this.id,
    this.clienteId,
    this.sesionId,
    this.fechaReserva,
    this.estado,
  });

  factory ReservaResponse.fromJson(Map<String, dynamic> json) {
    return ReservaResponse(
      id: json['id'] as int?,
      clienteId: json['cliente_id'] as int?,
      sesionId: json['sesion_id'] as int?,
      fechaReserva: json['fecha_reserva'] as String?,
      estado: json['estado'] as String?,
    );
  }

}