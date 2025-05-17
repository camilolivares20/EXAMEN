import 'package:flutter/material.dart';
import '../models/proveedores.dart';

class ProveedorFormProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Listado proveedores;

  ProveedorFormProvider(this.proveedores);

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
