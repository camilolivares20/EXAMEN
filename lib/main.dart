import 'package:examen/providers/cart_provider.dart';
import 'package:examen/services/categoria_service.dart';
import 'package:examen/services/proveedor_service.dart';
import 'package:flutter/material.dart';
import 'package:examen/routes/app_routes.dart';
import 'package:examen/services/auth_service.dart';
import 'package:examen/services/product_service.dart';
import 'package:examen/theme/my_theme.dart';
import 'package:provider/provider.dart';

void main() => runApp(AppState());

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ProductService()),
        ChangeNotifierProvider(create: (_) => ProveedoresService()),
        ChangeNotifierProvider(create: (_) => CategoriaService()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      theme: MyTheme.myTheme,
    );
  }
}