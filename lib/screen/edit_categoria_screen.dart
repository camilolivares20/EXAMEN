import 'package:flutter/material.dart';
import 'package:examen/providers/categoria_form_provider.dart';
import 'package:examen/services/categoria_service.dart';
import 'package:examen/widgets/categoria_image.dart';
import 'package:provider/provider.dart';
import '../ui/input_decorations.dart';

class EditCategoriaScreen extends StatelessWidget {
  const EditCategoriaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoriaService = Provider.of<CategoriaService>(context);

    return ChangeNotifierProvider(
      create: (_) => CategoriaFormProvider(categoriaService.selectedCategoria!),
      child: _CategoriaScreenBody(categoriaService: categoriaService),
    );
  }
}

class _CategoriaScreenBody extends StatelessWidget {
  final CategoriaService categoriaService;

  const _CategoriaScreenBody({Key? key, required this.categoriaService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoriaForm = Provider.of<CategoriaFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                CategoriaImage(url: categoriaService.selectedCategoria!.categoriaImage),
                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios, size: 40, color: Colors.white),
                  ),
                ),
              ],
            ),
            _CategoriaForm(),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'btn_delete_categoria',
            child: const Icon(Icons.delete_forever),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('¿Eliminar categoría?'),
                  content: const Text('Esta acción no se puede deshacer.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
                  ],
                ),
              );

              if (confirm ?? false) {
                await categoriaService.deleteCategoria(categoriaForm.categoria, context);
              }
            },
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            heroTag: 'btn_guardar_categoria',
            child: const Icon(Icons.save_alt_outlined),
            onPressed: () async {
              if (!categoriaForm.isValidForm()) return;

              final categoria = categoriaForm.categoria;
              final esNuevo = categoria.categoriaId == 0;

              await categoriaService.editOrCreateCategoria(categoria);
              Navigator.pop(context, esNuevo ? 'created' : 'updated');
            },
          ),
        ],
      ),
    );
  }
}

class _CategoriaForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoriaForm = Provider.of<CategoriaFormProvider>(context);
    final categoria = categoriaForm.categoria;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        decoration: _createDecoration(),
        child: Form(
          key: categoriaForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                initialValue: categoria.categoriaName,
                onChanged: (value) => categoria.categoriaName = value,
                validator: (value) =>
                    value == null || value.isEmpty ? 'El nombre es obligatorio' : null,
                decoration: InputDecortions.authInputDecoration(
                  hinText: 'Nombre de la categoría',
                  labelText: 'Nombre',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                initialValue: categoria.categoriaPrice.toString(),
                onChanged: (value) => categoria.categoriaPrice = int.tryParse(value) ?? 0,
                decoration: InputDecortions.authInputDecoration(
                  hinText: 'Ej: 10000',
                  labelText: 'Precio',
                ),
              ),
              const SizedBox(height: 20),
              SwitchListTile.adaptive(
                value: categoria.categoriaState == 'Activa',
                onChanged: (value) {
                  categoria.categoriaState = value ? 'Activa' : 'Inactiva';
                },
                activeColor: Colors.blue,
                title: const Text('Estado: Activa'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _createDecoration() => const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black, offset: Offset(0, 5), blurRadius: 10),
        ],
      );
}
