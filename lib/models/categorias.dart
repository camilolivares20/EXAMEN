import 'dart:convert';

class Categoria {
  Categoria({
    required this.listado,
  });

  List<Listado> listado;

  factory Categoria.fromJson(String str) => Categoria.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Categoria.fromMap(Map<String, dynamic> json) => Categoria(
        listado: List<Listado>.from(
          json["Listado Categorias"].map((x) => Listado.fromMap(x)),
        ),
      );

  Map<String, dynamic> toMap() => {
        "Listado Categorias": List<dynamic>.from(listado.map((x) => x.toMap())),
      };
}

class Listado {
  Listado({
    required this.categoriaId,
    required this.categoriaName,
    this.categoriaImage = "https://abravidro.org.br/wp-content/uploads/2015/04/sem-imagem4.jpg",
    this.categoriaPrice = 0,
    required this.categoriaState,
  });

  int categoriaId;
  String categoriaName;
  int categoriaPrice;
  String categoriaImage;
  String categoriaState;

  factory Listado.fromJson(String str) => Listado.fromMap(json.decode(str));

  factory Listado.fromMap(Map<String, dynamic> json) => Listado(
        categoriaId: json["category_id"],
        categoriaName: json["category_name"],
        categoriaState: json["category_state"],
      );

  Map<String, dynamic> toMap() => {
        "category_id": categoriaId,
        "category_name": categoriaName,
        "category_price": categoriaPrice,
        "category_image": categoriaImage,
        "category_state": categoriaState,
      };

  Map<String, dynamic> toJson() => toMap();

  Listado copy() => Listado(
        categoriaId: categoriaId,
        categoriaName: categoriaName,
        categoriaPrice: categoriaPrice,
        categoriaImage: categoriaImage,
        categoriaState: categoriaState,
      );
}
