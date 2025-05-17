import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:examen/models/productos.dart';

class ProductService extends ChangeNotifier {
  final String _baseUrl = '143.198.118.203:8100';
  final String _user = 'test';
  final String _pass = 'test2023';

  List<Listado> products = [];
  Listado? SelectProduct;
  bool isLoading = true;
  bool isEditCreate = true;

  ProductService() {
    loadProducts();
  }

  Future loadProducts() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.http(
      _baseUrl,
      'ejemplos/product_list_rest/',
    );
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$_user:$_pass'));

    final response = await http.get(url, headers: {'authorization': basicAuth});

    final productsMap = Product.fromJson(response.body);
    print(response.body);

    products = productsMap.listado;

    isLoading = false;
    notifyListeners();
  }

  Future editOrCreateProduct(Listado product) async {
    isEditCreate = true;
    notifyListeners();

    if (product.productId == 0) {
      await createProduct(product);
    } else {
      await updateProduct(product);
    }

    isEditCreate = false;
    notifyListeners();
  }

  Future<String> updateProduct(Listado product) async {
    final url = Uri.http(
      _baseUrl,
      'ejemplos/product_edit_rest/',
    );
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$_user:$_pass'));

    final response = await http.post(
      url,
      body: json.encode(product.toJson()), 
      headers: {
        'authorization': basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print(response.body);

    final index = products.indexWhere((element) => element.productId == product.productId);
    if (index != -1) {
      products[index] = product;
    }

    return '';
  }

  Future createProduct(Listado product) async {
    final url = Uri.http(
      _baseUrl,
      'ejemplos/product_add_rest/',
    );
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$_user:$_pass'));

    final response = await http.post(
      url,
      body: json.encode(product.toJson()), 
      headers: {
        'authorization': basicAuth,
        'Content-type': 'application/json; charset=UTF-8',
      },
    );

    print(response.body);
    products.add(product);
    return '';
  }

  Future deleteProduct(Listado product, BuildContext context) async {
    final url = Uri.http(
      _baseUrl,
      'ejemplos/product_del_rest/',
    );
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$_user:$_pass'));

    final response = await http.post(
      url,
      body: json.encode(product.toJson()), 
      headers: {
        'authorization': basicAuth,
        'Content-type': 'application/json; charset=UTF-8',
      },
    );

    print(response.body);
    products.clear();
    await loadProducts();
    Navigator.of(context).pushNamed('list_product');

    return '';
  }
}
