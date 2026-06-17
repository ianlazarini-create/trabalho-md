import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/custom_drawer.dart';
import '../routes/app_routes.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String nome = 'Usuario';
    if (AuthService.usuarioLogado != null) {
      nome = AuthService.usuarioLogado!.nome;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Principal'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      drawer: const CustomDrawer(),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SAUDACAO
            const Text(
              'Bem-vindo,',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            Text(
              nome,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'O que voce quer fazer hoje?',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // 2 colunas
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  cardMenu(context, Icons.people, 'Clientes',
                      Colors.blue, AppRoutes.cliente),
                  cardMenu(context, Icons.inventory_2, 'Produtos',
                      Colors.green, AppRoutes.produto),
                  cardMenu(context, Icons.shopping_cart, 'Pedidos',
                      Colors.orange, AppRoutes.pedido),
                  cardMenu(context, Icons.bar_chart, 'Dashboard',
                      Colors.purple, AppRoutes.dashboard),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardMenu(BuildContext context, IconData icone, String titulo,
      Color cor, String rota) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, rota);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 60, color: cor),
            const SizedBox(height: 12),
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
