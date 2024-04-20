class PacientesCuidadores{
  final String? idCuidaPaciente;
  final String? idPaciente;
  final String? idCuidador;
  final DateTime horaInicio;
  final DateTime horaFin;
  
  
  PacientesCuidadores({
    this.idCuidaPaciente,
    this.idPaciente,
    this.idCuidador,
    required this.horaInicio,
    required this.horaFin,
  });

  factory PacientesCuidadores.fromJson(Map<String, dynamic> json){
    return PacientesCuidadores(
      idCuidaPaciente: json['IdCuidaPaciente']as String,
      idPaciente: json['IdPaciente']as String,
      idCuidador: json['IdCuidador']as String,
      horaInicio: DateTime.parse(json['HoraInicio']as String),
      horaFin: DateTime.parse(json['HoraFin']as String),
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'IdCuidaPaciente': idCuidaPaciente,
      'IdPaciente': idPaciente,
      'IdCuidador': idCuidador,
      'HoraInicio': horaInicio,
      'HoraFin': horaFin,
    };
  }
}