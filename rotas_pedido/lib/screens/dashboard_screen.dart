import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/data_service.dart';
import '../widgets/custom_drawer.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  List<Map<String, dynamic>> calcularRanking() {
    Map<String, int> contagem = {};

    for (var pedido in DataService.pedidos) {
      for (var item in pedido.itens) {
        String nome = item.produto.descricao;

        if (contagem.containsKey(nome)) {
          contagem[nome] = contagem[nome]! + item.quantidade;
        } else {
          contagem[nome] = item.quantidade;
        }
      }
    }

    List<Map<String, dynamic>> ranking = [];
    contagem.forEach((nome, qtd) {
      ranking.add({'nome': nome, 'quantidade': qtd});
    });

    ranking.sort((a, b) => b['quantidade'].compareTo(a['quantidade']));

    return ranking;
  }

  @override
  Widget build(BuildContext context) {
    var formatoMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    int qtdPedidos = DataService.pedidos.length;
    double faturado = DataService.getTotalFaturado();
    int itensVendidos = DataService.getTotalProdutosVendidos();
    int qtdClientes = DataService.clientes.length;

    var ranking = calcularRanking();

    int maiorVenda = 1;
    if (ranking.isNotEmpty) {
      maiorVenda = ranking[0]['quantidade'];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const CustomDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Movimentacoes da Sessao',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Os dados abaixo estao em memoria e serao perdidos ao fechar o app.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              cardIndicador('Pedidos', qtdPedidos.toString(),
                  Icons.shopping_cart, Colors.orange),
              cardIndicador('Faturamento', formatoMoeda.format(faturado),
                  Icons.attach_money, Colors.green),
              cardIndicador('Itens Vendidos', itensVendidos.toString(),
                  Icons.inventory_2, Colors.blue),
              cardIndicador('Clientes', qtdClientes.toString(),
                  Icons.people, Colors.purple),
            ],
          ),

          const SizedBox(height: 24),

          const Text(
            'Produtos Mais Vendidos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          if (ranking.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'Nenhuma venda registrada ainda.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: construirRanking(ranking, maiorVenda),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> construirRanking(
      List<Map<String, dynamic>> ranking, int maiorVenda) {
    List<Widget> lista = [];

    for (var item in ranking) {
      String nome = item['nome'];
      int qtd = item['quantidade'];

      double porcentagem = qtd / maiorVenda;

      lista.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(nome)),
                  Text(
                    qtd.toString() + ' un',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: porcentagem,
                minHeight: 8,
                backgroundColor: Colors.grey,
                color: Colors.indigo,
              ),
            ],
          ),
        ),
      );
    }

    return lista;
  }

  Widget cardIndicador(String titulo, String valor, IconData icone, Color cor) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                Icon(icone, color: cor),
              ],
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                valor,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: cor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
