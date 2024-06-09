import 'package:alzheimer_app1/utils/token_utils.dart';
import 'package:flutter/material.dart';

mixin PermissionMixin<T extends StatefulWidget> on State<T> {
  final TokenUtils tokenUtils = TokenUtils();

  List<String> _permissions = [];

  @override
  void initState() {
    super.initState();
    _initializePermissions();
  }

  void _initializePermissions() async {
    try {
      List<String> permissions = await tokenUtils.getPermisosUsuarioToken();
      setState(() {
        _permissions = permissions;
      });
    } catch (error) {
      // Manejar el error, por ejemplo, mostrar un mensaje
      print('Error al obtener permisos: $error');
    }
  }

  bool hasPermission(String permission) {
    return _permissions.contains(permission);
  }
}