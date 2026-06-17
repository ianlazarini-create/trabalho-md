import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../routes/app_routes.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  void irPara(BuildContext context, String rota) {
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, rota); 
  }

  // Funcao do botao SAIR
  void sair(BuildContext context) {
    AuthService.logout();

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    var usuario = AuthService.usuarioLogado;
    String nome = 'Visitante';
    String login = '';

    if (usuario != null) {
      nome = usuario.nome;
      login = '@' + usuario.usuario;
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.indigo),
            accountName: Text(
              nome,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(login),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                nome[0].toUpperCase(), 
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () => irPara(context, AppRoutes.menu),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Clientes'),
            onTap: () => irPara(context, AppRoutes.cliente),
          ),
          ListTile(
            leading: const Icon(Icons.inventory_2),
            title: const Text('Produtos'),
            onTap: () => irPara(context, AppRoutes.produto),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Pedidos'),
            onTap: () => irPara(context, AppRoutes.pedido),
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Dashboard'),
            onTap: () => irPara(context, AppRoutes.dashboard),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text(
              'Sair',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () => sair(context),
          ),
        ],
      ),
    );
  }
}
