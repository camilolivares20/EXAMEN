import 'package:flutter/material.dart';
import 'package:examen/providers/proveedor_form_provider.dart';
import 'package:examen/services/proveedor_service.dart';
import 'package:examen/widgets/proveedor_image.dart';
import 'package:provider/provider.dart';
import '../ui/input_decorations.dart';

class EditProveedorScreen extends StatelessWidget {
  const EditProveedorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final proveedorService = Provider.of<ProveedoresService>(context);

    return ChangeNotifierProvider(
      create: (_) => ProveedorFormProvider(proveedorService.SelectProveedores!),
      child: _ProveedorScreenBody(proveedorService: proveedorService),
    );
  }
}

class _ProveedorScreenBody extends StatelessWidget {
  const _ProveedorScreenBody({
    Key? key,
    required this.proveedorService,
  }) : super(key: key);

  final ProveedoresService proveedorService;

  @override
  Widget build(BuildContext context) {
    final proveedorForm = Provider.of<ProveedorFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ProveedorImage(
                  url: "https://abravidro.org.br/wp-content/uploads/2015/04/sem-imagem4.jpg",
                ),
                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            _ProveedorForm(),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'btn_delete',
            child: const Icon(Icons.delete_forever),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('¿Eliminar proveedor?'),
                  content: const Text('Esta acción no se puede deshacer.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
                  ],
                ),
              );

              if (confirm ?? false) {
                await proveedorService.deleteProveedor(proveedorForm.proveedores, context);
              }
            },
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            heroTag: 'btn_save',
            child: const Icon(Icons.save_alt_outlined),
            onPressed: () async {
              if (!proveedorForm.isValidForm()) return;

              final proveedor = proveedorForm.proveedores;
              final esNuevo = proveedor.proveedoresId == 0;

              await proveedorService.editOrCreateProveedores(proveedor);
              Navigator.pop(context, esNuevo ? 'created' : 'updated');
            },
          ),
        ],
      ),
    );
  }
}

class _ProveedorForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final proveedorForm = Provider.of<ProveedorFormProvider>(context);
    final proveedor = proveedorForm.proveedores;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        decoration: _createDecoration(),
        child: Form(
          key: proveedorForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                initialValue: proveedor.proveedoresName,
                onChanged: (value) => proveedor.proveedoresName = value,
                validator: (value) => value == null || value.isEmpty ? 'El nombre es obligatorio' : null,
                decoration: InputDecortions.authInputDecoration(
                  hinText: 'Nombre del proveedor',
                  labelText: 'Nombre',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: proveedor.proveedoresLastName,
                onChanged: (value) => proveedor.proveedoresLastName = value,
                decoration: InputDecortions.authInputDecoration(
                  hinText: 'Apellido del proveedor',
                  labelText: 'Apellido',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: proveedor.proveedoresMail,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => proveedor.proveedoresMail = value,
                decoration: InputDecortions.authInputDecoration(
                  hinText: 'ejemplo@email.com',
                  labelText: 'Correo electrónico',
                ),
              ),
              const SizedBox(height: 20),
              SwitchListTile.adaptive(
                value: proveedor.proveedoresState == 'Activo',
                onChanged: (value) {
                  proveedor.proveedoresState = value ? 'Activo' : 'Inactivo';
                },
                activeColor: Colors.blue,
                title: const Text('Estado: Activo'),
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
