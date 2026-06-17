import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../widgets/custom_drawer.dart';

class ClienteScreen extends StatefulWidget {
  const ClienteScreen({super.key});

  @override
  State<ClienteScreen> createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  final nomeController = TextEditingController();
  final cpfController = TextEditingController();
  final telefoneController = TextEditingController();

  void abrirCadastro() {
    nomeController.text = '';
    cpfController.text = '';
    telefoneController.text = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Novo Cliente'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                TextField(
                  controller: cpfController,
                  decoration: const InputDecoration(labelText: 'CPF / CNPJ'),
                ),
                TextField(
                  controller: telefoneController,
                  decoration: const InputDecoration(labelText: 'Telefone'),
                  keyboardType: TextInputType.phone,
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
              onPressed: salvarCliente,
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void salvarCliente() {
    String nome = nomeController.text.trim();
    String cpf = cpfController.text.trim();
    String telefone = telefoneController.text.trim();

    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe o nome')),
      );
      return;
    }
    if (cpf.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe o CPF/CNPJ')),
      );
      return;
    }
    DataService.adicionarCliente(nome, cpf, telefone);

    Navigator.pop(context);
    setState(() {}); 
  }

  void removerCliente(int id) {
    DataService.removerCliente(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var lista = DataService.clientes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
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
          ? const Center(child: Text('Nenhum cliente cadastrado.'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: lista.length,
              itemBuilder: (context, index) {
                var c = lista[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        c.nome[0].toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(c.nome),
                    subtitle: Text(c.cpfCnpj + '\n' + c.telefone),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => removerCliente(c.id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
