class LoginResponse {
  final String token;
  final int? clienteId;

  LoginResponse({
    required this.token,
    this.clienteId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final dynamic clienteIdRaw = json['cliente_id'];
    final int? clienteId = switch (clienteIdRaw) {
      int value => value,
      String value => int.tryParse(value),
      _ => null,
    };

    return LoginResponse(
      token: (json['token'] ?? '').toString(),
      clienteId: clienteId,
    );
  }
}
