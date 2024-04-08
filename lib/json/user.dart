
class User{
  final String nombre;
  final String apPaterno;
  final String apMaterno;
  final String nickname;
  final String telefono;
  final String email;
  final String password;
  final String comprobanteFam;
  final String fechaNac;
  final String picture;

  const User(
    this.nombre,
    this.apPaterno,
    this.apMaterno,
    this.nickname,
    this.telefono,
    this.email,
    this.password,
    this.comprobanteFam,
    this.fechaNac,
    this.picture
  );
}


final List<User> people = 
  _people.map((e)=> User(
    e['nombre'] as String,
    e['apPaterno'] as String,
    e['apMaterno'] as String,
    e['nickname'] as String,
    e['telefono'] as String,
    e['email'] as String,
    e['password'] as String,
    e['comprobanteFam'] as String,
    e['fechaNac'] as String,
    e['picture'] as String,
  )
).toList(growable: false);


final List<Map<String, Object>> _people = [
  {
    "nombre": "Nombre",
    "apPaterno": "ApellidoPaterno",
    "apMaterno": "ApellidoMaterno",
    "nickname": "nickname",
    "telefono": "5555555555",
    "email": "usuario@email.com",
    "password": "abcdef",
    "comprobanteFam": "",
    "fechaNac": "01/02/2022",
    "picture": "https://images.unsplash.com/photo-1562788869-4ed32648eb72?q=80&w=2072&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  },
];