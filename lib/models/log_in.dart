class LogIn {
  final String correo;
  final String contrasenia;

  LogIn({
    required this.correo,
    required this.contrasenia,
  });
  // Método para crear una instancia de LogIn a partir de un JSON
  factory LogIn.fromJson(Map<String, dynamic> json) {
    return LogIn(
      correo: json['Correo'] as String,
      contrasenia: json['Contrasenia'] as String,
    );
  }

  // Método para convertir la instancia de LogIn a JSON
  Map<String, dynamic> toJson() {
    return {
      'Correo': correo,
      'Contrasenia': contrasenia,
    };
  }
}
