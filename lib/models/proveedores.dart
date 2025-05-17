import 'dart:convert';

class Proveedores {
  Proveedores({
    required this.listado,
  });

  List<Listado> listado;

  factory Proveedores.fromJson(String str) => Proveedores.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Proveedores.fromMap(Map<String, dynamic> json) => Proveedores(
        listado: List<Listado>.from(json["Proveedores Listado"].map((x) => Listado.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "Proveedores Listado": List<dynamic>.from(listado.map((x) => x.toMap())),
      };
}

class Listado {
  Listado({
    required this.proveedoresId,
    required this.proveedoresName,
    required this.proveedoresLastName,
    required this.proveedoresMail,
    required this.proveedoresState,
  });

  int proveedoresId;
  String proveedoresName;
  String proveedoresLastName;
  String proveedoresMail;
  String proveedoresState;

  factory Listado.fromJson(String str) => Listado.fromMap(json.decode(str));

  Map<String, dynamic> toJson() => toMap();

  factory Listado.fromMap(Map<String, dynamic> json) => Listado(
        proveedoresId: json["providerid"],
        proveedoresName: json["provider_name"],
        proveedoresLastName: json["provider_last_name"],
        proveedoresMail: json["provider_mail"],
        proveedoresState: json["provider_state"],
      );

  Map<String, dynamic> toMap() => {
        "providerid": proveedoresId,
        "provider_name": proveedoresName,
        "provider_last_name": proveedoresLastName,
        "provider_mail": proveedoresMail,
        "provider_state": proveedoresState,
      };

  Listado copy() => Listado(
        proveedoresId: proveedoresId,
        proveedoresName: proveedoresName,
        proveedoresLastName: proveedoresLastName,
        proveedoresMail: proveedoresMail,
        proveedoresState: proveedoresState,
      );
}
