import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/cliente.dart';
import '../models/produto.dart';
import '../models/pedido.dart';
import '../services/data_service.dart';
import '../widgets/custom_drawer.dart';

class PedidoScreen extends StatefulWidget {
  const PedidoScreen({super.key});

  @override
  State<PedidoScreen> createState() => _PedidoScreenState();
}

class _PedidoScreenState extends State<PedidoScreen> {
  final formatoMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  final formatoData = DateFormat('dd/MM/yyyy HH:mm');

  void abrirNovoPedido() async {
    if (DataService.clientes.isEmpty || DataService.produtos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Cadastre clientes e produtos antes de criar um pedido.')),
      );
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NovoPedidoScreen(),
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var lista = DataService.pedidos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos de Venda'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const CustomDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: abrirNovoPedido,
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Novo', style: TextStyle(color: Colors.white)),
      ),
      body: lista.isEmpty
          ? const Center(child: Text('Nenhum pedido registrado.'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: lista.length,
              itemBuilder: (context, index) {
                var p = lista[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  // ExpansionTile = item que pode ser expandido para
                  // mostrar mais detalhes ao clicar.
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Text(
                        '#' + p.id.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(p.cliente.nome),
                    subtitle: Text(formatoData.format(p.data)),
                    trailing: Text(
                      formatoMoeda.format(p.getTotal()),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 16,
                      ),
                    ),
                    children: construirItens(p),
                  ),
                );
              },
            ),
    );
  }

  // Monta a lista de itens de um pedido
  List<Widget> construirItens(Pedido p) {
    List<Widget> lista = [];
    for (var item in p.itens) {
      lista.add(
        ListTile(
          dense: true,
          title: Text(item.produto.descricao),
          subtitle: Text(
            item.quantidade.toString() +
                ' x ' +
                formatoMoeda.format(item.produto.preco),
          ),
          trailing: Text(formatoMoeda.format(item.getSubtotal())),
        ),
      );
    }
    return lista;
  }
}

class NovoPedidoScreen extends StatefulWidget {
  const NovoPedidoScreen({super.key});

  @override
  State<NovoPedidoScreen> createState() => _NovoPedidoScreenState();
}

class _NovoPedidoScreenState extends State<NovoPedidoScreen> {
  final formatoMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  Cliente? clienteSelecionado;

  List<ItemPedido> itensDoPedido = [];

  double calcularTotal() {
    double total = 0;
    for (var item in itensDoPedido) {
      total = total + item.getSubtotal();
    }
    return total;
  }

  ItemPedido? procurarItem(Produto p) {
    for (var item in itensDoPedido) {
      if (item.produto.id == p.id) {
        return item;
      }
    }
    return null;
  }

  void aumentarQuantidade(Produto p) {
    var item = procurarItem(p);

    if (item == null) {
      if (p.estoque >= 1) {
        itensDoPedido.add(ItemPedido(p, 1));
      }
    } else {
      if (item.quantidade < p.estoque) {
        item.quantidade = item.quantidade + 1;
      }
    }
    setState(() {});
  }

  void diminuirQuantidade(Produto p) {
    var item = procurarItem(p);
    if (item == null) return;

    item.quantidade = item.quantidade - 1;

    if (item.quantidade <= 0) {
      itensDoPedido.remove(item);
    }
    setState(() {});
  }

  int getQuantidade(Produto p) {
    var item = procurarItem(p);
    if (item == null) return 0;
    return item.quantidade;
  }

  void salvarPedido() {
    if (clienteSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um cliente')),
      );
      return;
    }

    if (itensDoPedido.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adicione pelo menos um produto')),
      );
      return;
    }

    DataService.adicionarPedido(clienteSelecionado!, itensDoPedido);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pedido salvo com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Pedido'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cliente:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            DropdownButton<Cliente>(
              isExpanded: true,
              value: clienteSelecionado,
              hint: const Text('Selecione um cliente'),
              items: montarDropdownClientes(),
              onChanged: (cliente) {
                setState(() {
                  clienteSelecionado = cliente;
                });
              },
            ),
            const SizedBox(height: 16),

            const Text(
              'Produtos:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: DataService.produtos.length,
                itemBuilder: (context, index) {
                  var p = DataService.produtos[index];
                  int qtd = getQuantidade(p);

                  return Card(
                    child: ListTile(
                      title: Text(p.descricao),
                      subtitle: Text(
                        formatoMoeda.format(p.preco) +
                            ' (estoque: ' +
                            p.estoque.toString() +
                            ')',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => diminuirQuantidade(p),
                          ),
                          Text(
                            qtd.toString(),
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => aumentarQuantidade(p),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const Divider(),

            // TOTAL
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TOTAL:',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  formatoMoeda.format(calcularTotal()),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: salvarPedido,
                child: const Text(
                  'SALVAR PEDIDO',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<Cliente>> montarDropdownClientes() {
    List<DropdownMenuItem<Cliente>> lista = [];
    for (var c in DataService.clientes) {
      lista.add(
        DropdownMenuItem<Cliente>(
          value: c,
          child: Text(c.nome),
        ),
      );
    }
    return lista;
  }
}
