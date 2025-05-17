import 'package:flutter/material.dart';
import 'package:examen/providers/cart_provider.dart';
import 'package:examen/screen/loading_screen.dart';
import 'package:provider/provider.dart';
import 'package:examen/models/productos.dart';
import 'package:examen/widgets/product_card.dart';
import 'package:examen/services/product_service.dart';

class ListProductScreen extends StatelessWidget {
  const ListProductScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    if (productService.isLoading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de productos'),
        actions: [
          // Icono de carrito con contador
          Consumer<CartProvider>(
            builder: (_, cart, __) => Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    // acción al presionar el carrito (puedes navegar a otro screen)
                  },
                ),
                if (cart.itemCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${cart.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: productService.products.length,
        itemBuilder: (BuildContext context, index) {
          final product = productService.products[index];
          return GestureDetector(
            onTap: () {
              productService.SelectProduct = product.copy();
              Navigator.pushNamed(context, 'edit_product');
            },
            child: ProductCard(
              product: product,
              // Aquí agregamos el botón para agregar al carrito
              trailing: IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                onPressed: () {
                  // Incrementar contador en tiempo de ejecución
                  Provider.of<CartProvider>(context, listen: false).addItem();
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          productService.SelectProduct = Listado(
              productId: 0,
              productName: '',
              productPrice: 0,
              productImage:
                  'https://abravidro.org.br/wp-content/uploads/2015/04/sem-imagem4.jpg',
              productState: '');
          Navigator.pushNamed(context, 'edit_product');
        },
      ),
    );
  }
}