class Familiares{
  final String? idFamiliar;
  final String? idUsuario;
  
  
  Familiares({
    this.idFamiliar,
    this.idUsuario,
  });

  factory Familiares.fromJson(Map<String, dynamic> json){
    return Familiares(
      idFamiliar: json['IdFamiliar']as String,
      idUsuario: json['IdUsuario']as String,
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'IdFamiliar': idFamiliar,
      'IdUsuario': idUsuario,
    };
  }
}