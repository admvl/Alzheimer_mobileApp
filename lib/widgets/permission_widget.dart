import 'package:alzheimer_app1/services/user_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class PermissionWidget extends StatelessWidget {
  final String permission;
  final Widget child;

  PermissionWidget({required this.permission, required this.child});

  @override
  Widget build(BuildContext context) {
    final userPermissions = Provider.of<UserProvider>(context).permissions;

    return userPermissions.contains(permission) ? child : SizedBox.shrink();
  }
}