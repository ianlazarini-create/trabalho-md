import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/data_service.dart';
import '../widgets/custom_drawer.dart';

class ProdutoScreen extends StatefulWidget {
  const ProdutoScreen({super.key});

  @override
  State<ProdutoScreen> createState() => _ProdutoScreenState();
}

class _ProdutoScreenState extends State<ProdutoScreen> {
  final formatoMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  final descricaoController = TextEditingController();
  final precoController = TextEditingController();
  final estoqueController = TextEditingController();

  void abrirCadastro() {
    descricaoController.text = '';
    precoController.text = '';
    estoqueController.text = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Novo Produto'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: descricaoController,
                  decoration: const InputDecoration(labelText: 'Descricao'),
                ),
                TextField(
                  controller: precoController,
                  decoration: const InputDecoration(labelText: 'Preco (R\$)'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                TextField(
                  controller: estoqueController,
                  decoration: const InputDecoration(labelText: 'Estoque'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: salvarProduto,
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void salvarProduto() {
    String descricao = descricaoController.text.trim();
    String precoTexto = precoController.text.replaceAll(',', '.');
    String estoqueTexto = estoqueController.text.trim();

    if (descricao.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe a descricao')),
      );
      return;
    }

    double? preco = double.tryParse(precoTexto);
    if (preco == null || preco <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preco invalido')),
      );
      return;
    }

    int? estoque = int.tryParse(estoqueTexto);
    if (estoque == null || estoque < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Estoque invalido')),
      );
      return;
    }

    DataService.adicionarProduto(descricao, preco, estoque);
    Navigator.pop(context);
    setState(() {});
  }

  void removerProduto(int id) {
    DataService.removerProduto(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var lista = DataService.produtos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const CustomDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: abrirCadastro,
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: lista.isEmpty
          ? const Center(child: Text('Nenhum produto cadastrado.'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: lista.length,
              itemBuilder: (context, index) {
                var p = lista[index];
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(Icons.inventory_2, color: Colors.white),
                    ),
                    title: Text(p.descricao),
                    subtitle: Text(
                      formatoMoeda.format(p.preco) +
                          '   Estoque: ' +
                          p.estoque.toString(),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => removerProduto(p.id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
