class UpdateClienteRequest {
  final String? name;
  final String? surnames;
  final String? email;
  final String? telefono;
  final DateTime? fechaNacimiento;

  UpdateClienteRequest({
    this.name,
    this.surnames,
    this.email,
    this.telefono,
    this.fechaNacimiento,
  });

  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (surnames != null) 'surnames': surnames,
    if (email != null) 'email': email,
    if (telefono != null) 'telefono': telefono,
    if (fechaNacimiento != null)
      'fecha_nacimiento': fechaNacimiento!.toIso8601String(),
  };
}