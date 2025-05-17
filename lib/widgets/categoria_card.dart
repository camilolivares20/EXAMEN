import 'package:flutter/material.dart';
import 'package:examen/models/categorias.dart';

class CategoriaCard extends StatelessWidget {
  final Listado categoria;
  final Widget? trailing;

  const CategoriaCard({Key? key, required this.categoria, this.trailing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.only(top: 30, bottom: 50),
        width: double.infinity,
        height: 400,
        decoration: _cardDecorations(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            _BackGroundImage(url: categoria.categoriaImage),
            _CategoriaDetails(categoria: categoria),
            if (categoria.categoriaState == 'Inactivo')
              Positioned(top: 0, left: 0, child: _StateLabel(categoria: categoria)),
            if (trailing != null)
              Positioned(bottom: 10, right: 10, child: trailing!),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecorations() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(0, 5), blurRadius: 10),
        ],
      );
}

class _StateLabel extends StatelessWidget {
  final Listado categoria;

  const _StateLabel({Key? key, required this.categoria}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 70,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            categoria.categoriaState,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _CategoriaDetails extends StatelessWidget {
  final Listado categoria;

  const _CategoriaDetails({Key? key, required this.categoria}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 100,
        decoration: _boxDecorations(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              categoria.categoriaName,
              style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Estado: ${categoria.categoriaState}',
              style: const TextStyle(fontSize: 14, color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Precio: \$${categoria.categoriaPrice}',
              style: const TextStyle(fontSize: 14, color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _boxDecorations() => const BoxDecoration(
        color: Color.fromARGB(255, 26, 12, 107),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      );
}

class _BackGroundImage extends StatelessWidget {
  final String? url;

  const _BackGroundImage({Key? key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: SizedBox(
        width: double.infinity,
        height: 400,
        child: url == null
            ? const Image(
                image: AssetImage('assets/no-image.png'),
                fit: BoxFit.cover,
              )
            : FadeInImage(
                placeholder: const AssetImage('assets/jar-loading.gif'),
                image: NetworkImage(url!),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
