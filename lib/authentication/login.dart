import 'package:flutter/material.dart';
import 'package:toca_pasto/authentication/register.dart';
import 'package:toca_pasto/client.dart';
import 'package:toca_pasto/home.dart';
import 'package:toca_pasto/ui/form_widgets.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Login")), body: body());
  }

  Widget body() {
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              createField("Usuario", "Ingrese su usuario", usernameController),
              createField("Contraseña", "Ingrese su contraseña",
                  passwordController, true),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        var client = DioClient();
                        var isCorrect = await client.checkPassword(
                            usernameController.text, passwordController.text);
                        if (!isCorrect && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Datos Incorrectos')),
                          );
                          return;
                        }
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Home()),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Por favor valida tu información')),
                        );
                      }
                    },
                    child: const Text('Login'),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Register(),
                        ),
                      );
                    },
                    child: const Text("Register"),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
