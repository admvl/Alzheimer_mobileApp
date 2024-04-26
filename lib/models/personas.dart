class Personas {
  final String? idPersona;
  final String nombre;
  final String apellidoP;
  final String apellidoM;
  final DateTime fechaNacimiento;
  final String? numeroTelefono;

  Personas({
    this.idPersona,
    required this.nombre,
    required this.apellidoP,
    required this.apellidoM,
    required this.fechaNacimiento,
    this.numeroTelefono,
  });

  // Método para crear una instancia de Personas a partir de un JSON
  factory Personas.fromJson(Map<String, dynamic> json) {
    return Personas(
      idPersona: json['IdPersona'] as String,
      nombre: json['Nombre'] as String,
      apellidoP: json['ApellidoP'] as String,
      apellidoM: json['ApellidoM'] as String,
      fechaNacimiento: DateTime.parse(json['FechaNacimiento'] as String),
      numeroTelefono: json['NumeroTelefono'] as String?,
    );
  }

  // Método para convertir la instancia de Personas a JSON
  Map<String, dynamic> toJson() {
    return {
      if(idPersona!=null) 'IdPersona': idPersona,
      'Nombre': nombre,
      'ApellidoP': apellidoP,
      'ApellidoM': apellidoM,
      'FechaNacimiento': fechaNacimiento.toIso8601String(),
      'NumeroTelefono': numeroTelefono,
    };
  }
}
