class PacientesFamiliares{
  final String? idPacienteFamiliar;
  final String? idPaciente;
  final String? idFamiliar;
  
  
  PacientesFamiliares({
    this.idPaciente,
    this.idFamiliar,
    this.idPacienteFamiliar,
  });

  factory PacientesFamiliares.fromJson(Map<String, dynamic> json){
    return PacientesFamiliares(
      idPaciente: json['IdPaciente']as String,
      idFamiliar: json['IdFamiliar']as String,
      idPacienteFamiliar: json['IdPacienteFamiliar']as String,
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'IdPaciente': idPaciente,
      'IdFamiliar': idFamiliar,
      'IdPacienteFamiliar': idPacienteFamiliar,
    };
  }
}