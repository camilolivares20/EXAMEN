import 'package:flutter/material.dart';
import 'package:examen/providers/cart_provider.dart';
import 'package:examen/screen/loading_screen.dart';
import 'package:provider/provider.dart';
import 'package:examen/models/categorias.dart';
import 'package:examen/widgets/categoria_card.dart';
import 'package:examen/services/categoria_service.dart';

class ListCategoriaScreen extends StatelessWidget {
  const ListCategoriaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoriaService = Provider.of<CategoriaService>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    if (categoriaService.isLoading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de categorías'),
        actions: [
          Consumer<CartProvider>(
            builder: (_, cart, __) => Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {},
                ),
                if (cart.itemCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text('${cart.itemCount}', style: const TextStyle(color: Colors.white, fontSize: 10)),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: categoriaService.categorias.length,
        itemBuilder: (BuildContext context, index) {
          final categoria = categoriaService.categorias[index];
          return GestureDetector(
            onTap: () async {
              categoriaService.selectedCategoria = categoria.copy();
              final result = await Navigator.pushNamed(context, 'edit_categoria');
              if (result == 'created' || result == 'updated') {
                await categoriaService.loadCategorias();
              }
            },
            child: CategoriaCard(
              categoria: categoria,
              trailing: IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                onPressed: () => cartProvider.addItem(),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          categoriaService.selectedCategoria = Listado(
            categoriaId: 0,
            categoriaName: '',
            categoriaPrice: 0,
            categoriaImage: 'https://abravidro.org.br/wp-content/uploads/2015/04/sem-imagen4.jpg',
            categoriaState: '',
          );
          final result = await Navigator.pushNamed(context, 'edit_categoria');
          if (result == 'created') {
            await categoriaService.loadCategorias();
          }
        },
      ),
    );
  }
}
