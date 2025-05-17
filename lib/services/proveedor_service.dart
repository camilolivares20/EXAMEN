import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:examen/models/proveedores.dart';

class ProveedoresService extends ChangeNotifier {
  final String _baseUrl = '143.198.118.203:8100';
  final String _user = 'test';
  final String _pass = 'test2023';

  List<Listado> proveedor = [];
  Listado? SelectProveedores;
  bool isLoading = true;
  bool isEditCreate = true;

  ProveedoresService() {
    loadProveedores();
  }

  Future loadProveedores() async {
    isLoading = true;
    notifyListeners();

    try {
      final url = Uri.http(_baseUrl, 'ejemplos/provider_list_rest/');
      String basicAuth = 'Basic ' + base64Encode(utf8.encode('$_user:$_pass'));

      final response = await http.get(url, headers: {'authorization': basicAuth});
      print("PROVEEDORES: ${response.body}");

      final proveedoresMap = Proveedores.fromJson(response.body);
      proveedor = proveedoresMap.listado;
    } catch (e) {
      print("Error al cargar proveedores: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future editOrCreateProveedores(Listado nuevoProveedor) async {
    isEditCreate = true;
    notifyListeners();

    if (nuevoProveedor.proveedoresId == 0) {
      await createProveedores(nuevoProveedor);
    } else {
      await updateProveedores(nuevoProveedor);
    }

    isEditCreate = false;
    notifyListeners();
  }

  Future<String> updateProveedores(Listado nuevoProveedor) async {
    try {
      final url = Uri.http(_baseUrl, 'ejemplos/provider_edit_rest/');
      String basicAuth = 'Basic ' + base64Encode(utf8.encode('$_user:$_pass'));

      final response = await http.post(
        url,
        body: json.encode(nuevoProveedor.toJson()),
        headers: {
          'authorization': basicAuth,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print("PROVEEDOR ACTUALIZADO: ${response.body}");

      await loadProveedores(); 
    } catch (e) {
      print("Error al actualizar proveedor: $e");
    }

    return '';
  }

  Future createProveedores(Listado nuevoProveedor) async {
    try {
      final url = Uri.http(_baseUrl, 'ejemplos/provider_add_rest/');
      String basicAuth = 'Basic ' + base64Encode(utf8.encode('$_user:$_pass'));

      final response = await http.post(
        url,
        body: json.encode(nuevoProveedor.toJson()),
        headers: {
          'authorization': basicAuth,
          'Content-type': 'application/json; charset=UTF-8',
        },
      );

      print("PROVEEDOR CREADO: ${response.body}");

      await loadProveedores(); 
    } catch (e) {
      print("Error al crear proveedor: $e");
    }

    return '';
  }

  Future deleteProveedor(Listado proveedorAEliminar, BuildContext context) async {
    try {
      final url = Uri.http(_baseUrl, 'ejemplos/provider_del_rest/');
      String basicAuth = 'Basic ' + base64Encode(utf8.encode('$_user:$_pass'));

      final response = await http.post(
        url,
        body: json.encode(proveedorAEliminar.toJson()),
        headers: {
          'authorization': basicAuth,
          'Content-type': 'application/json; charset=UTF-8',
        },
      );

      print("PROVEEDOR ELIMINADO: ${response.body}");

      await loadProveedores();
      Navigator.of(context).pushNamed('list_proveedor');
    } catch (e) {
      print("Error al eliminar proveedor: $e");
    }

    return '';
  }
}
