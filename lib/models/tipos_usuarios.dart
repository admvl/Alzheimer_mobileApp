class TiposUsuarios {
  final String? idTipoUsuario;
  final String tipoUsuario;

  TiposUsuarios({this.idTipoUsuario, required this.tipoUsuario});
  // Método para crear una instancia de TiposUsuarios a partir de un JSON
  factory TiposUsuarios.fromJson(Map<String, dynamic> json) {
    return TiposUsuarios(
      idTipoUsuario: json['IdTipoUsuario'] as String,
      tipoUsuario: json['TipoUsuario'] as String,
    );
  }

  // Método para convertir la instancia de Personas a JSON
  Map<String, dynamic> toJson() {
    return {
      'IdTipoUsuario': idTipoUsuario ?? '',
      'TipoUsuario': tipoUsuario,
    };
  }
}
