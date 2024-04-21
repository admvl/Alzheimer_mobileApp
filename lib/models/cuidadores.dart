class Cuidadores{
  final String? idCuidador;
  final String? idUsuario;
  final String? idFamiliar;
  
  
  Cuidadores({
    this.idUsuario,
    this.idFamiliar,
    this.idCuidador,
  });

  factory Cuidadores.fromJson(Map<String, dynamic> json){
    return Cuidadores(
      idUsuario: json['IdUsuario']as String,
      idFamiliar: json['IdFamiliar']as String,
      idCuidador: json['IdCuidador']as String,
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'IdUsuario': idUsuario,
      'IdFamiliar': idFamiliar,
      'IdCuidador': idCuidador,
    };
  }
}