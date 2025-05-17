import 'package:flutter/material.dart';
import 'package:examen/providers/cart_provider.dart';
import 'package:examen/screen/loading_screen.dart';
import 'package:provider/provider.dart';
import 'package:examen/models/proveedores.dart';
import 'package:examen/widgets/proveedor_card.dart';
import 'package:examen/services/proveedor_service.dart';

class ListProveedoresScreen extends StatelessWidget {
  const ListProveedoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final proveedoresService = Provider.of<ProveedoresService>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    if (proveedoresService.isLoading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de proveedores'),
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
        itemCount: proveedoresService.proveedor.length,
        itemBuilder: (BuildContext context, index) {
          final proveedor = proveedoresService.proveedor[index];
          return GestureDetector(
            onTap: () async {
              proveedoresService.SelectProveedores = proveedor.copy();
              final result = await Navigator.pushNamed(context, 'edit_proveedor');
              if (result == 'created' || result == 'updated') {
                await proveedoresService.loadProveedores();
              }
            },
            child: ProveedorCard(
              proveedores: proveedor,
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
          proveedoresService.SelectProveedores = Listado(
            proveedoresId: 0,
            proveedoresName: '',
            proveedoresLastName: '',
            proveedoresMail: '',
            proveedoresState: '',
          );
          final result = await Navigator.pushNamed(context, 'edit_proveedor');
          if (result == 'created') {
            await proveedoresService.loadProveedores();
          }
        },
      ),
    );
  }
}
