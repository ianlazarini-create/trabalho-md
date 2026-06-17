import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/data_service.dart';
import '../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usuarioController = TextEditingController();
  final senhaController = TextEditingController();

  bool senhaEscondida = true;

  String mensagemErro = '';

  void fazerLogin() {
    String usuario = usuarioController.text.trim();
    String senha = senhaController.text;

    if (usuario.isEmpty) {
      setState(() {
        mensagemErro = 'Informe o usuario';
      });
      return;
    }

    if (usuario.length < 3) {
      setState(() {
        mensagemErro = 'Usuario deve ter no minimo 3 caracteres';
      });
      return;
    }

    if (senha.isEmpty) {
      setState(() {
        mensagemErro = 'Informe a senha';
      });
      return;
    }

    if (senha.length < 6) {
      setState(() {
        mensagemErro = 'Senha deve ter no minimo 6 caracteres';
      });
      return;
    }

    bool sucesso = AuthService.login(usuario, senha);

    if (sucesso) {
      DataService.carregarDadosIniciais();

      Navigator.pushReplacementNamed(context, AppRoutes.menu);
    } else {
      setState(() {
        mensagemErro = 'Usuario ou senha invalidos!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo, Colors.indigoAccent],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icone e titulo
                    const Icon(Icons.shopping_cart,
                        size: 70, color: Colors.indigo),
                    const SizedBox(height: 12),
                    const Text(
                      'Projeto Vendas',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Faca login para continuar',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 28),

                    // CAMPO DE USUARIO
                    TextField(
                      controller: usuarioController,
                      decoration: const InputDecoration(
                        labelText: 'Usuario',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: senhaController,
                      obscureText: senhaEscondida,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(senhaEscondida
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              senhaEscondida = !senhaEscondida;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (mensagemErro.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          mensagemErro,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: fazerLogin,
                        child: const Text(
                          'ENTRAR',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            'Credenciais de teste:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text('admin / 123456'),
                          Text('joao  / joao123'),
                          Text('maria / maria123'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
