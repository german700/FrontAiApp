import 'package:flutter/material.dart';
import 'package:toca_pasto/client.dart';
import 'package:toca_pasto/ui/form_widgets.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Register")), body: body());
  }

  Widget body() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            createField(
                "Usuario", "Debe ingresar un usuario", usernameController),
            createField("Contraseña", "Debe ingresar una contraseña",
                passwordController, true),
            createField("Nombre", "Debe ingresar un nombre", nameController),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  DioClient dio = DioClient();
                  int index = await dio.createUser(usernameController.text,
                      nameController.text, passwordController.text);
                  if (!context.mounted) return;
                  if (index == -1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Hubo un problema creando tu usuario')),
                    );
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Usuario creado')),
                  );

                  Navigator.pop(context);
                }
              },
              child: const Text('Registro'),
            ),
          ],
        ),
      ),
    );
  }
}
