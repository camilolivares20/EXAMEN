import 'package:examen/providers/login_form_provider.dart';
import 'package:examen/services/auth_service.dart';
import 'package:examen/widgets/auth_background.dart';
import 'package:examen/widgets/card_container.dart';
import 'package:flutter/material.dart';
import 'package:examen/widgets/widgets.dart';

import 'package:provider/provider.dart';
import 'package:examen/providers/providers.dart';
import '../ui/input_decorations.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 160,
              ),
              CardContainer(
                  child: Column(children: [
                const SizedBox(height: 10),
                Text(
                  'Inicia Sesion',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 30),
                ChangeNotifierProvider(
                  create: (_) => LoginFormProvider(),
                  child: LoginForm(),
                ),
                const SizedBox(height: 50),
                TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, 'add_user'),
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 28, 12, 146).withOpacity(0.1)),
                      shape: MaterialStateProperty.all(StadiumBorder())),
                  child: const Text('No tienes una cuenta?, creala'),
                )
              ])),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginForm = Provider.of<LoginFormProvider>(context);
    return Container(
      child: Form(
        key: LoginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.text,
            decoration: InputDecortions.authInputDecoration(
              hinText: 'Ingrese su correo',
              labelText: 'Email',
              prefixIcon: Icons.people,
            ),
            onChanged: (value) => LoginForm.email = value,
            validator: (value) {
              return (value != null && value.length >= 4)
                  ? null
                  : 'El usuario no puede estar vacio';
            },
          ),
          const SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.text,
            decoration: InputDecortions.authInputDecoration(
              hinText: '************',
              labelText: 'Password',
              prefixIcon: Icons.lock_outline,
            ),
            onChanged: (value) => LoginForm.password = value,
            validator: (value) {
              return (value != null && value.length >= 4)
                  ? null
                  : 'La contraseña no puede estar vacio';
            },
          ),
          const SizedBox(height: 30),
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            disabledColor: Colors.grey,
            color: const Color.fromARGB(255, 6, 63, 142),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
              child: Text(
                'Ingresar',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            elevation: 0,
            onPressed: LoginForm.isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final authService =
                        Provider.of<AuthService>(context, listen: false);
                    if (!LoginForm.isValidForm()) return;
                    LoginForm.isLoading = true;
                    final String? errorMessage = await authService.login(
                        LoginForm.email, LoginForm.password);
                    if (errorMessage == null) {
                      Navigator.pushNamed(context, 'menu');
                    } else {
                      print(errorMessage);
                    }
                    LoginForm.isLoading = false;
                  },
          )
        ]),
      ),
    );
  }
}