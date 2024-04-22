class TiposNotificaciones{
  final String? idTipoNotificacion;
  final String tipoNotificacion;

  TiposNotificaciones({
    this.idTipoNotificacion,
    required this.tipoNotificacion,
  });

  factory TiposNotificaciones.fromJson(Map<String, dynamic> json){
    return TiposNotificaciones(
      idTipoNotificacion: json['IdTipoNotificacion'] as String,
      tipoNotificacion: json['TipoNotificacion'] as String,
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'IdTipoNotificacion': idTipoNotificacion ?? '',
      'TipoNotificacion': tipoNotificacion,
    };
  }
}