import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:examen/models/categorias.dart';

class CategoriaService extends ChangeNotifier {
  final String _baseUrl = '143.198.118.203:8100';
  final String _user = 'test';
  final String _pass = 'test2023';

  List<Listado> categorias = [];
  Listado? selectedCategoria;
  bool isLoading = true;
  bool isEditCreate = true;

  CategoriaService() {
    loadCategorias();
  }

  Future loadCategorias() async {
    isLoading = true;
    notifyListeners();

    try {
      final url = Uri.http(_baseUrl, 'ejemplos/category_list_rest/');
      String basicAuth = 'Basic ' + base64Encode(utf8.encode('$_user:$_pass'));

      final response = await http.get(
        url,
        headers: {'authorization': basicAuth},
      );

      print("CATEGORÍAS: ${response.body}");
      final categoriasMap = Categoria.fromJson(response.body);
      categorias = categoriasMap.listado;
    } catch (e) {
      print("Error al cargar categorías: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future editOrCreateCategoria(Listado nuevaCategoria) async {
    isEditCreate = true;
    notifyListeners();

    if (nuevaCategoria.categoriaId == 0) {
      await createCategoria(nuevaCategoria);
    } else {
      await updateCategoria(nuevaCategoria);
    }

    isEditCreate = false;
    notifyListeners();
  }

  Future<String> updateCategoria(Listado nuevaCategoria) async {
    try {
      final url = Uri.http(_baseUrl, 'ejemplos/category_edit_rest/');
      String basicAuth = 'Basic ' + base64Encode(utf8.encode('$_user:$_pass'));

      final response = await http.post(
        url,
        body: json.encode(nuevaCategoria.toJson()),
        headers: {
          'authorization': basicAuth,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print("ACTUALIZACIÓN: ${response.body}");

      await loadCategorias(); 
    } catch (e) {
      print("Error al actualizar categoría: $e");
    }

    return '';
  }

  Future createCategoria(Listado nuevaCategoria) async {
    try {
      final url = Uri.http(_baseUrl, 'ejemplos/category_add_rest/');
      String basicAuth = 'Basic ' + base64Encode(utf8.encode('$_user:$_pass'));

      final response = await http.post(
        url,
        body: json.encode(nuevaCategoria.toJson()),
        headers: {
          'authorization': basicAuth,
          'Content-type': 'application/json; charset=UTF-8',
        },
      );

      print("CREADA: ${response.body}");

      await loadCategorias(); 
    } catch (e) {
      print("Error al crear categoría: $e");
    }

    return '';
  }

  Future deleteCategoria(Listado categoria, BuildContext context) async {
    try {
      final url = Uri.http(_baseUrl, 'ejemplos/category_del_rest/');
      String basicAuth = 'Basic ' + base64Encode(utf8.encode('$_user:$_pass'));

      final response = await http.post(
        url,
        body: json.encode(categoria.toJson()),
        headers: {
          'authorization': basicAuth,
          'Content-type': 'application/json; charset=UTF-8',
        },
      );

      print("ELIMINADA: ${response.body}");

      await loadCategorias(); // ✅ Actualiza la lista al eliminar
      Navigator.of(context).pushNamed('list_categoria');

    } catch (e) {
      print("Error al eliminar categoría: $e");
    }

    return '';
  }
}
