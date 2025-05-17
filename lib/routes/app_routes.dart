import 'package:examen/screen/edit_categoria_screen.dart';
import 'package:examen/screen/edit_product_screen.dart';
import 'package:examen/screen/edit_proveedor_screen.dart';
import 'package:examen/screen/error_screen.dart';
import 'package:examen/screen/list_categoria_screen.dart';
import 'package:examen/screen/list_product_screen.dart';
import 'package:examen/screen/list_proveedor_screen.dart';
import 'package:examen/screen/login_screen.dart';
import 'package:examen/screen/menu.dart';
import 'package:examen/screen/register_screen.dart';
import 'package:flutter/material.dart';


class AppRoutes {
  static const initialRoute = 'login';
  static Map<String, Widget Function(BuildContext)> routes = {
    'login': (BuildContext context) => const LoginScreen(),
    'menu': (BuildContext context) => const MenuScreen(),
    'list_categoria': (BuildContext context) => ListCategoriaScreen(),
    'list_proveedor': (BuildContext context) => ListProveedoresScreen(),
    'list_product': (BuildContext context) => const ListProductScreen(),
    'edit_product': (BuildContext context) => const EditProductScreen(),
    'edit_categoria': (BuildContext context) => const EditCategoriaScreen(),
    'edit_proveedor': (BuildContext context) => const EditProveedorScreen(),
    'add_user': (BuildContext context) => const RegisterUserScreen(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const ErrorScreen(),
    );
  }
}