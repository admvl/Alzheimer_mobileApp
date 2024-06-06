import 'package:alzheimer_app1/services/usuarios_service.dart';
import 'package:jwt_decode/jwt_decode.dart';

class TokenUtils{
  final UsuariosService usuariosService = new UsuariosService();
  Future<String> getIdUsuarioToken() async{
    String? token = await storage.read(key: 'token');
    if(token!=null){
      Map<String,dynamic> decodedToken = Jwt.parseJwt(token);
      String? idUsuario = decodedToken['sub'];
      if(idUsuario!=null){
        return idUsuario;
      }else{
        throw Exception('El token no contiene un ID de usuario valido');
      }
    }else{
      throw Exception('Token expirado');
    }
  }
  Future<String> getRolUsuarioToken() async{
    String? token = await storage.read(key: 'token');
    if(token!=null){
      Map<String,dynamic> decodedToken = Jwt.parseJwt(token);
      String? role = decodedToken['role'];
      if(role!=null){
        return role;
      }else{
        throw Exception('El token no contiene un Rol de usuario valido');
      }
    }else{
      throw Exception('Token expirado');
    }
  }
}