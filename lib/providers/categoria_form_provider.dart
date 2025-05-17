import 'package:flutter/material.dart';
import 'package:examen/models/categorias.dart';

class CategoriaFormProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Listado categoria;

  CategoriaFormProvider(this.categoria);

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
